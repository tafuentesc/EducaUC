class ChangeIndicadorFirstColumnEvalConvention < ActiveRecord::Migration
  def change
  	# Cambiamos el valor de los indicadores de la primera columna de forma
  	# que los sí sean 0 y los no 1 (opuesto al resto de las columnas)
  	its = IndicadorTemplate.where(:columna => 1)
  	
  	its.each do |it|
  		inds = Indicador.where(:indicador_template_id => it.id)
  		
  		inds.each do |ind|
  			if(ind.eval == 1)
  				ind.eval = 0
  			elsif(ind.eval == 0)
  				ind.eval = 1
  			end
  			
  			ind.save
  		end
  	end
  end
end
