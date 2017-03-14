class Api::V1::AsinsController < ActionController::API
  def index
    finder = ItemFinder.new
    @items_data = params[:asins].map do |asin|
      finder.filtered_data(asin)
    end
    render json: @items_data
  end

  def show
    finder = ItemFinder.new
    @item_data = finder.filtered_data(params[:asin])
    render json: @item_data
  end
end
