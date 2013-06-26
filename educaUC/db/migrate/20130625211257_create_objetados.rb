class CreateObjetados < ActiveRecord::Migration
  def change
    create_table :objetados do |t|
      t.integer :evaluacion_id
      t.integer :admin_id
      t.string :razon

      t.timestamps
    end
  end
end
