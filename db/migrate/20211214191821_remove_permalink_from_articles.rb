class RemovePermalinkFromArticles < ActiveRecord::Migration[6.1]
  def change
    remove_column :articles, :permalink, :string
  end
end
