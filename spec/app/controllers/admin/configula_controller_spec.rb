require File.expand_path(File.dirname(__FILE__) + '/../../../rails_spec_helper')

describe Admin::ConfigulaController, :type => :controller do
  before(:each) do
    @actual_config = AppConfig.dup
  end
  
  after(:each) do
    AppConfig.reset(@actual_config)
  end
  
  it "should change the AppConfig for the given key(s) with those values" do
    post :update, "config" => {"config1" => "config1_newvalue"}.to_json
    AppConfig.config1.should == "config1_newvalue"
  end
  
  it "should update the config" do
    AppConfig.config1.should == @actual_config.config1
    AppConfig.config2.should == @actual_config.config2

    post :update, "config" => {"config1" => "value1", "config2" => "config2_newvalue"}.to_json
    AppConfig.config1.should == "value1"
    AppConfig.config2.should == "config2_newvalue"
  end
end