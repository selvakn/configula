class ConfigulaGenerator < Rails::Generator::Base
  default_options :skip_sample_config => false,
                  :skip_images_and_js => false
  
  def manifest
    record do |m|
      m.file 'app_config.rb', File.join("config", "initializers", "app_config.rb")
      
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

  private
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
