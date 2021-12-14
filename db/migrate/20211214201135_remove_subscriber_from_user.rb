class RemoveSubscriberFromUser < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :stripe_id, :string
    remove_column :users, :subscriber, :boolean
  end
end
