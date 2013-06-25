class Centro < ActiveRecord::Base
  attr_accessible :direccion, :directora, :nombre, :sostenedor, :telefono
  has_many :evaluacions
  has_many :salas
end
