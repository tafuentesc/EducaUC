class SetIndicadorEvalDefault < ActiveRecord::Migration
  def up
  	# seteamos el default como -2 para representar aquellos indicadores
  	# que no fueron rellenados
  	change_column :indicadors, :eval, :integer, :default => -2
  	
  	# Para los valores actualmente en la base de datos actualizamos su valor
  	# por defecto (nil) al nuevo valor:
  	Indicador.where(:eval => nil).each do |ind|
  		ind.eval = -2
  		ind.save
  	end
  end

  def down
  	# botamos el default:
  	change_column_default(:indicadors, :eval, nil)
  	
  	# volvemos a dejar los valores con -2 en nil
  	Indicador.where(:eval => -2).each do |ind|
  		ind.eval = nil
  		ind.save
  	end
  end
end
