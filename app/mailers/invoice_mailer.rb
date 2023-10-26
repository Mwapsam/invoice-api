class InvoiceMailer < ApplicationMailer
  def send_invoice(invoice, message)
    @invoice = invoice
    @message = message
    email = invoice.customer.email
    mail(to: email, subject: 'Invoice from Your Company')
  end
end
