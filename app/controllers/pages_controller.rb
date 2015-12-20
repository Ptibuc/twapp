class PagesController < ApplicationController
  def home
    @title = "Home"
  end

  def contact
    @title = "Nous contacter"
  end

  def about
    @title = "A propos"
  end
end
