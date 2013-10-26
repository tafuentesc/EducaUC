class ChangeItemObservacionesToText < ActiveRecord::Migration
  def up
  	change_column :items, :observaciones, :text
  end

  def down
  	change_column :items, :observaciones, :string
  end
end
