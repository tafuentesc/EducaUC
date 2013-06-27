class ChangeEvaluacionColumn < ActiveRecord::Migration
  def up
    execute("ALTER TABLE evaluacions ALTER estado DROP DEFAULT;")

    execute("ALTER TABLE evaluacions ALTER estado TYPE integer 
    	USING CASE estado
    		WHEN 'Pendiente' THEN 0
    		ELSE 0 END;")
    
    change_column :evaluacions, :estado, :integer, :default => -1
  end

  def down
  	change_column_default :evaluacions, :estado, nil

    execute("ALTER TABLE evaluacions ALTER estado TYPE varchar(255);")
    
    change_column :evaluacions, :estado, :string, :default => "Creada"
  end
end
