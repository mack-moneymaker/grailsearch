class PriceTracker
  def initialize(query)
    @query = query.to_s.downcase.strip
  end

  def summary
    return nil if @query.blank?

    points = PricePoint.for_query(@query).last_30_days.order(:recorded_at)
    return nil if points.empty?

    {
      current_avg: points.last&.average_price,
      min: points.minimum(:min_price),
      max: points.maximum(:max_price),
      trend: calculate_trend(points),
      data_points: points.map { |p| { date: p.recorded_at.to_date, avg: p.average_price, count: p.result_count } }
    }
  end

  def record(platform:, results:)
    return if results.empty?

    prices = results.filter_map { |r| r[:price] }
    return if prices.empty?

    PricePoint.create!(
      query: @query,
      platform: platform,
      average_price: prices.sum / prices.size,
      min_price: prices.min,
      max_price: prices.max,
      result_count: results.size,
      recorded_at: Time.current
    )
  end

  private

  def calculate_trend(points)
    return "stable" if points.size < 2

    recent = points.last(7).map(&:average_price).compact
    older = points.first([points.size - 7, 7].max).map(&:average_price).compact

    return "stable" if recent.empty? || older.empty?

    recent_avg = recent.sum / recent.size
    older_avg = older.sum / older.size
    change = ((recent_avg - older_avg) / older_avg * 100).round(1)

    if change > 5
      "up"
    elsif change < -5
      "down"
    else
      "stable"
    end
  end
end
