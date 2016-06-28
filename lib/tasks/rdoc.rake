namespace :rdoc do
  require 'rdoc/task'

  desc "Generate documentattion for project"
  RDoc::Task.new :generate do |rdoc|
    rdoc.main = "README.md"
    rdoc.title = "AcDP Documentation"
    rdoc.options << "--all"
  end

end
