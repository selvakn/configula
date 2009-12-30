module Canfigula
  module Store
    module YamlStore

      module ClassMethods
        def load

        end
      end

      def persist

      end

      def self.included(klass)
        klass.extend ClassMethods
      end
    end
  end
end