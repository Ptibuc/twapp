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

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :nom, presence: { message: "Le nom doit être renseigné" },
                  length: { :maximum => 50, message: "Le nom ne doit pas dépasser 50 caractères"}

  validates :email, presence: { message: "> L'adresse email doit être renseignée" },
                    uniqueness: { :case_sensitive => false, message: "> Vous semblez être déjà inscrit !" },
                    format: { :with => email_regex, message: "> Le format de l'adresse email n'est pas bon" }

  #validates :nom, :presence => true
end
