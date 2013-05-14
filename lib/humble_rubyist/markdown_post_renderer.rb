require 'redcarpet'
require 'pygments'

module HumbleRubyist

  class MarkdownPostRenderer
    class PygmentizedCuttingHtmlRenderer < Redcarpet::Render::HTML
      CUT = /^<!-- more -->$/

      def initialize(options = {})
        @cut = options.delete(:cut)
        super(options)
      end

      def block_code(code, language = :ruby)
        Pygments.highlight(code, lexer: language, options: { linenos: "table" })
      end

      def preprocess(doc)
        @cut ? doc.split(CUT).first : doc
      end
    end

    def initialize(render_options = {})
      @render_options = render_options
    end

    def render(post)
      renderer = Redcarpet::Markdown.new(PygmentizedCuttingHtmlRenderer.new(@render_options),
                                         no_intra_emphasis: true,
                                         fenced_code_blocks: true,
                                         autolink: true,
                                         tables: true,
                                         with_toc_data: true,
                                         no_styles: true)
      renderer.render(post.content)
    end
  end

end

