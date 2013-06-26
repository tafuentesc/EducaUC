class Escala < ActiveRecord::Base
  attr_accessible :escala_template_id, :eval, :evaluacion_id, :subescala_attributes
  has_many :subescala, :dependent => :destroy
  belongs_to :evaluacion, :inverse_of => :escala
  belongs_to :escala_template
  
  validates_presence_of :evaluacion
  accepts_nested_attributes_for :subescala
  
  #TODO: Agregar condiciones de rechazo (:reject_if)
end
