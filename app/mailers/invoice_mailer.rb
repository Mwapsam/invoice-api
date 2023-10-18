class InvoiceMailer < ApplicationMailer
    def send_invoice(invoice)
      @invoice = invoice
      email = invoice.customer.email
      mail(to: email, subject: 'Invoice from Your Company')
    end
end
  