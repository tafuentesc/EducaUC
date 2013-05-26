class EvaluacionsController < ApplicationController
  # GET /evaluacions
  # GET /evaluacions.json
  def index
    if(@logged_user.admin)
      @evaluacions = Evaluacion.all
    else
      @evaluacions = Evaluacion.where("encargado = ?", @logged_user.id)
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

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @evaluacion }
    end
  end

  # GET /evaluacions/new
  # GET /evaluacions/new.json
  def new
  	#TODO: vincular usuario con evaluación
    @evaluacion = Evaluacion.new
		@user = @logged_user
		
		escala_template = EscalaTemplate.find(1)

		@escala = @evaluacion.build_escala(:escala_template_id => escala_template.id)
		
		escala_template.subescala_template.each do |subescala_template|
			sub_escala = @escala.subescala.build(:subescala_template_id => subescala_template.id)
			
			subescala_template.item_template.each do |item_template|
				item = sub_escala.item.build(:item_template_id => item_template.id)
				
				item_template.indicador_template.each do |indicador_template|
					indicador = item.indicador.build(:indicador_template_id => indicador_template.id)
				end
			end
		end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @evaluacion }
    end
  end

  # GET /evaluacions/1/edit
  def edit
    @evaluacion = Evaluacion.find(params[:id])
    @escala = @evaluacion.escala
    @user = User.find(@evaluacion.encargado)
  end

  # POST /evaluacions
  # POST /evaluacions.json
  def create
  	params[:evaluacion][:escala_attributes].merge(:escala_template_id => 1)
    @evaluacion = Evaluacion.new(params[:evaluacion])
    
    respond_to do |format|
      if @evaluacion.save
      	@evaluacion.update_attribute(:encargado, @logged_user.id)
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
end
