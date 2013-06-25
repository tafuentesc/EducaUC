class AddTooltipToIndicadorTemplate < ActiveRecord::Migration
  def change
    add_column :indicador_templates, :tooltip, :string
  end
end
