class Objetado < ActiveRecord::Base
  attr_accessible :admin_id, :evaluacion_id, :razon
  belongs_to :user, :foreign_key => :admin_id
  belongs_to :evaluacion
  validates_uniqueness_of :evaluacion_id, :scope => [:admin_id]
end
