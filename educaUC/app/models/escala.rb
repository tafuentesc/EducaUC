class Escala < ActiveRecord::Base
  attr_accessible :escala_template_id, :eval, :evaluacion_id
  has_many :subescala
  belongs_to :evaluacion
end
