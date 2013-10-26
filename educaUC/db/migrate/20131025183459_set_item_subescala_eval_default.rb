class SetItemSubescalaEvalDefault < ActiveRecord::Migration
  def up
  	change_column_default(:items, :eval, 0)
  	change_column_default(:subescalas, :eval, 0)
  	
  	# actualizamos registros:
  	# En el caso de Item y subescalas, el minimo es 0
  	Item.where(:eval => nil).each do |it|
  		it.eval = 0
  		it.save
  	end
  	Subescala.where(:eval => nil).each do |sc|
  		sc.eval = 0
  		sc.save
  	end

  	
  end

  def down
  	# Botamos las restricciones:
  	change_column_default(:indicadors, :eval, nil)
  	change_column_default(:indicadors, :eval, nil)


  	# En el caso de Item y subescalas, el minimo es 0
  	Item.where(:eval => nil).each do |it|
  		it.eval = nil
  		it.save
  	end

		# volvemos los valores a su estado original
  	Subescala.where(:eval => nil).each do |sc|
  		sc.eval = nil
  		sc.save
  	end
  end
end
