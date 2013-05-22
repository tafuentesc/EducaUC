class CreateSubescalas < ActiveRecord::Migration
  def change
    create_table :subescalas do |t|
      t.integer :subescala_template_id
      t.integer :escala_id
      t.integer :eval

      t.timestamps
    end
  end
end
