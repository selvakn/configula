module Canfigula
  module Store
    module YamlStore

      module ClassMethods
        def load_from_store
          file_name = Configula::Base.persistance_options[:file]
          from_hash YAML.load_file(file_name)
        end
      end

      def persist
        file_name = self.class.persistance_options[:file]
        File.open(file_name, "w"){|file| file << to_yaml}
      end

      def self.included(klass)
        klass.extend ClassMethods
      end
    end
  end
end