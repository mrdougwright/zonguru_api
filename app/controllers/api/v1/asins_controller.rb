class Api::V1::AsinsController < ActionController::API
  def index
    finder = ItemFinder.new
    @item_data = params[:asins].map do |asin|
      finder.filtered_data(asin)
    end
    render json: @item_data
  end
end
