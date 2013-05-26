class Subescala < ActiveRecord::Base
  attr_accessible :escala_id, :eval, :subescala_template_id, :name
  has_many :item
  belongs_to :escala
  belongs_to :subescala_template
  
end
