class CheckSingleSearchJob < ApplicationJob
  queue_as :default

  def perform(saved_search_id)
    saved_search = SavedSearch.find_by(id: saved_search_id)
    return unless saved_search&.active?

    results = SearchAggregator.new(saved_search.search_params).call
    new_results = []

    results.each do |result|
      next if saved_search.search_results.exists?(external_id: result[:external_id], platform: result[:platform])

      sr = saved_search.search_results.create!(
        platform: result[:platform],
        title: result[:title],
        price: result[:price],
        currency: result[:currency],
        url: result[:url],
        image_url: result[:image_url],
        seller: result[:seller],
        condition: result[:condition],
        external_id: result[:external_id],
        listed_at: result[:listed_at]
      )
      new_results << sr
    end

    saved_search.mark_checked!

    # Record price data
    results.group_by { |r| r[:platform] }.each do |platform, platform_results|
      PriceTracker.new(saved_search.query).record(platform: platform, results: platform_results)
    end

    # Send alert if user is pro and there are new results
    if new_results.any? && saved_search.user.pro?
      AlertMailer.new_results(saved_search, new_results).deliver_later
    end
  end
end
