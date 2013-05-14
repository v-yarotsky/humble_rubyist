require 'shellissimo'

module HumbleEditor

  class Shell < Shellissimo::Shell
    command :new do |c|
      c.description "Make new post"
      c.mandatory_param(:slug) do |p|
        p.validate { |v| /\A[-\w]+\Z/ =~ v }
      end
      c.mandatory_param(:title) do |p|
        p.validate { |v| !v.strip.empty? }
      end
      c.param(:icon)
      c.run { |params| @app.new_post(params) }
    end

    command :open do |c|
      c.description "Edit existing post"
      c.mandatory_param(:id)
      c.run { |params| @app.open_post(params[:id]) }
    end

    command :edit do |c|
      c.description "Edit post content with EDITOR"
      c.run  { |*| @app.edit_content }
    end

    command :show do |c|
      c.description "Show current post"
      c.run  { |*| @app.show_post }
    end

    command :commit do |c|
      c.description "Push post to server"
      c.run { |params| @app.commit_post! }
    end

    command :cancel do |c|
      c.description "Cancel editing post"
      c.run { |params| @app.cancel! }
    end

    command :list do |c|
      c.description "List existing posts"
      c.run { |params| @app.show_list }
    end

    def initialize(app)
      @app = app
      super
    end

    def prompt
      @app.editing? ? "(editing) " + super : super
    end
  end

end

