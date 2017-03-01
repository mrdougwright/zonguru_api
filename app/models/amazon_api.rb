class AmazonApi
  attr_reader :request

  def initialize
    @request = init_request_obj
  end

  def item_lookup(asin, *groups)
    request.item_lookup(
      query: {
        'ItemId' => asin.to_s,
        'ResponseGroups' => groups.join(',')
      }
    )
  end

private
  def init_request_obj
    r = Vacuum.new
    r.associate_tag = 'tag'
    r
  end
end
