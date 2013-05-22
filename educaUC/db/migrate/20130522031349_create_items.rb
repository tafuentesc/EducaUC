class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :item_template_id
      t.integer :subescala_id
      t.integer :eval

      t.timestamps
    end
  end
end
