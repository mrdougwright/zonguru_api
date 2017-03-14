class ItemFinder < AmazonApi

  EXPIRE_TIME = ENV['CACHE_MINUTES'].to_i
  DEFAULT_GROUPS = %w(ItemAttributes SalesRank Images)
  # AVAILABLE_GROUPS = %w(Accessories ItemIds OfferFull OfferListings Offers OfferSummary PromotionSummary Reviews SalesRank Similarities Tracks Variations VariationImages VariationMatrix VariationOffers VariationSummary)
  CATEGORIES = ["All", "Apparel", "Appliances", "ArtsAndCrafts", "Automotive", "Baby", "Beauty", "Blended", "Books", "Classical", "Collectibles", "DVD", "DigitalMusic", "Electronics", "Fashion", "FashionBaby", "FashionBoys", "FashionGirls", "FashionMen", "FashionWomen", "GiftCards", "GourmetFood", "Grocery", "Handmade", "HealthPersonalCare", "HomeGarden", "Industrial", "Jewelry", "KindleStore", "Kitchen", "LawnAndGarden", "Luggage", "MP3Downloads", "Magazines", "Marketplace", "Miscellaneous", "MobileApps", "Movies", "Music", "MusicTracks", "MusicalInstruments", "OfficeProducts", "OutdoorLiving", "PCHardware", "Pantry", "PetSupplies", "Photo", "Shoes", "Software", "SportingGoods", "Tools", "Toys", "UnboxVideo", "VHS", "Vehicles", "Video", "VideoGames", "Watches", "Wine", "Wireless", "WirelessAccessories"]

  def cache_lookup(asin,groups=DEFAULT_GROUPS)
    Rails.cache.fetch(asin, expires_in: EXPIRE_TIME.minutes) do
      response = item_lookup(asin, groups)
      response.to_h.extend Hashie::Extensions::DeepFind
    end
  end

  def category_items(keyword_str)
    CATEGORIES.map do |category|
      resp = item_search(keyword_str, category)
      resp = resp.to_h.extend Hashie::Extensions::DeepFind
      {category => resp.deep_find('TotalResults')}
    end
  end

  def filtered_data(asin)
    # Todo -> Est. Sales, Est. Revenue, BB Seller
    item_hash = cache_lookup(asin)

    # review_info = review_data(item_hash)  # scraping on JS side
    {
      :asin           => asin,
      :product_name   => item_hash.deep_find('Title'),
      :brand          => item_hash.deep_find('Brand'),
      :price          => item_hash.deep_find('FormattedPrice'),
      :category       => item_hash.deep_find('Binding'),
      :rank           => item_hash.deep_find('SalesRank'),
      :item_url       => item_hash.deep_find('DetailPageURL'),
      :image_url      => item_hash.deep_find('MediumImage').try(:[],"URL"),
      :review_count   => '', #review_info[:num_reviews],
      :rating         => '', #review_info[:rating],
      :est_sales      => 'TBD',
      :est_revenue    => 'TBD',
      :bb_seller      => 'TBD',
    }
  end

end
