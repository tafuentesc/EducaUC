class Evaluacion < ActiveRecord::Base
	attr_accessible :encargado, :fecha_de_evaluacion, :horario_final, :horario_inicial, :nombre_sala, :escala_attributes, :estado, :centro_id, :razon
	has_one :escala, :dependent => :destroy
	belongs_to :user, :foreign_key => :encargado
	belongs_to :centro, :foreign_key => :centro_id
	accepts_nested_attributes_for :escala
  #TODO: Agregar condiciones de rechazo (:reject_if)
	
	validates_presence_of :nombre_sala
  
  # Attributo virtual para asignar sala:
  def sala
  	return Sala.find_by_name(nombre_sala)
  end
  
  def sala=(sala)
  	self.nombre_sala = sala.nombre
  end
end
