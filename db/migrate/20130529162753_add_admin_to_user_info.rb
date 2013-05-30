class AddAdminToUserInfo < ActiveRecord::Migration
  def change
    add_column :user_infos, :admin, :boolean
  end
end
