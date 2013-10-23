class Item < ActiveRecord::Base
  attr_accessible :eval, :item_template_id, :subescala_id, :observaciones, :indicador_attributes
  has_many :indicador, :dependent => :destroy
  belongs_to :subescala
  belongs_to :item_template
  
  accepts_nested_attributes_for :indicador

	# método usado para recalcular la nota  
  def calcular_nota

  	# Buscamos el primer no:
  	first_no = self.indicador.order("id ASC").where(:eval => 0).first
  	
  	# si no tiene, significa que el item está vacío => lo dejamos como está
  	if(first_no == nil)
  		return
  	end
  	
  	# una vez obtenido, chequeamos a qué columna pertenerce.
  	# si pertenece a la primera, sabemos que la nota es 1
  	if(first_no.columna == 1)
  		self.eval = 1
  		
  	# en otro caso, debemos contar la cantidad de sis en dicha columna
  	else
  		si_count = 0
  		ind_count = 0
  		self.indicador.each do |ind|
  			if(ind.columna == first_no.columna)
  				ind_count += 1	# Contador para almacenar la cantidad totol de indicadores en la columna

  				if(ind.eval == 1)
  					si_count += 1	# Contador para almacenar la cantidad de sis en la columna
  				end
  			end
  		end
  		
  		# Evaluamos la cantidad de si's respecto al total de indicadores
  		# si es más de la mitad, entonces eval = columna -1;
  		# en caso contrario, eval = columna - 2:
			self.eval = first_no.columna
  		if((si_count.to_f/ind_count) >= 0.5)
  			self.eval -= 1
  		else
  			self.eval -= 2
  		end
  	end
  	
  	self.save
  end
  
end	# end Item
