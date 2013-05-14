require 'pygments'

module HumbleRubyist

  class MarkdownHtmlRenderer < Redcarpet::Render::HTML
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

end

