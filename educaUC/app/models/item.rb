class Item < ActiveRecord::Base
  attr_accessible :eval, :item_template_id, :subescala_id, :observaciones, :indicador_attributes
  has_many :indicador, :dependent => :destroy
  belongs_to :subescala
  belongs_to :item_template
  
  accepts_nested_attributes_for :indicador
  
  before_save :check_eval
  
  # método que revisa que la nota asignada a un determinado ítem sea correcta.
  # por ahora lo usaremos para validar que si el ítem puede ser NA o no.
  def check_eval
  	# si es nil lo dejamos => el default se setea una vez guardado:
  	if(self.eval == nil)
  		return true
  	end
  
  	if(self.eval <= 7 && self.eval >= 0)
  		return true
  	elsif(self.item_template.has_na && self.eval == -1)
  		return true
  	else
  		return false
  	end
  end

	# método usado para recalcular la nota  
  def calcular_nota
		# Primero, revisamos si el ítem está marcado como NA. En caso de ser así,
		# seteamos su nota como 0 y no hacemos nada
		if(self.eval == -1)
  		return											
  	end
			

  	# Buscamos el primer no:
  	first_no = self.indicador.order("id ASC").where(:eval => 0).first
  	
  	# si no tiene, significa que el item está vacío => lo seteamos en 0
  	if(first_no == nil)
  		self.eval = 0								# lo actualizamos de todas formas por si antes había sido llenado
  		self.save
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
