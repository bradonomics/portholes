class AddSubscriberToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :stripe_id, :string
    add_column :users, :subscriber, :boolean, default: false
  end
end
