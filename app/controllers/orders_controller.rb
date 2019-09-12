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
    @order.real_checkout_time = Time.now.strftime("%Y%m%dT%H%M%S")
    @order.return_time = @order.checkout_time + Integer(order_params[:return_time]).day
    if current_user != nil
      @order.user_id = current_user.id
    end

    if params[:selected_id]!='' and !params[:selected_id].nil?
      @order.user_id=params[:selected_id]
    end

    @order.status = 'Pending'

    @order.charge = ((Integer(order_params[:return_time]).day)/(60*60*24)) * car.price
    binding.pry
    if @order.save
        # OrderNotificationMailer.order_notification_email(@order).deliver
        car.update_attribute(:status, 'Pending')
        # format.html {redirect_to cars_path, notice: 'Thank you for order'}
        result = process_payment(@order.real_checkout_time, @order.charge)
        redirect_to result.redirect_url
      else
        format.html {render :new}
        format.json {renser json: @orders.errors, status: :unprocessable_entity}
      end
  end

  def process_payment(order_id, charge)
    @result = Veritrans.create_widget_token(
      transaction_details: {
        order_id: order_id,
        gross_amount: charge,
      },
      customer_details: {
        email: @order.email
      },
      # expiry: {
      #   start_time: Time.now.to_s,
      #   # unit: (VariableSetting.get_value("Expiry Duration") || "minute"),
      #   duration: expiration,
      # },
      credit_card: { secure: true },
    )
    return @result
  end

  def return
    @order = Order.find(params[:id])
    car = Car.find[@order.car_id]
    @order.update_attribute('status', 'returned')
    @order.update_attribute('real_return_time', Time.zone.now)
    car.update_attribute('status', 'available')

    respond_to do |format|
      format.html { redirect_to @order, notice: 'Order was succesfully returned.' }
      format.json { render :show, status: :ok, location: @order }
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
