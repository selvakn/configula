module Configula
  module Store
    module YamlStore

      def load_from_store
        reset YAML.load_file(store[:file])
      end
      
      def persist
        File.open(store[:file], "w") {|file| file << to_yaml }
      end
      
    end
  end
end