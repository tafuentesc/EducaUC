class ChangeIndicadorEvalTypeToInteger < ActiveRecord::Migration
  def up
    execute("ALTER TABLE indicadors ALTER eval TYPE integer 
    	USING CASE eval
    		WHEN true THEN 1
    		WHEN false THEN 0
    		ELSE null END;")
  end

  def down
  	change_column :indicadors, :eval, :boolean
  end
end
