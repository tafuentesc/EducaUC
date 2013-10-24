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
  before_save :check_eval
   
  def check_eval
  	to_return =  nil										# variable que indicará si eval es correcto
  
  	# revisamos los casos en los que podría fallar

  	# 1. El valor está fuera de rango
  	if(self.eval != 1 && self.eval != 0 && self.eval != -2)
  		# Si no es ni 'sí' ni 'no' y tampoco está en blanco, entonces revisamos que esté marcado
  		# como NA y efectivamente el indicador soporte NA:
  		if(self.eval == -1 && self.indicador_template.has_na)
  			to_return = true								# si soporta NA, entonces es válido
  		else
  			to_return = false								# en caso contrario, retornamos false
  		end
  	else
  		to_return = true									# si caimos aquí significa que está en el rango adecuado
  	end
  	
  	return to_return
  end
   
  # métodos para obtener la fila y columna del indicador:
  # (las usamos para agruparlos por columna y ordenarlos por fila)
  def columna
  	return indicador_template.columna
  end
  
  def fila
  	return indicador_template.fila
  end
end
