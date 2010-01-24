module Configula
  module Store
    module DBStore

      def load_from_store
        check_table_created
        config_from_db = AppConfigDBStore.latest
        raise_load_error("No Config exists in DB") unless config_from_db
        reset YAML.load(config_from_db.config)
      end

      def persist
        check_table_created
        AppConfigDBStore.create!(:config => to_yaml, :version => AppConfigDBStore.next_version_number)
      end
      
      def check_table_created
        raise_load_error("Table not yet created. Run migration") unless AppConfigDBStore.table_exists?
      end
    end
  end
end