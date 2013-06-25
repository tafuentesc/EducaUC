class Sala < ActiveRecord::Base
  attr_accessible :centro_id, :nombre
  belongs_to :centro
  
  # el nombre debe ser único!
  validates_uniqueness_of :nombre
end
