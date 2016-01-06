module ApplicationHelper

  def titre
    base_titre = "Twapp"
    if @title.nil?
      base_titre
    else
      "#{@title} :: #{base_titre}"
    end
  end

  def logo
    image_tag("google-logo.jpg", :alt => titre, :title => titre, :class => "round")
  end

end
