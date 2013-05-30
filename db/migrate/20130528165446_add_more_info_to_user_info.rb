class AddMoreInfoToUserInfo < ActiveRecord::Migration
  def change
    add_column :user_infos, :name, :string, :unique => true
    add_column :user_infos, :first_name, :string
    add_column :user_infos, :last_name, :string
    add_column :user_infos, :address, :string
    add_column :user_infos, :city, :string
    add_column :user_infos, :province, :string
    add_column :user_infos, :country, :string
    add_column :user_infos, :postal_code, :string
    add_column :user_infos, :phone, :string
  end
end
