class EbaySearchService
  BASE_URL = "https://api.ebay.com/buy/browse/v1/item_summary/search"

  def initialize(params)
    @params = params
  end

  def call
    return [] unless ENV["EBAY_APP_ID"].present?

    response = connection.get(BASE_URL) do |req|
      req.params["q"] = build_query
      req.params["limit"] = 40
      req.params["filter"] = build_filters
      req.headers["Authorization"] = "Bearer #{access_token}"
      req.headers["X-EBAY-C-MARKETPLACE-ID"] = "EBAY_FR"
    end

    return [] unless response.success?

    data = JSON.parse(response.body)
    items = data.dig("itemSummaries") || []

    items.map do |item|
      {
        platform: "ebay",
        title: item["title"],
        price: item.dig("price", "value")&.to_f,
        currency: item.dig("price", "currency") || "EUR",
        url: item["itemWebUrl"],
        image_url: item.dig("image", "imageUrl") || item.dig("thumbnailImages", 0, "imageUrl"),
        seller: item.dig("seller", "username"),
        condition: item["condition"],
        external_id: item["itemId"],
        listed_at: item["itemCreationDate"]&.then { |d| Time.parse(d) rescue nil }
      }
    end
  rescue Faraday::Error, JSON::ParserError => e
    Rails.logger.error("eBay search error: #{e.message}")
    []
  end

  private

  def build_query
    parts = [@params[:query]]
    parts << @params[:brand] if @params[:brand].present?
    parts << @params[:color] if @params[:color].present?
    parts << @params[:size] if @params[:size].present?
    parts.compact.join(" ")
  end

  def build_filters
    filters = ["categoryIds:{11450}"] # Clothing, Shoes & Accessories
    filters << "price:[#{@params[:min_price]}..#{@params[:max_price] || '*'}],priceCurrency:EUR" if @params[:min_price].present?
    filters << "price:[0..#{@params[:max_price]}],priceCurrency:EUR" if @params[:min_price].blank? && @params[:max_price].present?
    filters.join(",")
  end

  def access_token
    # eBay OAuth2 Client Credentials flow
    Rails.cache.fetch("ebay_access_token", expires_in: 1.hour) do
      resp = Faraday.post("https://api.ebay.com/identity/v1/oauth2/token") do |req|
        req.headers["Content-Type"] = "application/x-www-form-urlencoded"
        req.headers["Authorization"] = "Basic #{Base64.strict_encode64("#{ENV['EBAY_APP_ID']}:#{ENV['EBAY_CERT_ID']}")}"
        req.body = URI.encode_www_form(grant_type: "client_credentials", scope: "https://api.ebay.com/oauth/api_scope")
      end

      JSON.parse(resp.body)["access_token"]
    end
  end

  def connection
    @connection ||= Faraday.new do |f|
      f.options.timeout = 10
      f.options.open_timeout = 5
    end
  end
end
