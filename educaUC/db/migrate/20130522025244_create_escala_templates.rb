class CreateEscalaTemplates < ActiveRecord::Migration
  def change
    create_table :escala_templates do |t|
      t.string :nombre

      t.timestamps
    end
  end
end
