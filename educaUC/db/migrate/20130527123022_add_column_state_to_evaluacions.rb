class AddColumnStateToEvaluacions < ActiveRecord::Migration
  def change
  	add_column  :evaluacions, :estado, :string, :null => false, :default => 'Pendiente'
  	add_column  :evaluacions, :razon, :string, :null => true
  	add_column  :evaluacions, :centro_id, :integer
  end
end
