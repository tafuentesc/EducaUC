class Subescala < ActiveRecord::Base
  attr_accessible :escala_id, :eval, :subescala_template_id, :item_attributes
  has_many :item, :dependent => :destroy
  belongs_to :escala
  belongs_to :subescala_template
  
  accepts_nested_attributes_for :item
end
