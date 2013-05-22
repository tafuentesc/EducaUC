class CreateEvaluacions < ActiveRecord::Migration
  def change
    create_table :evaluacions do |t|
      t.string :nombre_sala
      t.datetime :fecha_de_evaluacion
      t.integer :encargado
      t.time :horario_inicial
      t.time :horario_final

      t.timestamps
    end
  end
end
