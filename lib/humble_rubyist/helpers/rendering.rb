module HumbleRubyist
  module Helpers

    module Rendering
      def template(tpl, options = {})
        slim tpl.to_sym, options
      end
    end

  end
end


