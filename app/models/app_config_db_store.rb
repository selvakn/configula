class AppConfigDBStore < ActiveRecord::Base
  set_table_name :app_config
  
  def self.latest
    find :last, :order => :version
  end
  
  def self.next_version_number
    latest_config = latest
    return 1 unless latest_config
    latest_config.version + 1
  end
end