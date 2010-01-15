require File.expand_path(File.dirname(__FILE__) + '/../../../rails_spec_helper')

describe Admin::ConfigulaController, :type => :controller do
  integrate_views

  before(:each) do
    @actual_config = AppConfig.dup
  end
  
  after(:each) do
    AppConfig.reset(@actual_config)
  end
  
  it "should list all the available config" do
    get :index
    response.body.should == AppConfig.to_json
  end
  
  it "should change the AppConfig for the given key(s) with those values" do
    post :update, "config" => {"config1" => "config1_newvalue"}
    AppConfig.config1.should == "config1_newvalue"
  end
  
  it "should update the config" do
    AppConfig.config1.should == @actual_config.config1
    AppConfig.config2.should == @actual_config.config2

    post :update, "config" => {"config1" => "value1", "config2" => "config2_newvalue"}
    AppConfig.config1.should == "value1"
    AppConfig.config2.should == "config2_newvalue"
  end
end