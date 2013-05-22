class CreateCentros < ActiveRecord::Migration
  def change
    create_table :centros do |t|
      t.string :nombre
      t.string :direccion
      t.string :directora
      t.string :sostenedor
      t.string :telefono

      t.timestamps
    end
  end
end
