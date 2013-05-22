class EscalaTemplate < ActiveRecord::Base
  attr_accessible :nombre
  has_many :subescala_template
end
