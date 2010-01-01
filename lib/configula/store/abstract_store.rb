module Canfigula
  module Store
    module AbstractStore

      module ClassMethods
        def load
          raise_no_store_error
        end
        
        def raise_no_store_error
          raise Configula::ConfigError.new("No store is cofigured")
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