
ENV["RAILS_ENV"] ||= 'test'
require File.dirname(__FILE__) + "/rails_root/config/environment" unless defined?(RAILS_ROOT)
require File.join( File.dirname( __FILE__ ), '..', 'lib', 'configula' )

require 'spec/autorun'
require 'spec/rails'

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
end
