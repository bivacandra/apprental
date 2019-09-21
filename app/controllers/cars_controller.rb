class CarsController < ApplicationController
  def index
    @cars = Car.all.order('created_at ASC').page(params[:page]).per(6)
    if params[:search1] || params[:search2] || params[:search3] || params[:search4]
      @cars = Car.search(params[:search1], params[:search2], params[:search3], params[:search4]).order('created_at DESC').page(params[:page]).per(6)
    else
      @cars = Car.all.order('created_at ASC').page(params[:page]).per(6)
    end
    
  end

  def show
    @car = Car.find_by(id: params[:id])
  end
end
