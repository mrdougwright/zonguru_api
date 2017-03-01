class AmazonApi
  attr_reader :request

  def initialize
    @request = init_request_obj
  end

  def item_lookup(asin, *groups)
    sleep 1.1.seconds
    request.item_lookup(
      query: {
        'ItemId' => asin.to_s,
        'ResponseGroup' => groups.join(',')
      }
    )
  end

  def parse_reviews(url)
    begin
      count ||= 0
      Mechanize.new.get(url)
    rescue Mechanize::ResponseCodeError => e
      count += 1
      puts "Failed with 503: Retrying in #{count} seconds."
      sleep count.seconds
      retry
    end
  end

private
  def init_request_obj
    r = Vacuum.new
    r.associate_tag = 'tag'
    r
  end
end
