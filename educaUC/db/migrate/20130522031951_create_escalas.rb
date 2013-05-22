class CreateEscalas < ActiveRecord::Migration
  def change
    create_table :escalas do |t|
      t.integer :escala_template_id
      t.integer :evaluacion_id
      t.integer :eval

      t.timestamps
    end
  end
end
