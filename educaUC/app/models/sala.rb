class Sala < ActiveRecord::Base
  attr_accessible :centro_id, :nombre
  belongs_to :centro
  
  # Lo anterior es equivalente a:
  # has_many :evaluaciones, :dependent => :destroy
  
  # Si se borra, se deben destruir las evaluaciones asociadas
  # debe ser before o no podremos saber cuáles tenemos que destruir
  before_destroy :destroy_dependent_evaluaciones
  
  # el nombre debe ser único para un centro dado!
  validates_uniqueness_of :nombre, :scope => [:centro_id]
  
  # Atributo virtual para acceder a las evaluaciones de una sala
  def evaluaciones
  	evals = Evaluacion.where(:nombre_sala => nombre, :centro_id => centro)
  end
  
  def evaluaciones=(evals)
  	# primero, debemos desasignar todas las evaluaciones previas => no se puede!
  	evals_old = Evaluacion.where(:nombre_sala => nombre, :centro_id => centro)

  	evals_old.each do |eval|
  		# al hacer esto hace rollback, pues Evaluacion.nombre_sala no puede ser nil
  		# => sólo se pueden agregar evaluaciones xD
  		eval.update_attribute(:sala, nil)
  	end  	
  
  	# para cada evaluación en la lista, cambiamos su sala
  	evals.each do |eval|
  		eval.update_attribute(:sala, self)
  	end
  end
  
  # Método que destruye las evaluaciones asociadas
  def destroy_dependent_evaluaciones
  	self.evaluaciones.each do |eval|
  		eval.destroy
  	end
  end
end
