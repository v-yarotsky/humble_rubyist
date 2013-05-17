actions :create, :enable, :restart

attribute :name, :kind_of => String, :name_attribute => true, :required => true
attribute :path, :kind_of => String, :required => true
attribute :app_path, :kind_of => String, :required => true
attribute :environment, :kind_of => String, :default => "development"

