class OrderNotificationMailer < ApplicationMailer
  default from: "bivatjhandra@gmail.com"

  def order_notification_email(order)
    @order = order
    mail(to: @order.email, subject: 'Order Notification')
  end
end
