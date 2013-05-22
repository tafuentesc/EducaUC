class CreateIndicadorTemplates < ActiveRecord::Migration
  def change
    create_table :indicador_templates do |t|
      t.string :descripcion
      t.integer :item_template_id
      t.integer :columna
      t.integer :fila
      t.boolean :has_na

      t.timestamps
    end
  end
end
