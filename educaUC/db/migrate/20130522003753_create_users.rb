class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :lastname
      t.integer :deleted
      t.boolean :admin
      t.string :hash_password
      t.string :token
      t.string :salt
      t.string :profile

      t.timestamps
    end
  end
end
