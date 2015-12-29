module ApplicationHelper

  def titre
    base_titre = "Twapp"
    if @title.nil?
      base_titre
    else
      "#{@title} :: #{base_titre}"
    end
  end

end
