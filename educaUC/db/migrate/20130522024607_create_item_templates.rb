class CreateItemTemplates < ActiveRecord::Migration
  def change
    create_table :item_templates do |t|
      t.string :nombre
      t.string :descrpcion
      t.integer :subescala_template_id
      t.boolean :has_na
      t.integer :numero

      t.timestamps
    end
  end
end
