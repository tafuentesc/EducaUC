class Indicador < ActiveRecord::Base
  attr_accessible :eval, :indicador_template_id, :item_id
  belongs_to :item, :inverse_of => :indicador
  belongs_to :indicador_template  
end
