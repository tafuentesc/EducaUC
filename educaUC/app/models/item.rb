class Item < ActiveRecord::Base
  attr_accessible :eval, :item_template_id, :subescala_id, :observaciones, :indicador_attributes
  has_many :indicador, :dependent => :destroy
  belongs_to :subescala
  belongs_to :item_template
  
  accepts_nested_attributes_for :indicador
end
