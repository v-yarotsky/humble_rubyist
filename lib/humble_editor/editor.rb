module HumbleEditor

  class Editor
    class AlreadyBuildingPostError < StandardError; end
    class NoPostError < StandardError; end

    POST_ATTRIBUTES = [:title, :slug, :content, :icon, :published_at].freeze

    def initialize(api_root, key)
      @key = key
      raise ArgumentError, "Need API key!" if String(@key).empty?
      @api_root = api_root
      raise ArgumentError, "Need API host!" if String(@api_root).empty?
    end

    def new_post(params)
      raise AlreadyBuildingPostError if @post
      @post = Hash[default_post_params.merge(params).select { |k, v| POST_ATTRIBUTES.include?(k) }]
      @new_post = true
    end

    def open_post(id)
      raise AlreadyBuildingPostError if @post
      result = api_get("/api/posts/#{id}")
      if result.delete(:success)
        @new_post = false
        @post = result.inject({}) { |r, (k, v)| r[k.to_sym] = v; r }
      end
    end

    def show_post
      @post
    end

    def show_list
      result = api_get("/api/posts")
      if result.delete(:success)
        result["posts"].map { |p| "%d) %10s [%s] %s" % [p["id"], p["published_at"], p["slug"], p["title"]] }
      end
    end

    def default_post_params
      {
        icon: "ruby"
      }
    end
    private :default_post_params

    def commit_post!
      raise NoPostError unless @post

      to_params = proc { |post| Hash[post.map { |k, v| ["post[#{k}]", v] }] }

      result = if @new_post
        @post[:published_at] = Time.now
        api_post("/api/posts", to_params[@post])
      else
        api_put("/api/posts/#{@post[:id]}", to_params[@post])
      end
      @post = nil if result[:success]
    end

    def cancel!
      @post = nil
      @new_post = nil
    end

    def editing?
      !!@post
    end

    def edit_content
      raise NoPostError unless @post
      require 'tempfile'
      f = Tempfile.open(@post[:slug])
      f.write(@post[:content])
      f.close
      system(ENV["EDITOR"], f.path)
      new_content = File.read(f.path)
      if new_content.empty?
        warn "Empty new content. Keeping previous"
      else
        @post[:content] = new_content
      end
      @post
    rescue Errno::ENOENT => e
      warn "Tempfile vanished"
      retry
    ensure
      f.unlink if f
    end

    def api_get(api_path)
      require 'net/http'
      uri = URI.join(@api_root, api_path)
      request = Net::HTTP::Get.new(uri.path)
      response = Net::HTTP.start(uri.host, uri.port) { |http| http.request(request) }
      JSON.parse(response.body).merge(success: response.code == "200")
    end
    private :api_get

    def api_post(api_path, params = {})
      require 'net/http'
      uri = URI.join(@api_root, api_path)
      request = Net::HTTP::Post.new(uri.path)
      request.form_data = params.merge(key: @key)
      response = Net::HTTP.start(uri.host, uri.port) { |http| http.request(request) }
      JSON.parse(response.body).merge(success: response.code == "200")
    end
    private :api_post

    def api_put(api_path, params = {})
      api_post api_path, params.merge(:_method => "PUT")
    end
    private :api_put
  end

end

