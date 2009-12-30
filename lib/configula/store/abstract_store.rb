module Canfigula
  module Store
    module YamlStore

      module ClassMethods
        def load
          raise "No store is cofigured"
        end
      end

      def persist

      end

      def self.included(klass)
        klass.extend ClassMethods
      end
      
      def raise_no_store_error
        
      end
    end
  end
end