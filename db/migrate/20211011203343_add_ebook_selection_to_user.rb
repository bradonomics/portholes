class AddEbookSelectionToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :ebook_preference, :string
  end
end
