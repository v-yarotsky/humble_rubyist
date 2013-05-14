require 'redcarpet'
require 'humble_rubyist/markdown_html_renderer'

module HumbleRubyist

  class MarkdownPostRenderer
    def initialize(render_options = {})
      @render_options = render_options
    end

    def render(post)
      renderer = Redcarpet::Markdown.new(MarkdownHtmlRenderer.new(@render_options),
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

