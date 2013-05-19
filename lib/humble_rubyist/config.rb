module HumbleRubyist

  class Config
    def initialize
      yield self if block_given?
    end

    def method_missing(method, *args, &block)
      if /\A(?<attribute_name>.+)=\Z/ =~ method.to_s
        self.class.class_eval { attr_accessor attribute_name }
        send(method, *args)
      else
        super
      end
    end
  end

end

