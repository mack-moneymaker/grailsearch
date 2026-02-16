class VintedSearchService
  BASE_URL = "https://www.vinted.fr/api/v2/catalog/items"

  def initialize(params)
    @params = params
  end

  def call
    response = connection.get(BASE_URL) do |req|
      req.params["search_text"] = build_query
      req.params["per_page"] = 40
      req.params["order"] = "newest_first"
      req.params["price_from"] = @params[:min_price] if @params[:min_price].present?
      req.params["price_to"] = @params[:max_price] if @params[:max_price].present?
      req.params["brand_ids[]"] = resolve_brand_id(@params[:brand]) if @params[:brand].present?
      req.params["size_ids[]"] = resolve_size_id(@params[:size]) if @params[:size].present?
      req.headers["User-Agent"] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36"
      req.headers["Accept"] = "application/json"
    end

    return [] unless response.success?

    data = JSON.parse(response.body)
    items = data.dig("items") || []

    items.map do |item|
      {
        platform: "vinted",
        title: item["title"],
        price: item.dig("price", "amount")&.to_f || item["price_numeric"]&.to_f,
        currency: item.dig("price", "currency_code") || "EUR",
        url: "https://www.vinted.fr/items/#{item['id']}-#{item['title'].to_s.parameterize}",
        image_url: item.dig("photo", "url") || item.dig("photos", 0, "url"),
        seller: item.dig("user", "login"),
        condition: item["status"],
        external_id: item["id"].to_s,
        listed_at: item["created_at_ts"]&.then { |ts| Time.at(ts) rescue nil }
      }
    end
  rescue Faraday::Error, JSON::ParserError => e
    Rails.logger.error("Vinted search error: #{e.message}")
    []
  end

  private

  def build_query
    parts = [@params[:query]]
    parts << @params[:brand] if @params[:brand].present?
    parts << @params[:color] if @params[:color].present?
    parts.compact.join(" ")
  end

  # Placeholder — in production, maintain a brand_id lookup table
  def resolve_brand_id(brand)
    nil
  end

  def resolve_size_id(size)
    nil
  end

  def connection
    @connection ||= Faraday.new do |f|
      f.options.timeout = 10
      f.options.open_timeout = 5
    end
  end
end
