class CreateSalas < ActiveRecord::Migration
  def change
    create_table :salas do |t|
      t.string :nombre
      t.integer :centro_id

      t.timestamps
    end
  end
end
