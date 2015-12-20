class PagesController < ApplicationController
  def home4
    @title = "Home"
  end

  def contact
    @title = "Nous contacter"
  end

  def about
    @title = "A propos"
  end
end
