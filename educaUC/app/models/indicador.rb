class Indicador < ActiveRecord::Base
  attr_accessible :eval, :indicador_template_id, :item_id
  belongs_to :item
  belongs_to :indicador_template
end
