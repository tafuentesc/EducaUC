class ChangeNameOfUserDeleteToUserActive < ActiveRecord::Migration
  def change
  	rename_column :users, :deleted, :active
  end
end
