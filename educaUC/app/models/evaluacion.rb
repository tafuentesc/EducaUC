class Evaluacion < ActiveRecord::Base
  attr_accessible :encargado, :fecha_de_evaluacion, :horario_final, :horario_inicial, :nombre_sala
  has_one :escala
end
