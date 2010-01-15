module Configula
  module Store
    module AbstractStore
      attr_accessor :store
      
      def load_from_store
        raise_no_store_error
      end

      def persist
        raise_no_store_error
      end
      
      def store=(store)
        @store = store
        extend(store[:name]) if store and store[:name]
      end
      
      def raise_no_store_error
        raise Configula::ConfigError.new("No store is cofigured")
      end
    end
  end
end