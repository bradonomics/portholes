class AddHelloTokenToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :hello_token, :string
  end
end
