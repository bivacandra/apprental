class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = Order.all

    if current_user
        @orders = Order.where(user_id: current_user.id)
    else
      @orders = []
    end
  end

  def new
    @order = Order.new
    car = Car.find(params[:car_id])
    @order.car_id = car.id
  end

  def create
    @order = Order.new(order_params)
    car = Car.find(@order.car_id)
    @order.real_checkout_time = Time.zone.now
    @order.return_time = @order.checkout_time + Integer(order_params[:return_time]).day
    if current_user != nil
      @order.user_id = current_user.id
    end

    if params[:selected_id]!='' and !params[:selected_id].nil?
      @order.user_id=params[:selected_id]
    end

    @order.status = 'Pending'

    @order.charge = @order.return_time.to_i * car.price.to_i
    binding.pry
    respond_to do |format|
      if @order.save
        car.update_attribute(:status, 'Pending')
        format.html {redirect_to cars_path, notice: 'Thank you for order'}
        format.json {render :show, status: :created, location: @order}
      else
        format.html {render :new}
        format.json {renser json: @orders.errors, status: :unprocessable_entity}
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def order_params
    params.require(:order).permit(:name, :address, :email, :pay_type, :car_id, :tel, :real_checkout_time, :return_time, :checkout_time, :guarantee, :charge)
  end
end
