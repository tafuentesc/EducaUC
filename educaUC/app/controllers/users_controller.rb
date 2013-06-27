class UsersController < ApplicationController
  # GET /users
  # GET /users.json

  skip_before_filter :check_token, only: [:new, :create]
  
  def index
  	if(@logged_user.admin?)
	  @users = User.where("id != #{@logged_user.id}")
	else
      redirect_to user_path(@logged_user), :notice => "No tiene permisos para acceder a esta vista"
      return
	end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

	if(!(@user == @logged_user || @logged_user.admin?))
    	redirect_to user_path(@logged_user), :error => "No tiene permisos para acceder a esta vista"
    end
	
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new
	if(!(@logged_user.admin?))
    	redirect_to user_path(@logged_user), :error => "No tiene permisos para acceder a esta vista"
    end
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    
    # Agregamos verificación para saber si es el mismo usuario que el que está logueado
    if(!(@user == @logged_user || @logged_user.admin?))
    	redirect_to user_path(@logged_user), :error => "No tiene permisos para acceder a esta vista"
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])
    
    # TODO: verificar que @logged_user es un admin en caso de cambiar 
    #       active o admin
    
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
end
