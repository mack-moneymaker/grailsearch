class SearchAggregator
  def initialize(params)
    @params = params
  end

  def call
    results = []

    # Run API-based searches concurrently via threads
    threads = []

    threads << Thread.new { EbaySearchService.new(@params).call }
    threads << Thread.new { VintedSearchService.new(@params).call }

    threads.each do |t|
      begin
        results.concat(t.value)
      rescue => e
        Rails.logger.error("Search thread error: #{e.message}")
      end
    end

    results.sort_by { |r| r[:listed_at] || Time.at(0) }.reverse
  end
end
