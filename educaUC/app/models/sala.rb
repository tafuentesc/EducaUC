class Sala < ActiveRecord::Base
  attr_accessible :centro_id, :nombre
  belongs_to :centro
end
