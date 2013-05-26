class AddColumnObservacionesToItem < ActiveRecord::Migration
  def change
    add_column :items, :observaciones, :string
  end
end
