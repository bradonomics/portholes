class AddBodyToArticles < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :body, :string
  end
end
