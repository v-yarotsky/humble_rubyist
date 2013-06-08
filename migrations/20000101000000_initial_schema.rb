Sequel.migration do
  change do
    create_table?(:posts) do
      primary_key :id
      String :slug, :size => 255
      String :title, :size => 255
      String :content, :size => 255
      DateTime :published_at
      String :icon, :size => 255
    end
  end
end

