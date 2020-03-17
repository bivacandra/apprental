# Preview all emails at http://localhost:3000/rails/mailers/order_notification_mailer
class OrderNotificationMailerPreview < ActionMailer::Preview
  def order_notification_mailer_preview
    OrderNotificationMailer.order_notification_email(Order.first)
  end
end
