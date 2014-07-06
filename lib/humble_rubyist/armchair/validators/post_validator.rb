module HumbleRubyist
  module Armchair
    module Validators

      class PostValidator
        def initialize(response)
          @response = response
          @still_valid = true
        end

        # Adds errors on @response.
        # Yields if preliminary validations passed. Should be invoked to persist the Post
        # Rescues [DuplicatePost] and adds duplicate post error
        #
        def ensure_valid_and_yield(post)
          %i(title category id).each do |attr_name|
            error!(attr_name, "must not be empty") if post[attr_name].empty?
          end
          yield if block_given? && still_valid?
        rescue DuplicatePost => e
          error!(:id, "is already occupied")
        end

        def still_valid?
          @still_valid
        end

        private

        def error!(attr_name, message)
          @response.error!(attr_name, message)
          @still_valid = false
        end
      end

    end
  end
end
