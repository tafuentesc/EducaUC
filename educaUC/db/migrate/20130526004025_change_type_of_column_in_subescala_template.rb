class ChangeTypeOfColumnInSubescalaTemplate < ActiveRecord::Migration
  def up
  	connection.execute('ALTER TABLE subescala_templates ALTER escala_template_id TYPE integer USING escala_template_id::int')
  end

  def down
    change_column :subescala_templates, :escala_template_id, :string
  end
end
