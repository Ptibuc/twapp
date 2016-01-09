# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  nom        :string
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
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
  validates :password,  :presence     => true,
                        :confirmation => true,
                        :length       => { :within => 6..40 }
  #validates :nom, :presence => true

  before_save :encrypt_password

  # Retour true (vrai) si le mot de passe correspond.
  def has_password?(password_soumis)
    # Compare encrypted_password avec la version cryptée de
    # password_soumis.
  end

  private

    def encrypt_password
      # self.encrypted_password permet de définir la propriéé dans l'objet utilisable en dehors de la zone privée
      # sans le self, rien ne serait retourné ou une erreur
      # on devrait faire pareil dans l'appel à la fonction encrypt
      # mais le self. est sous-entendu dans ce cas là (l'expérience dira pourquoi)
      self.encrypted_password = encrypt(password)
      #self.email = self.nom => à l'enregistrement, l'adresse email prend la valeur du nom. Ca fonctionne, j'ai testé
    end

    def encrypt(string)
      string # Implémentation provisoire !
    end
end
