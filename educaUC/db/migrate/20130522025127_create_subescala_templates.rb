class CreateSubescalaTemplates < ActiveRecord::Migration
  def change
    create_table :subescala_templates do |t|
      t.string :nombre
      t.integer :numero
      t.string :escala_template_id

      t.timestamps
    end
  end
end
