Sequel.migration do
  change do
    add_column :posts, :published, :boolean, :default => false
    run 'UPDATE posts SET published = 1'
  end
end

