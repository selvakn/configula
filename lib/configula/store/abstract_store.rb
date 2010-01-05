module Canfigula
  module Store
    module AbstractStore
      @@persistance_options = {}

      module ClassMethods
        def load_from_store
          raise_no_store_error
        end
        
        def raise_no_store_error
          raise Configula::ConfigError.new("No store is cofigured")
        end

        def persistance_options= (options = {})
          @@persistance_options = options
          include @@persistance_options[:store_name]
        end

        def persistance_options
          @@persistance_options || {}
        end
      end

      def persist
        self.class.raise_no_store_error
      end

      def self.included(klass)
        klass.extend ClassMethods
      end

    end
  end
end