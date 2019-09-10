class CarsController < ApplicationController
  def index
    @cars = Car.all.order('created_at ASC')
    if params[:search1] or params[:search2]
      @cars = Car.search(params[:search1], params[:search2]).order("created_at DESC")
    else
      @cars = Car.all.order("created_at ASC")
    end
  end

  def show
    @car = Car.find_by(id: params[:id])
  end



  private
end
