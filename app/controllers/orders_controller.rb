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
    time = Time.now.strftime('%Y%m%dT%H%M%S')
    @order.transaction_id = "amca-#{time}"
    @order.real_checkout_time = Time.zone.now
    @order.return_time = @order.checkout_time + Integer(order_params[:return_time]).day
    if current_user != nil
      @order.user_id = current_user.id
    end

    @order.status = 'pending'
    @order.charge = ((Integer(order_params[:return_time]).day)/(60*60*24)) * car.price
    if @order.save
        car.update_attribute(:status, 'pending')
        OrderNotificationMailer.order_notification_email(@order).deliver
        result = process_payment(@order.transaction_id, @order.charge)
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
        gross_amount: charge
      },
      customer_details: {
        first_name: @order.name,
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

  def show
    @order = Order.find_by(id: params[:id])
    respond_to do |format|
      format.html
      format.json
      format.pdf { 
        render pdf: 'Invoice',
        template: 'orders/show.html.erb',
        layout: 'pdf.html'
      }
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(
      :name,
      :address,
      :email,
      :car_id,
      :tel,
      :real_checkout_time,
      :return_time,
      :checkout_time,
      :guarantee,
      :charge,
      :transaction_id)
  end
end
