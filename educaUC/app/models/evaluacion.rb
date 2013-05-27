class Evaluacion < ActiveRecord::Base
	attr_accessible :encargado, :fecha_de_evaluacion, :horario_final, :horario_inicial, :nombre_sala, :escala_attributes
	has_one :escala, :dependent => :destroy
	belongs_to :user, :foreign_key => :encargado
	accepts_nested_attributes_for :escala
  #TODO: Agregar condiciones de rechazo (:reject_if)
  
end
