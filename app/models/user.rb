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

class User < ActiveRecord::Base
  has_many :microposts

  attr_accessor :password

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :nom, presence: { message: "> Le nom doit être renseigné" },
                  length: { :maximum => 50, message: "> Le nom ne doit pas dépasser 50 caractères"}

  validates :email, presence: { message: "> L'adresse email doit être renseignée" },
                    uniqueness: { :case_sensitive => false, message: "> Vous semblez être déjà inscrit !" },
                    format: { :with => email_regex, message: "> Le format de l'adresse email n'est pas bon" }

  # Crée automatique l'attribut virtuel 'password_confirmation'.
  validates :password,  presence: { message: "> Vous devez saisir un mot de passe" },
                        confirmation: { message: "> Les deux mots de passes saisis sont différents" },
                        length: { :within => 6..40, message: "> Le mot de passe doit contenir entre 6 et 40 caractères" }
                        #:presence     => true,
                        #:confirmation => true,
                        #:length       => { :within => 6..40 }
  #validates :nom, :presence => true

  before_save :encrypt_password

  # Retour true (vrai) si le mot de passe correspond.
  def has_password?(password_soumis)
    # Compare encrypted_password avec la version cryptée de
    # password_soumis.
    encrypted_password == encrypt(password_soumis)
  end

  # fonction pour identification
  # le self. dans cette méthode en fait une méthode de class
  # il se réfère à l'objet User, et non la class
  def self.authenticate(email, submitted_password)
    user = find_by(:email => email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end

  # fonction pour authentification persistante
  #  on va s'identifier avec le salt
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by(:id => id)
    # on récupère l'utilisateur via son id
    (user && user.salt == cookie_salt) ? user : nil
    # on vérifie que la clé ID + SALT = cookie_salt
    # si oui on retourne le user, sinon une valeur nulle
  end

  private

    def encrypt_password
      # self.encrypted_password permet de définir la propriéé dans l'objet utilisable en dehors de la zone privée
      # sans le self, rien ne serait retourné ou une erreur
      # on devrait faire pareil dans l'appel à la fonction encrypt
      # mais le self. est sous-entendu dans ce cas là (l'expérience dira pourquoi)
      #self.encrypted_password = encrypt(password)
      #self.email = self.nom => à l'enregistrement, l'adresse email prend la valeur du nom. Ca fonctionne, j'ai testé
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      # on crypte les valeur passées en paramètre
      secure_hash(string, salt)
    end

    def make_salt
      # on créé une clé de hashage
      #secure_hash(password, BCrypt::Engine.generate_salt)
      BCrypt::Engine.generate_salt
    end

    def secure_hash(pwd, pwd_salt)
      # on créé le mot de passe crypté
      BCrypt::Engine.hash_secret(pwd, pwd_salt)
    end
end
