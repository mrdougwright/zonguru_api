class AmazonApi
  attr_reader :request

  def initialize
    @request = init_request_obj
  end

  def item_lookup(asin, *groups)
    begin
      count ||= 1
      puts "Pinging Amazon."
      request.item_lookup(
        query: {
          'ItemId' => asin.to_s,
          'ResponseGroup' => groups.join(',')
        }
      )
    rescue Excon::Error::ServiceUnavailable => e
      count += 0.1
      puts "Failed: #{e}\nRetrying in #{count} seconds."
      sleep count.seconds
      retry
    end
  end

  def item_search(keyword_str, category)
    begin
      count ||= 1
      puts "Searching Amazon."
      request.item_search(
        query: {
          'Keywords' => keyword_str,
          'SearchIndex' => category
        }
      )
    rescue Excon::Error::ServiceUnavailable => e
      count += 0.1
      puts "Failed: #{e}\nRetrying in #{count} seconds."
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
