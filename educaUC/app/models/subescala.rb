class Subescala < ActiveRecord::Base
  attr_accessible :escala_id, :eval, :subescala_template_id, :item_attributes
  has_many :item, :dependent => :destroy
  belongs_to :escala
  belongs_to :subescala_template
  
  accepts_nested_attributes_for :item
  
  # método usado para calcular la nota
  def calcular_nota
  	nota = 0
  	count = 0

  	# Promediamos la nota de todos los items de la subescala cuya nota sea mayor a cero:  	
  	item.each do |it|
  		it.calcular_nota
  		
  		if(it.eval != nil && it.eval > 0)
  			nota = nota + it.eval
  			count = count + 1
  		end
  	end
  	
  	# Sacamos el promedio (redondeamos)
  	
  	# Si count es cero, entonces la subescala está en blanco
  	# => no hacemos nada
  	if(count == 0)
  		return
  	end
  	
  	self.eval = (nota.to_f/count).round
  	self.save
  end
end
