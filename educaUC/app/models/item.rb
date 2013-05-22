class Item < ActiveRecord::Base
  attr_accessible :eval, :item_template_id, :subescala_id
  has_many :indicador
  belongs_to :subescala
end
