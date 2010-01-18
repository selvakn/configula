desc "Load Config from definition and persist in store if store is available"
namespace :configula do
  task :refresh => :environment do
    AppConfig.load_from_defn.persist
  end
end