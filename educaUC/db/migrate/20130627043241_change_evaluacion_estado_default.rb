class ChangeEvaluacionEstadoDefault < ActiveRecord::Migration
  def up
  	change_column_default :evaluacions, :estado, 0
  end

  def down
  	change_column_default :evaluacions, :estado, -1
  end
end
