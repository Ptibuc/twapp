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

  def gravatar_for(user, options = { :size => 50})
    gravatar_image_tag(user.email.downcase,   :alt => user.nom,
                                              :class => 'gravatar',
                                              :gravatar => options)
  end

  def glyphicon(icon, text)

    # html_safe
    
  end

end
