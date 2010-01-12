system "rsync -r --exclude='.git*' --exclude='spec' --exclude-from='#{File.dirname(__FILE__)}/../.gitignore' #{File.dirname(__FILE__)}/../ #{File.dirname(__FILE__)}/rails_root/vendor/plugins/configula"
ENV["RAILS_ENV"] ||= 'test'

require File.dirname(__FILE__) + "/rails_root/config/environment" unless defined?(RAILS_ROOT)

require 'spec/autorun'
require 'spec/rails'

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
end