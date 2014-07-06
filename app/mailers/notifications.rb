# coding: utf-8
class Notifications < ActionMailer::Base
  
  def purchase_details(purchase)
    if purchase.supplier_account.sender_email_provider == "Gmail"
      ActionMailer::Base.smtp_settings = {
        :address              => "smtp.gmail.com",
        :port                 => 587,
        :user_name            => purchase.supplier_account.sender_email_username,
        :password             => purchase.supplier_account.sender_email_password,
        :authentication       => "plain",
        :enable_starttls_auto => true
      }
    else
      raise "Error al enviar el correo: no tienes configurada la cuenta Gmail"
    end
    
    @purchase = purchase
    unless purchase.customer.blank? or purchase.customer.email.blank? 
  	  mail to: purchase.customer.email, subject: "Detalle de tu compra en "+purchase.supplier_account.name
	  end
  end

end