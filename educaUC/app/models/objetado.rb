class Objetado < ActiveRecord::Base
  attr_accessible :admin_id, :evaluacion_id, :razon
  belong_to :user, :foreign_key => :admin_id
  belong_to :evaluacion
  validate_uniqueness_of :evaluacion_id, :scope => [:admin_id]
end
