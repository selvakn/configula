class ConfigulaGenerator < Rails::Generator::Base
  default_options :skip_sample_config => false,
                  :skip_images_and_js => false
  
  def manifest
    record do |m|
      store = parse_store_from_options
      m.template 'app_config.rb', File.join("config", "initializers", "app_config.rb"), :assigns => {:store => store}
      
      create_migration_for_db_store(m) if store == "DBStore"
      create_sample_config(m) unless options[:skip_sample_config]
      create_js_and_images(m) unless options[:skip_images_and_js]
    end
  end
  
  protected
  def add_options!(opt)
    opt.separator ''
    opt.separator 'Options:'
    
    opt.on('--skip-sample-config', 'Skip generation of sample config files') { |value| options[:skip_sample_config] = value }
    opt.on('--skip-images-and-js', 'Skip generation of images and javascript files') { |value| options[:skip_images_and_js] = value }
  end

  def banner
    <<-EOS
      script/generate configula [store_name] [options]
      Available stores: #{available_stores.join(", ")}.
    EOS
  end
  
  private
  def create_migration_for_db_store(m)
    m.migration_template "migrations/app_config_db_store.rb",
                         'db/migrate',
                         :migration_file_name => "create_table_app_config"
  end
  
  def parse_store_from_options
    return available_stores[0] unless ARGV[0]
    return ARGV[0] if available_stores.include?(ARGV[0])
    raise "Unknown store #{ARGV[0]}. Available store options are #{available_stores.join(' / ')}"
  end
  
  def available_stores
    ["NoStore", "YamlStore", "DBStore"]
  end
  
  def create_sample_config(m)
    m.directory File.join("config","configula")
    
    %w(
    environment
    development
    test
    production
    ).each do |env|
      file_name = "#{env}.yml"
      m.file File.join("sample_config", file_name), File.join("config", "configula", file_name)
    end
  end
  
  def create_js_and_images(m)
    m.directory File.join('public', 'configula_public', 'javascripts')
    m.directory File.join('public', 'configula_public', 'images')

    m.file File.join('public', 'javascripts', 'JSONeditor.js'), File.join('public', 'configula_public', 'javascripts', 'JSONeditor.js')
    
    %w(
    doc.gif
    docNode.gif
    docNodeFirst.gif
    docNodeLast.gif
    folder.gif
    folderNode.gif
    folderNodeLast.gif
    folderNodeLastFirst.gif
    folderNodeOpen.gif
    folderNodeOpenLast.gif
    folderNodeOpenLastFirst.gif
    folderOpen.gif
    vertLine.gif
    folderNodeOpenFirst.gif
    folderNodeFirst.gif
    docNodeLastFirst.gif
    ).each do |image|
      m.file File.join('public', 'images', image), File.join('public', 'configula_public', 'images', image)
    end
    
  end
end
