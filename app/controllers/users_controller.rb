# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  nom                :string
#  email              :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  encrypted_password :string
#  salt               :string
#

class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate, only: [:edit, :update]
  before_filter :correct_user, only: [:edit, :update]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    #@user = User.find(params[:id])
    @title = @user.nom
  end

  # GET /users/new
  def new
    @title = "Inscription"
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @title = "Modifier mon profil"
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    #respond_to do |format|
    #  if @user.save
    #    format.html { redirect_to @user, notice: 'Votre compte a bien été créé' }
    #    format.json { render :show, status: :created, location: @user }
    #  else
    #    format.html { render :new }
    #    format.json { render json: @user.errors, status: :unprocessable_entity }
    #  end
    #end
    if @user.save
      # Traite un succès d'enregistrement.
      flash[:success] = "Votre compte a bien été créé"
      sign_in @user
      redirect_to @user
    else
      @titre = "Inscription"
      render 'new'
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    #respond_to do |format|
    #  if @user.update(user_params)
    #    format.html { redirect_to @user, notice: 'User was successfully updated.' }
    #    format.json { render :show, status: :ok, location: @user }
    #  else
    #    format.html { render :edit }
    #    format.json { render json: @user.errors, status: :unprocessable_entity }
    #  end
    #end
    if @user.update_attributes(user_params)
      flash[:success] = "Votre profil a été mis à jour."
      redirect_to @user
    else
      #@title = ""
      render 'edit'
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:nom, :email, :password, :password_confirmation, :salt)
      #params.require(:user).permit(:nom, :email, :password, :password_confirmation)
    end

    # procédure pour bloquer l'accès si non authentifié
    def authenticate
      deny_access unless signed_in?
    end

    # procédure pour vérifier que l'utilisateur actuel
    # est le même que celui loggé
    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end

end
