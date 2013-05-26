class Item < ActiveRecord::Base
  attr_accessible :eval, :item_template_id, :subescala_id, :observaciones
  has_many :indicador
  belongs_to :subescala
  belongs_to :item_template
end
