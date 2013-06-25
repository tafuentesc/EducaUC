class Evaluacion < ActiveRecord::Base
	attr_accessible :encargado, :fecha_de_evaluacion, :horario_final, :horario_inicial, :nombre_sala, :escala_attributes, :estado, :centro_id, :razon
	has_one :escala, :dependent => :destroy
	belongs_to :user, :foreign_key => :encargado
	belongs_to :centro, :foreign_key => :centro_id
	accepts_nested_attributes_for :escala
  #TODO: Agregar condiciones de rechazo (:reject_if)
	
	validates_presence_of :nombre_sala
	validates_presence_of :centro_id
	
	before_save :check_sala
  
  def check_sala
  	c = self.centro
  	s = Sala.find_by_nombre_and_centro_id(self.nombre_sala, self.centro.id)
  	
  	# si la sala no existe, la creamos:
  	if(s.nil?)
  		s = Sala.create(:nombre => self.nombre_sala, :centro_id => self.centro.id)
  	end
  end
  
  # Attributo virtual para acceder a la sala:
  def sala
  	s = Sala.find_by_nombre_and_centro_id(self.nombre_sala, self.centro.id)
  	
  	if(s.nil?)
  		return nil
  	else
  		return s
  	end
  end
  
  def sala=(s) 	
  	if(s.nil?)
  		self.nombre_sala = nil
  		self.centro = nil
  	else
  		self.nombre_sala = s.nombre
  		self.centro = s.centro
  	end
  end
end
