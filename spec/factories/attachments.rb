# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :attachment do
    file ActionDispatch::Http::UploadedFile.new(:tempfile => File.new("#{Rails.root}/spec/anyfile.txt"), :file_file_name => "anyfile.txt",:file_content_type => "txt", :file_file_size => 0)
  end
end
