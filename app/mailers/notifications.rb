# coding: utf-8
class Notifications < ActionMailer::Base
	default from: "hhanckes@gmail.com"
  
  def purchase_details(purchase)
    @purchase = purchase
    unless purchase.customer.blank? or purchase.customer.email.blank? 
  	  mail to: purchase.customer.email, subject: "Detalle de tu compra en "+purchase.supplier_account.name
	  end
  end

end