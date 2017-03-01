class ItemFinder < AmazonApi

  DEFAULT_GROUPS = %w(ItemAttributes SalesRank Reviews)

  def lookup(asin,groups=DEFAULT_GROUPS)
    Rails.cache.fetch(asin, expires_in: 5.minutes) do
      response = item_lookup(asin, groups)
      response.to_h.extend Hashie::Extensions::DeepFind
    end
  end

  def review_data(item_hash)
    review_url = item_hash.deep_find('IFrameURL')
    review_hash = parse_reviews(review_url) # This could take a while...
    rating = review_hash.search('.crIFrameNumCustReviews').first.search('a').first.search('img').first.attribute('alt').value
    review_count = review_hash.search('.crIFrameNumCustReviews').first.search('a')[1].content
    # rating.match(/[^\s]+/).to_s for just first value
    {
      rating: rating,
      num_reviews: review_count
    }
  end

  def filtered_data(asin)
    # Todo -> Est. Sales, Est. Revenue, BB Seller
    item_hash = lookup(asin)
    review_info = review_data(item_hash)
    {
      :product_name   => item_hash.deep_find('Title'),
      :brand          => item_hash.deep_find('Brand'),
      :price          => item_hash.deep_find('FormattedPrice'),
      :category       => item_hash.deep_find('Binding'),
      :rank           => item_hash.deep_find('SalesRank'),
      :review_count   => review_info[:num_reviews],
      :rating         => review_info[:rating],
      :est_sales      => 'TBD',
      :est_revenue    => 'TBD',
      :bb_seller      => 'TBD',
    }
  end
end
