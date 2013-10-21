class Indicador < ActiveRecord::Base
  attr_accessible :eval, :indicador_template_id, :item_id
  belongs_to :item, :inverse_of => :indicador
  belongs_to :indicador_template 
  
  validates_presence_of :indicador_template_id 
  
  # métodos para obtener la fila y columna del indicador:
  # (las usamos para agruparlos por columna y ordenarlos por fila)
  def columna
  	return indicador_template.columna
  end
  
  def fila
  	return indicador_template.fila
  end
end
