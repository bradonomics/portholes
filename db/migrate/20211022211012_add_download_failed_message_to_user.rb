class AddDownloadFailedMessageToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :download_failed, :string
  end
end
