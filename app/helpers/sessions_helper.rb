module SessionsHelper

  # fonction de lancement de l'identification
  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end

  # vérification si l'utilsateur est identifié
  def signed_in?
    !current_user.nil?
  end

  # déconnexion
  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  # bien mettre =() pour pouvoir la garder de page en page
  # ceci est un assignement
  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= user_from_remeber_token
    # retourne l'utilsateur courant si défini
    # ou va le chercher dans le cas contraire grâce au ||= (ou égal)
  end

  def deny_acccess
    redirect_to signin_path, :notice => "Vous devez être authentifié pour avoir accès à cette page"
  end

  def current_user?(user)
    user == current_user
  end

private

  def user_from_remeber_token
    User.authenticate_with_salt(*remember_token)
    # le * devant remember_token dit de prendre en paramètre un tableau
    # ainsi on passe donc bien les deux paramètres
    # le ID et le SALT, comme défini dans le sign_in
  end

  def remember_token
    cookies.signed[:remember_token] || [nil, nil]
  end

end
