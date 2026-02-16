class CrossPlatformLinks
  def initialize(params)
    @query = params[:query].to_s
    @brand = params[:brand].to_s
    @size = params[:size].to_s
  end

  def generate
    search_term = [@query, @brand].reject(&:blank?).join(" ")
    encoded = CGI.escape(search_term)

    [
      {
        platform: "Depop",
        url: "https://www.depop.com/search/?q=#{encoded}",
        icon: "depop",
        color: "#FF2300"
      },
      {
        platform: "Grailed",
        url: "https://www.grailed.com/shop?query=#{encoded}",
        icon: "grailed",
        color: "#000000"
      },
      {
        platform: "Vestiaire Collective",
        url: "https://www.vestiairecollective.com/search/?q=#{encoded}",
        icon: "vestiaire",
        color: "#1A1A1A"
      },
      {
        platform: "Poshmark",
        url: "https://poshmark.com/search?query=#{encoded}",
        icon: "poshmark",
        color: "#CF0032"
      }
    ]
  end
end
