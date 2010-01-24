class CreateTableAppConfig < ActiveRecord::Migration
  def self.up
    create_table :app_config do |t|
      t.text  :config, :null => false
      t.integer :version, :null => false
      t.timestamps
    end

    add_index :app_config, :version, :unique => true
  end

  def self.down
    drop_table :app_config
  end
end
