class AddPhoneAndAdminToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :phone, :string
    add_column :users, :admin, :boolean, default: false
  end
end
