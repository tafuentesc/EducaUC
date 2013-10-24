class Indicador < ActiveRecord::Base
  attr_accessible :eval, :indicador_template_id, :item_id
  belongs_to :item, :inverse_of => :indicador
  belongs_to :indicador_template 
  
  validates_presence_of :indicador_template_id 
  
  # -------------------------------------------------------------------------------------
  # Se usarán los siguientes valores para la nota (eval):
  # -------------------------------------------------------------------------------------
  #  1:	El indicador fue marcado positivamente (No en la primera columna, Sí en el resto)
  #  0: El indicador fue marcado negativamente
  # -1: El indicador fue marcado como "no aplica"
  # -2: Valor por defecto, indica que el indicador no fue seteado
  # -------------------------------------------------------------------------------------  
   
  # métodos para obtener la fila y columna del indicador:
  # (las usamos para agruparlos por columna y ordenarlos por fila)
  def columna
  	return indicador_template.columna
  end
  
  def fila
  	return indicador_template.fila
  end
end
