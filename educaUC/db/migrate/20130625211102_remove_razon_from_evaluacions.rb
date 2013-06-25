class RemoveRazonFromEvaluacions < ActiveRecord::Migration
  def up
    remove_column :evaluacions, :razon
  end

  def down
    add_column :evaluacions, :razon, :string
  end
end
