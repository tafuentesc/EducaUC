class ChangeEvaluacionColumn < ActiveRecord::Migration
  def up
    change_column :evaluacion, :estado, :integer
  end

  def down
    change_column :evaluacion, :estado, :string
  end
end
