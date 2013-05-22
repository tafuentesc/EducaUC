class SubescalaTemplate < ActiveRecord::Base
  attr_accessible :escala_template_id, :nombre, :numero
  has_many :item_template
  belongs_to :escala_template
end
