require 'rubygems'
begin
  gem "rspec"
  gem "rspec-rails"
  
  require 'spec/rake/spectask'
  Spec::Rake::SpecTask.new("spec") do |t|
    t.spec_files = FileList['spec/**/*_spec.rb']
    t.spec_opts = ['--color --format profile --loadby mtime --reverse']
  end
  
  task :default do
    Rake::Task['spec'].invoke
  end
end