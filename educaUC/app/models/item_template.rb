class ItemTemplate < ActiveRecord::Base
  attr_accessible :descripcion, :has_na, :nombre, :numero, :subescala_template_id
  has_many :indicador_template
  belongs_to :subescala_template
end
