# coding: utf-8
class EvaluacionsController < ApplicationController
  # GET /evaluacions
  # GET /evaluacions.json
  def index
    if(@logged_user.admin)
      @evaluacions = Evaluacion.all
	  @pendientes = Evaluacion.where('estado = ?', 0)
      @enviadas = Evaluacion.where('estado = ?', 1)
      @completadas = Evaluacion.where('estado = ?', 2)
    else
      @evaluacions = Evaluacion.where("encargado = ?", @logged_user.id)
      @objetadas = @evaluacions.where('estado = ?', -1)
      @pendientes = @evaluacions.where('estado != ?', 0)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @evaluacions }
    end
  end

  # GET /evaluacions/1
  # GET /evaluacions/1.json
  def show
    @evaluacion = Evaluacion.find(params[:id])
		@escala = @evaluacion.escala
		
		if(!(@logged_user.admin?))
    	redirect_to user_path(@logged_user), :error => "No tiene permisos para acceder a esta vista"
    end		
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @evaluacion }
    end
  end

	# GET /evaluaciones/escala/:id
	def load_escala	
		@evaluacion = Evaluacion.new
		escala_template = EscalaTemplate.find(params[:id])

		#@escala = Escala.new(:escala_template_id => escala_template.id)
		@escala = @evaluacion.build_escala(:escala_template_id => escala_template.id)
		
		escala_template.subescala_template.each do |subescala_template|
			sub_escala = @escala.subescala.build(:subescala_template_id => subescala_template.id)
			
			subescala_template.item_template.each do |item_template|
				item = sub_escala.item.build(:item_template_id => item_template.id)
				
				item_template.indicador_template.order("id ASC").each do |indicador_template|
					indicador = item.indicador.build(:indicador_template_id => indicador_template.id)
				end
			end
		end
		
    respond_to do |format|
      format.html { render :partial => 'escala'}
      format.js 
      #format.json { render json: @evaluacion }
    end
	end

  # GET /evaluacions/new
  # GET /evaluacions/new.json
  def new
  	#TODO: vincular usuario con evaluación
    @evaluacion = Evaluacion.new
		#@escala = @evaluacion.build_escala
		@user = @logged_user

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @evaluacion }
    end
  end

  # GET /evaluacions/1/edit
  def edit
    @evaluacion = Evaluacion.find(params[:id])
    @escala = @evaluacion.escala
    @user = @evaluacion.user
	
	if(!(@user == @logged_user || @logged_user.admin?))
    	redirect_to user_path(@logged_user), :error => "No tiene permisos para acceder a esta vista"
    end
  end

  # POST /evaluacions
  # POST /evaluacions.json
  def create
    @evaluacion = Evaluacion.new(params[:evaluacion])
    
    respond_to do |format|
      if @evaluacion.save
      	@evaluacion.update_attribute(:encargado, @logged_user.id)
		@evaluacion.update_attribute(:estado, 1)
		@evaluacion.escala
		escala.subescala.each do |subescala|
		  sume = 0
		  nume = 0
		  subescala.item.each do |item|
			sum = 0
			num = 0
			  item.indicador.each do |indicador|
			    if (indicador.indicador_template.columna == 1)
				  if (indicador.eval == true)
				    item.eval = 1
					break
				  end
				elsif (indicador.eval == false)
				  if (indicador.fila > (IndicadorTemplate.where('item_template_id = ? AND columna = ?', indicador.item_template_id, indicador.columna).size)/2)
				    item.eval = indicador.columna - 1
				  else
				    item. eval = indicador.columna -2
				  end
				  break
				end
			  end
			  item.save
			  if (item.eval > 0)
			    sum = sum + item.eval
				num = num + 1
			  end
			  subescala.eval = sum/num
			  subescala.save
			  if (subescala.eval > 0)
			    sume = sume + subescala.eval
			    nume = nume + 1
			  end
			end
			escala.eval = sume/nume
			escala.save
		  end
		@evaluacion.save
        format.html { redirect_to @evaluacion, notice: 'Evaluacion was successfully created.' }
        format.json { render json: @evaluacion, status: :created, location: @evaluacion }
      else
        format.html { render action: "new" }
        format.json { render json: @evaluacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /evaluacions/1
  # PUT /evaluacions/1.json
  def update
    @evaluacion = Evaluacion.find(params[:id])

    respond_to do |format|
      if @evaluacion.update_attributes(params[:evaluacion])
        format.html { redirect_to @evaluacion, notice: 'Evaluacion was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @evaluacion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /evaluacions/1
  # DELETE /evaluacions/1.json
  def destroy
    @evaluacion = Evaluacion.find(params[:id])
    @evaluacion.destroy

    respond_to do |format|
      format.html { redirect_to evaluacions_url }
      format.json { head :no_content }
    end
  end

  def createPDF
    evaluacion = Evaluacion.find(params[:id])
    file = createFileName(evaluacion.centro,"abril","mayo")
    puts file
    Prawn::Document.generate(file) do |pdf|

      #################################################
      # TITLE PAGE ####################################
      #################################################

      pdf.move_down (pdf.bounds.height/3)
      pdf.text "INFORME DE RESULTADOS", :align => :center, :size => 22, :style => :bold
      pdf.move_down 20
      pdf.text "Escalas de Calificación del ambiente Educativo", :align => :center, :size => 22, :style => :bold
      pdf.text "(ITERS-R/ECERS-R)", :align => :center, :size => 22, :style => :bold
      pdf.move_down 40
      pdf.text "Jardín Infantil #{evaluacion.centro.nombre}", :align => :center, :size => 18, :style => :bold
      pdf.move_down (pdf.bounds.height/3)
      months = %w(Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre)
      pdf.text "#{months[evaluacion.fecha_de_evaluacion.month]}", :align => :center, :size => 18, :style => :bold
      pdf.start_new_page
      
      ##################################################
      # Presentación pag.1 #############################
      ##################################################

      string = "PRESENTACIÓN"
      pdf.text string, :size => 22, :style => :bold 
      pdf.move_down 40
      string = "EducaUC Inicial como parte de su gestión, ha adoptado el uso de las Escalas de Calificación del Ambiente de la Infancia Temprana ITERS-R y ECERS-R¹, para conocer la calidad educativa de los Centros. Estas Escalas fueron desarrolladas por investigadores del Centro de Desarrollo Infantil Frank Porter Graham, de la Universidad de Carolina del Norte de Estados Unidos y han sido parte importante de las investigaciones de primera infancia, tanto en el extranjero como en nuestro país.\n\nCon el objetivo de conocer y analizar los resultados obtenidos, se presenta el siguiente informe en tres apartados. El primero de ellos da a conocer una breve descripción de las características de los instrumentos aplicados, acompañada del resumen de los contenidos que aborda cada Escala.\n\nPosteriormente se entregan algunas consideraciones respecto a los procedimientos de aplicación y los resguardos que deben tenerse presentes frente a los resultados de las Escalas de Calificación.\n\nEn tercer lugar, se presenta los resultados obtenidos por el Centro: un breve resumen del Centro y el detalle de cada sala evaluada."
      pdf.text string, :size => 14, :align => :justify    	
      
      # Agregamos pie de nota con la explicación de las escalas:
      pdf.bounding_box [pdf.bounds.left, pdf.bounds.bottom + 25], :width  => pdf.bounds.width do
      	#pdf.stroke_bounds
        #pdf.font "Helvetica"
        pdf.stroke_horizontal_rule
        pdf.move_down(5)
        pdf.text "1. Clifford, Cryer & Harms, Escala de Calificación del Ambiente de la Infancia Temprana-Edición revisada, Nueva York (2002).", :size => 10, :align => :justify
    	end

      pdf.start_new_page
      
      ##################################################
      # Antecedentes de las escalas pag.2 ##############
      ##################################################

      string = "I.   ANTECEDENTES DE LAS ESCALAS"
      pdf.text string, :style => :bold 
      pdf.move_down 40
      string = "A continuación se detalla información respecto a las características principales de las escalas aplicadas."
      pdf.text string, :size => 14, :align => :justify
      original_size = pdf.font_size.inspect
      
      pdf.table([["Escala     ", "ITERS-R", "ECERS-R"],["Rango de edad", "Desde los primeros meses hasta los 2 años y medio", "Desde los 2 años y medio hasta los 5 años"],["Sub Escalas", {:content => "• Espacio y Muebles\n• Rutinas de Cuidado Personal\n• Escuchar y Hablar / Lenguaje-Razonamiento\n• Actividades\n• Interacción\n• Estructura del programa\n• Padres y Personal", :colspan => 2}],["Antecedentes", {:content => "Evalúan la calidad del proceso y cuantifican la observación de lo que ocurre en el aula.\n\nCuentan con respaldo científico: estudios de validación, confiabilidad y coherencia interna.\n\nLas fuentes principales para su creación tienen base en evidencias empíricas: pruebas de investigación en el campo de la salud, del desarrollo y de la educación.\n\nHan sido utilizadas en importantes proyectos de investigación, lo que ha evidenciado su confiabilidad en a cuanto uso y validez (EEUU, Canadá, Alemania, Italia, Rusia, Inglaterra, Brasil, Hong Kong, Corea, entre otros).", :colspan => 2}]])
      pdf.font_size original_size.to_i
      pdf.start_new_page

      ##################################################
      # Resumen de las Sub-escalas #####################
      ##################################################

      string = "Resumen de las Sub-escalas y los ítems de las escalas"
      pdf.text string, :size => 16, :style => :bold 
      original_size = pdf.font_size.inspect
      pdf.font_size 10
      pdf.table([["ITERS-R","ECERS-R"],["Espacio y Muebles\n1. Espacio Interior\n2. Muebles para el cuidado rutinario y el juego\n3. Provisiones para el relajamiento y el confort\n4. Organización de la sala\n5. Exhibiciones para los niños\nRutinas de Cuidado Personal\n6. Recibimiento y Despedida\n7. Comidas y meriendas\n8. Siesta\n9. Cambio de pañales y uso del baño\n10. Prácticas de salud\n11. Prácticas de seguridad\nEscuchar y Hablar\n12. Ayudar a los niños a entender el lenguaje\n13. Ayudar a los niños a utilizar el lenguaje\n14. Uso de libros\nActividades\n15. Motricidad fina\n16. Juego físico activo\n17. Arte\n18. Música y movimiento\n19. Bloques\n20. Juego dramático\n21. Juego con arena y agua\n22. Naturaleza y ciencias\n23. Uso de televisores, videos y/o computadoras\n24. Promoción de la aceptación de la diversidad\nInteracción\n25. Supervisión del juego y del aprendizaje\n26. Interacción entre los niños\n27. Interacción entre el personal y los niños\n28. Disciplina\nEstructura del programa\n29. Horario\n30. Juego libre\n31. Actividades de juego en grupo\n32. Previsiones para niños discapacitados\nPadres y Personal\n33. Previsiones para los padres\n34. Previsiones para las necesidades personales del\npersonal\n35. Previsiones para las necesidades profesionales\ndel personal\n36. Interacción y cooperación entre el personal\n37. Continuidad del personal\n38. Supervisión y evaluación del personal\n39. Oportunidades para el desarrollo profesional","Espacio y Muebles\n1. Espacio interior\n2. Muebles para el cuidado rutinario, el juego \n3. y el aprendizaje\n4. Muebles para el relajamiento y confort\n5. Organización de la sala para el juego\n6. Espacio para la privacidad\n7. Exhibiciones relacionadas con los niños\n8. Espacio para el juego motor grueso\n9. Equipo para actividades motoras gruesas\nRutinas del Cuidado Personal\n10. Recibimiento / Despedida\n11. Comidas / Meriendas\n12. Siesta / Descanso\n13. Ir al baño / Poner pañales\n14. Prácticas de salud\n15. Prácticas de seguridad\nLenguaje-Razonamiento\n16. Libros e imágenes\n17. Estimulando la comunicación en los niños\n18. Usando el lenguaje para desarrollar las\nhabilidades del razonamiento\n19. Uso informal del lenguaje\nActividades\n20. Motoras finas\n21. Arte\n22. Música / Movimiento\n23. Bloques\n24. Arena / Agua\n25. Juego dramático\n26. Naturaleza / Ciencia\n27. Matemáticas / Números\n28. Uso de la televisión, videos, y/o computadoras\n29. Promoviendo la aceptación de la diversidad\nInteracción\n30. Supervisión de las actividades motoras gruesas\n31. Supervisión general de los niños (además de la\nactividad motora gruesa)\n32. Disciplina\n33. Interacciones entre el personal y los niños\n34. Interacciones entre los niños\nEstructura del programa\n35. Horario\n36. Juego libre\n37. Tiempo en grupo\n38. Provisiones para los niños con discapacidades\n39. Padres y Personal\n40. Provisiones para los padres\n41. Provisiones para las necesidades personales del\npersonal\n42. Provisiones para las necesidades profesionales del\npersonal\n43. Interacción y cooperación entre el personal\n44. Supervisión y evaluación del personal\n45. Oportunidades para el desarrollo profesional"]])
      pdf.font_size original_size.to_i
      pdf.start_new_page

      ##################################################
      # Resumen de las Sub-escalas #####################
      ##################################################
      
      string = "II.  CONSIDERACIONES ACERCA DE LA APLICACIÓN Y RESULTADO DE LAS ESCALAS\n"
      pdf.text string, :style => :bold 
      bullet_item(1,"Los estándares de calidad que dan origen las Escalas de Calificación del Ambiente Educativo (ITERS-R/ECER-S) reflejan un alto grado de exigencia, dando cuenta de lo que se reconoce como lo óptimo que se aspira a lograr en un Centro Educativo a nivel internacional. En este contexto, es válido tener presente que los resultados obtenidos podrán estimarse como bajos en relación a instrumentos nacionales.",pdf,"1. ")
      pdf.move_down 20
      bullet_item(1,"Los rangos de calificación de las Escalas dan cuenta de la pertinencia de las prácticas del Centro educativo para el óptimo desarrollo y aprendizaje de los niños y niñas. Se organizan del siguiente modo:",pdf,"2. ")
      pdf.move_down 20
      
      pdf.indent (15), 0 do
        pdf.table ([[{:content => "Inadecuado ----------> Mínimo -----------> Bueno ----------> Excelente", :colspan => 7}],["1","2","3","4","5","6","7"]]), :position => :center do
          row(0).style :align => :center
        end 
      end

      pdf.move_down 20
      bullet_item(1,"Los indicadores que aparecen en las tablas de resultados, con numeración 1 (1.1; 1.2; 1,3; etc.) están expresados en redacción negativa y corresponden a aquellos aspectos que nunca deberían presentarse en un Centro Educativo por lo cual aparecen destacados en color rojo.",pdf,"3. ")
      pdf.move_down 20
      bullet_item(1,"Es necesario tener presente que los resultados obtenidos corresponden a lo revelado al momento de la observación realizada en cada aula, sumado a algunos aspectos recogidos de manera complementaria con el adulto a cargo del nivel.",pdf,"4. ")
      pdf.move_down 20
      bullet_item(1,"La información entregada en el presente informe da cuenta de un promedio de las prácticas desarrolladas al interior del aula por todo el personal pedagógico, es decir de las educadoras y personal técnico presentes durante la observación. En ningún caso la evaluación se orienta exclusivamente al desempeño de la Educadora a cargo del nivel.",pdf,"5. ")
      
      pdf.start_new_page

      ##################################################
      # Resumen de las Sub-escalas #####################
      ##################################################
      #lista de evaluaciones de un mes dado (el informe seleccionado)
      year = evaluacion.fecha_de_evaluacion.year
      month = evaluacion.fecha_de_evaluacion.month
      evaluaciones = evaluacion.centro.evaluacions.where('extract(month from fecha_de_evaluacion) = ? AND extract(year from fecha_de_evaluacion) = ?', month,year)
      notas = Array.new(7,0)
      sub_escalas = []
      evaluaciones.each do |eval|
        eval.escala.subescala.each_with_index do |sub,index|
          sub_escalas.push sub.subescala_template.nombre
          notas[index] += sub.eval.to_i
        end
      end
      nota_final = 0
      notas.each_with_index do |nota,index|
        notas[index] = nota/evaluaciones.count
        nota_final += notas[index]
      end
      nota_final = nota_final/notas.count
      #

      string = "III. RESUMEN DEL CENTRO\n"
      pdf.text string, :style => :bold 
      string = "DATOS CENTRO\n"
      pdf.text string, :style => :bold 
      
      pdf.table ([["Centro", evaluacion.centro.nombre ],["Directora", evaluacion.centro.directora ],["Año", evaluacion.centro.created_at.year]]), :position => :center, :width => pdf.bounds.width
      pdf.move_down 20

      string = "PUNTUACIÓN GENERAL DEL CENTRO\n"
      pdf.text string, :style => :bold 
      string = "A continuación se presenta el puntaje promedio obtenido por el Centro en su conjunto para cada Sub Escala.\n\nLos ítemes con puntajes iguales o superiores a 3 son considerados por las Escalas de Calificación del Ambiente Educativo como prácticas apropiadas al desarrollo, por lo que se ubican en un rango de calidad que va desde \"Mínimo\" (3 puntos) a \"Excelente\" (7 puntos). Estos Ítemes son considerados como los aspectos más fuertes en el Centro, ya que promueven y apoyan el desarrollo positivo del niño/a.\n\nLos ítemes con puntajes inferiores a 3 en las Escalas de Calificación del Ambiente Educativo reflejan prácticas inapropiadas o insuficientes para el desarrollo del niño/a.\n\n"
      pdf.text string

      pdf.table ([["Sub Escala", "Puntaje" ],["Espacio y muebles",notas[0]],["Rutinas de cuidado personal", notas[1]],["Escuchar y hablar / Lenguaje y razonamiento",notas[2]],["Actividades",notas[3]],["Interacción",notas[4]],["Estructura del programa",notas[5]],["Padres y personal",notas[6]],["PUNTUACIÓN TOTAL",nota_final]]), :position => :center, :width => pdf.bounds.width
      pdf.start_new_page

      ##################################################
      # Evaluation graph pag.6 #########################
      ##################################################
      string = "GRÁFICO GENERAL DEL CENTRO\n\n"
      pdf.text string, :style => :bold 
      string = "A continuación se presenta un gráfico resumen con los puntajes obtenidos por el Centro en cada Sub Escala.\n\n"
      pdf.text string

      graph = {:bottom => pdf.bounds.height/3, :top => (pdf.bounds.height/3)*2 }
      stroke_axis({:height => pdf.bounds.height/3},pdf,sub_escalas,notas)


      pdf.start_new_page
      ##################################################
      # Repeatable Evaluations #########################
      ##################################################

      evaluaciones.each do |eval|
        ################################################
        # INFORME DE RESULTADOS ########################
        ################################################
        string = "INFORME DE RESULTADOS SALA: "+eval.nombre_sala+"\n\n"
        pdf.text string, :style => :bold

        string = "DATOS OBSERVACIÓN\n\n"
        pdf.text string, :style => :bold 
        ###tabla de datos de evaluacion
        pdf.table ([["Fecha de observación",eval.fecha_de_evaluacion.day.to_s+" de "+months[eval.fecha_de_evaluacion.month.to_i]+" de "+eval.fecha_de_evaluacion.year.to_s],["Tipo de escala utilizada",eval.escala.escala_template.nombre]]), :position => :center, :width => pdf.bounds.width 
        pdf.move_down 20

        string = "PUNTUACIÓN GENERAL\n\n"
        pdf.text string, :style => :bold
        ###tabla de puntuacion de evaluacion
        table = []
        eval.escala.subescala.each do |sub|
          element = []
          element.push sub.subescala_template.nombre
          element.push sub.eval.to_i.to_s
          table.push element
        end
        pdf.table table, :position => :center, :width => pdf.bounds.width 
        pdf.move_down 20



        string = "ITEMES CALIFICADOS COMO NO APLICABLES\n\n"
        pdf.text string, :style => :bold 
        ###tabla de datos de evaluacion
        table = []
        eval.escala.subescala.each do |sub|
          element = []
          element[0] = ""
          not_applicable_count = 0
          sub.item.each do |item|
            if item.eval.to_i.to_s == "0"
              element[0] = element[0]+item.item_template.nombre+"\n"
              not_applicable_count+=1
            end
          end
          if not_applicable_count>0
            element.unshift sub.subescala_template.nombre
            table.push element
          end
        end
        pdf.table table, :position => :center, :width => pdf.bounds.width
        pdf.move_down 20


        pdf.start_new_page

        ################################################
        # FORTALEZAS ###################################
        ################################################
        roman = %w(I. II. III. IV. V. VI. VII. VIII. IX. X. XI. XII. XIII. XIV. XV. XVI. XVII. XVIII. XIX. XX.)
        string = "FORTALEZAS: ITEMES CON RESULTADOS IGUALES O SUPERIORES A 3\n\n"
        pdf.text string, :style => :bold 
        string = "En esta sección se describen los ítemes con puntajes iguales o superiores a 3. Las puntuaciones en este rango son consideradas por las Escalas de Calificación del Ambiente Educativo como prácticas apropiadas al desarrollo, por lo que se ubican en un rango de calidad que va desde \"Mínimo\" (3 puntos) a \"Excelente\" (7 puntos). Estos Ítemes son considerados como los aspectos más fuertes en esta Sala, ya que promueven y apoyan el desarrollo positivo del niño/a\n\n\n"
        pdf.text string
        ###tabla de datos de evaluacion
        eval.escala.subescala.each_with_index do |sub,index|
          bullet_item(1,sub.subescala_template.nombre+"\n\n",pdf,roman[index]+" ")
          written = false;
          sub.item.each_with_index do |item, sub_index|
            punt = item.eval.to_i
            if punt >= 3 
              bullet_item(3,item.item_template.nombre+"\n\n",pdf,(1+sub_index).to_s+". ")
              pdf.text "Puntuación: "+punt.to_s+"\n", :align => :right
              written = true;
              col = punt
              if punt%2 == 0
                col+=1
              end
              indicadores = []
              item.indicador.each do |indicador|
                if(indicador.indicador_template.columna == col && indicador.eval)
                  indicadores.push indicador
                end
              end
              indicadores.each do |indicador|
                bullet_item(5,indicador.indicador_template.descripcion+"\n",pdf,nil)
              end
                bullet_item(5,"Observaciones: "+item.observaciones+"\n\n",pdf,nil)
            end
          end
          unless written
            bullet_item(3,"(No hay fortalezas en este ítem)\n\n",pdf,"")
          end
        end

        pdf.start_new_page

        ################################################
        # CRECIMIENTO ##################################
        ################################################

        string = "ÁREAS DE CRECIMIENTO POTENCIAL: ITEMES CON PUNTAJES INFERIORES A 3\n\n"
        pdf.text string, :style => :bold 
        string = "Los ítemes con puntajes inferiores a 3 en las Escalas de Calificación del Ambiente Educativo reflejan prácticas inapropiadas para el desarrollo del niño/a. La sección ''áreas de crecimiento potencial'' proporciona información acerca de la razón para la puntuación de ciertos indicadores. Este detalle puede ayudar a entender cómo el evaluador llegó a la puntuación de cada ítem de esta sección.\n"
        pdf.text string
        eval.escala.subescala.each_with_index do |sub,index|
          bullet_item(1,sub.subescala_template.nombre+"\n\n",pdf,roman[index]+" ")
          written = false;
          sub.item.each_with_index do |item, sub_index|
            punt = item.eval.to_i
            if punt < 3 && punt > 0
              bullet_item(3,item.item_template.nombre,pdf,(1+sub_index).to_s+". ")
              pdf.text "Puntuación: "+punt.to_s+"\n", :align => :right
              col = punt
              if punt%2 == 0
                col+=1
              end
              indicadores = []
              item.indicador.each do |indicador|
                if(indicador.indicador_template.columna == col)
                  if(col == 1 && indicador.eval)
                    indicadores.push indicador
                  elsif(col == 3 && !indicador.eval)
                    indicadores.push indicador 
                  end
                end
              end
              indicadores.each do |indicador|
                bullet_item(5,indicador.indicador_template.descripcion+"\n",pdf,nil)
              end
                bullet_item(5,"Observaciones: "+item.observaciones+"\n\n",pdf,nil)
            end
          end
          unless written
            bullet_item(3,"(No hay debilidades en este ítem)\n\n",pdf,"")
          end
        end

        pdf.start_new_page

      end

      ##################################################
      # PAGE NUMBERS ###################################
      ##################################################
      string = "<page>"
      #page numbers 2 to ...
      options = { :at => [pdf.bounds.right - 150, 0],
      :width => 150,
      :align => :right,
      :page_filter => lambda{ |pg| pg > 1},
      :start_count_at => 0 }
      pdf.number_pages string, options


    end
  end

  def bullet_item(level = 1, string, pdf, num)
    pdf.indent (15 * level), 0 do
        if num.nil? 
          num = "• "
        end
        if(level == 1)
          pdf.text num + string, :style => :bold
        else
          pdf.text num + string
        end
    end
  end

  def createFileName(centro,fechaIncial,fechaFinal)
      base = "#{Rails.root}/tmp/pdfs"
      nombre = centro.nombre
      fecha = "_"+fechaIncial.to_s+"_"+fechaFinal.to_s
      ext = ".pdf"

      finalPath = base+"/"+nombre+"/"
      absolutePath = finalPath+nombre+fecha+ext
      FileUtils.mkdir_p finalPath
      return absolutePath
  end

  def download
    evaluacion = Evaluacion.find(params[:id])
    file = createFileName(evaluacion.centro,"abril","mayo")
    send_file file, :type=>"application/pdf", :x_sendfile=>true
  end

      # Draws X and Y axis rulers beginning at the margin box origin. Used on
    # examples.
    #
    def stroke_axis(options={}, pdf, subscales,notas)
      options = { :height => (pdf.cursor - 20).to_i,
                  :width => pdf.bounds.width.to_i
                }.merge(options)

      
      step_num = 0
      (100..options[:width]).step(options[:width]/8) do |point|
        note = notas[step_num]
        if(note<1)
          note = 1
        end
        old_color = pdf.fill_color
        pdf.fill_color = "598EDE"
        pdf.fill_rectangle [point-(options[:width]/8)+10,options[:height]+(options[:height]/7)*note],(options[:width]/8)-20,(options[:height]/7)*note
        pdf.fill_color = old_color
        pdf.rotate(330, :origin => [point-(options[:width]/16), options[:height]]) do
          pdf.draw_text subscales[step_num], :at => [point-(options[:width]/16), options[:height]-15], :size => 10
        end
        pdf.fill_circle [point-(options[:width]/16), options[:height]], 3
        step_num+=1
      end

      step_num = 1
      ((options[:height]+options[:height]/7)..(options[:height]*2)).step(options[:height]/7) do |point|
        pdf.fill_circle [0, point], 3
        pdf.draw_text step_num.to_s, :at => [-17, point-2], :size => 10
        step_num+=1
      end


      pdf.stroke_horizontal_line(-21, options[:width], :at => options[:height])
      pdf.stroke_vertical_line(options[:height]-21, options[:height]*2, :at => 0)

    end

  def objetar
	  @objetado = Objetado.new
    @evaluacion = Evaluacion.find(params[:objetado][:evaluacion_id])
    @objetado.evaluacion = @evaluacion
    @objetado.user = User.find(params[:objetado][:admin_id])
    @objetado.razon = params[:objetado][:razon]
	  respond_to do |format|
      if @objetado.save
		    @evaluacion.estado = -1
		    @evaluacion.save
        format.html { redirect_to @evaluacion, notice: 'Evaluacion objetada con exito.' }
        format.json { render json: @evaluacion, status: :created, location: @evaluacion }
      else
        format.html { render action: "edit" }
        format.json { render json: @evaluacion.errors, status: :unprocessable_entity }
      end
    end
  end
  def aceptar
    @evaluacion = Evaluacion.find(params[:id])
    @evaluacion.estado = 2
	
	  respond_to do |format|
      if @evaluacion.save
        format.html { redirect_to @evaluacion, notice: 'Evaluacion aceptada con exito.' }
        format.json { render json: @evaluacion, status: :created, location: @evaluacion }
      else
        format.html { render action: "edit" }
        format.json { render json: @evaluacion.errors, status: :unprocessable_entity }
      end
    end
  end
end
