class ChangeIndicadorTemplateColumns < ActiveRecord::Migration
  def up
  	change_column :indicador_templates, :tooltip, :text
  	change_column :indicador_templates, :descripcion, :text
  end

  def down
  	change_column :indicador_templates, :tooltip, :string
  	change_column :indicador_templates, :descripcion, :string
  end
end
