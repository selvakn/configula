module Configula
  module Store
    class LoadFromStoreError < ConfigError
    end
    
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
        raise_load_error "No store is cofigured"
      end
      
      def raise_load_error(message)
        raise LoadFromStoreError.new(message)
      end
    end
  end
end