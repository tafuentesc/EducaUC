class IndicadorTemplate < ActiveRecord::Base
  attr_accessible :columna, :descripcion, :fila, :has_na, :item_template_id
  belongs_to :item_template
end
