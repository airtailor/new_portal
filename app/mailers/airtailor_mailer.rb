class AirtailorMailer < ApplicationMailer
  require 'pdfkit'

  default from: "orders@airtailor.com"

  def label_email(customer, order, provider, shipment)
    @customer = customer
    @order = order
    @provider = provider
    @shipment = shipment

    # html=render_to_string(:partial=> "attachment")

    label = PDFKit.new "<img src=" + @shipment.shipping_label + " style='display:block; ms-transform: rotate(90deg); -webkit-transform: rotate(90deg);  transform: rotate(90deg); margin:0; margin-left:175px; margin-top: -175px; margin-bottom:-125px; width:65%; padding:0'>
    <img src='http://i.imgur.com/yJwSRrn.png' style='margin:0;padding:0';margin-top:-100px><p style='text-align:center;font-size:24px;'>PUT THIS HALF IN WITH YOUR ORDER<br>PLEASE SHIP US YOUR ORDER WITHIN 10 DAYS</p><h2 style='text-align:center; padding:0; margin:0; font-size:120px'>" + @order.id.to_s + "</h2>"
    label.to_file("#{Rails.root}/public/label.pdf")

    attachments["label.pdf"] = File.read(Rails.root.join('public',"label.pdf"))
    attachments["logo-white.png"] = File.read("#{Rails.root}/app/assets/images/logo-white.png")
    attachments["balloon-white.png"] = File.read("#{Rails.root}/app/assets/images/balloon-white.png")

    mail(to: @customer.email, subject: "Ship Your Clothes To Air Tailor! (#{@order.id})")
  end

  def message_email(sender, recipient, message)
    @sender = sender
    @recipient = recipient
    @message = message

    mail(to: @recipient.email, subject: "New Air Tailor Messages")
  end
end
