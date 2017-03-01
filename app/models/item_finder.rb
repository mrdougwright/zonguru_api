class ItemFinder
  attr_reader :api_request
  DEFAULT_GROUPS = %w(EditorialReview ItemAttributes SalesRank)

  def initialize
    @api_request = AmazonApi.new
  end

  def lookup(asin,groups=DEFAULT_GROUPS)
    Rails.cache.fetch(asin, expires_in: 5.minutes) do
      response = api_request.item_lookup(asin,groups)
      response.to_h.extend Hashie::Extensions::DeepFind
    end
  end
end
