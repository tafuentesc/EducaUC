class Item < ActiveRecord::Base
  attr_accessible :eval, :item_template_id, :subescala_id, :observaciones, :indicador_attributes
  has_many :indicador, :dependent => :destroy
  belongs_to :subescala
  belongs_to :item_template
  
  accepts_nested_attributes_for :indicador

	# método usado para recalcular la nota  
  def calcular_nota
  	nota = 1
  	
  	# Buscamos el primer no:
  	first_no = indicador.order("id ASC").where(:eval => 0).first
  	
  	# si no tiene, significa que el item está vacío => lo dejamos como está
  	if(first_no == nil)
  		return
  	end
  	
  	# una vez obtenido, chequeamos a qué columna pertenerce.
  	# si pertenece a la primera, sabemos que la nota es 1
  	if(first_no.columna == 1)
  		self.eval = 1
  	# en otro caso, debemos chequear si su fila es mayor
  	else
  		# obtenemos cantidad de indicadores en dicha columna
  		count = 0
  		indicador.each do |ind|
  			if(ind.columna == first_no.columna)
  				count = count + 1
  			end
  		end
  		
  		# si está pasado la mitad, entonces eval = columna -1;
  		# en caso contrario, eval = columna - 2:
  		if(first_no.fila >= (count + 1)/2)
  			self.eval = first_no.columna - 1
  		else
  			self.eval = first_no.columna - 2
  		end
  	end
  	
  	self.save
  end
  
end	# end Item
