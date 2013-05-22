class Subescala < ActiveRecord::Base
  attr_accessible :escala_id, :eval, :subescala_template_id
  has_many :item
  belongs_to :escala
end
