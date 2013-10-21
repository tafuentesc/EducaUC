class Escala < ActiveRecord::Base
  attr_accessible :escala_template_id, :eval, :evaluacion_id, :subescala_attributes
  has_many :subescala, :dependent => :destroy
  belongs_to :evaluacion, :inverse_of => :escala
  belongs_to :escala_template
  
  accepts_nested_attributes_for :subescala
  
  #TODO: Agregar condiciones de rechazo (:reject_if)
  
  # método usado para calcular la nota
  def calcular_nota 
  	nota = 0
  	count = 0

  	# Promediamos la nota de todos los items de la subescala cuya nota sea mayor a cero:  	
  	subescala.each do |sub|
  		sub.calcular_nota
  		
  		if(sub.eval != nil && sub.eval > 0)
  			nota = nota + sub.eval
  			count = count + 1
  		end
  	end
  	
  	# Sacamos el promedio (redondeamos)
  	self.eval = (nota.to_f/count).round
  	self.save
  end

end
