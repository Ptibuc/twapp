class SessionsController < ApplicationController

  def new
    @title = "Identification"
    @user = User.new
  end

  def create
    # on fait appel à la fonction authenticate du model User
    # pour vérifier l'authentification
    user = User.authenticate( params[:session][:email],
                              params[:session][:password])

    if user.nil?
      # identification échouée, essaye encore !
      @title = "Identification"
      flash.now[:error] = "Authentification échouée, erreur dans l'adresse email ou le mot de passe"
      render 'new'
    else
      # identification réussie, on authentifie et redirige
      sign_in user
      redirect_to user
    end

  end

  def destroy
    sign_out
    redirect_to home_path
  end

end
