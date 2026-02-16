class SearchesController < WebController
  def show
    @query = params[:q].to_s.strip
    @brand = params[:brand].to_s.strip
    @size = params[:size].to_s.strip
    @color = params[:color].to_s.strip
    @min_price = params[:min_price].presence
    @max_price = params[:max_price].presence
    @category = params[:category].to_s.strip

    return if @query.blank?

    search_params = {
      query: @query,
      brand: @brand.presence,
      size: @size.presence,
      color: @color.presence,
      min_price: @min_price,
      max_price: @max_price,
      category: @category.presence
    }.compact

    @results = SearchAggregator.new(search_params).call
    @cross_platform_links = CrossPlatformLinks.new(search_params).generate
    @price_data = PriceTracker.new(@query).summary
  end
end
