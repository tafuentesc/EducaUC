class CreateIndicadors < ActiveRecord::Migration
  def change
    create_table :indicadors do |t|
      t.integer :indicador_template_id
      t.integer :item_id
      t.boolean :eval

      t.timestamps
    end
  end
end
