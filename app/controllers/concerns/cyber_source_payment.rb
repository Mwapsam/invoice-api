require 'cybersource_rest_client'

module CyberSourcePayment
  def merchantConfigProp
    merchantId = 'zedle23'
    runEnvironment = 'apitest.cybersource.com'
    timeout = 1000
    authenticationType = 'jwt'
    enableLog = true
    loggingLevel = 'DEBUG'
    logDirectory = 'log'
    logFilename = 'cybs'
    maxLogSize = 10_485_760
    maxLogFiles = 5
    enableMasking = true

    keysDirectory = 'utils'
    keyAlias = 'zedle23'
    keyPass = 'zedle23'
    keyFilename = 'zedle23'

    configurationDictionary = {}
    configurationDictionary['merchantID'] = merchantId
    configurationDictionary['runEnvironment'] = runEnvironment
    configurationDictionary['timeout'] = timeout
    configurationDictionary['authenticationType'] = authenticationType

    configurationDictionary['keysDirectory'] = keysDirectory
    configurationDictionary['keyAlias'] = keyAlias
    configurationDictionary['keyPass'] = keyPass
    configurationDictionary['keyFilename'] = keyFilename

    log_config = {}
    log_config['enableLog'] = enableLog
    log_config['loggingLevel'] = loggingLevel
    log_config['logDirectory'] = logDirectory
    log_config['logFilename'] = logFilename
    log_config['maxLogSize'] = maxLogSize
    log_config['maxLogFiles'] = maxLogFiles
    log_config['enableMasking'] = enableMasking

    configurationDictionary['logConfiguration'] = log_config
    configurationDictionary
  end

  def process_payment(details)
    request_obj = CyberSource::CreatePaymentRequest.new
    client_reference_information = CyberSource::Ptsv2paymentsClientReferenceInformation.new
    client_reference_information.code = 'TC50171_33'
    request_obj.client_reference_information = client_reference_information

    processing_information = CyberSource::Ptsv2paymentsProcessingInformation.new
    processing_information.capture = false

    request_obj.processing_information = processing_information

    payment_information = CyberSource::Ptsv2paymentsPaymentInformation.new
    card = CyberSource::Ptsv2paymentsPaymentInformationCard.new
    card.number = details[:card_number]
    card.expiration_month = details[:expiration_month]
    card.expiration_year = details[:expiration_year]
    payment_information.card = card
    request_obj.payment_information = payment_information

    order_information = CyberSource::Ptsv2paymentsOrderInformation.new
    amount_details = CyberSource::Ptsv2paymentsOrderInformationAmountDetails.new
    amount_details.total_amount = details[:total_amount]
    amount_details.currency = 'USD'
    order_information.amount_details = amount_details
    bill_to = CyberSource::Ptsv2paymentsOrderInformationBillTo.new
    bill_to.first_name = details[:first_name]
    bill_to.last_name = details[:last_name]
    bill_to.address1 = details[:address1]
    bill_to.locality = 'Chilenje'
    bill_to.administrative_area = details[:administrative_area]
    bill_to.postal_code = details[:postal_code]
    bill_to.country = details[:country]
    bill_to.email = details[:email]
    bill_to.phone_number = details[:phone_number]
    order_information.bill_to = bill_to
    request_obj.order_information = order_information

    config = merchantConfigProp
    api_client = CyberSource::ApiClient.new
    api_instance = CyberSource::PaymentsApi.new(api_client, config)

    data, status_code, headers = api_instance.create_payment(request_obj)

    status_code == 201 ? [data, status_code, headers] : { error: 'Transaction failed!' }
  rescue StandardError => e
    puts e.message
  end

  def process_credit()
    request_obj = CyberSource::CreateCreditRequest.new
    client_reference_information = CyberSource::Ptsv2paymentsClientReferenceInformation.new
    client_reference_information.code = '12345678'
    request_obj.client_reference_information = client_reference_information

    payment_information = CyberSource::Ptsv2paymentsidrefundsPaymentInformation.new
    card = CyberSource::Ptsv2paymentsidrefundsPaymentInformationCard.new
    card.number = '4111111111111111'
    card.expiration_month = '03'
    card.expiration_year = '2031'
    card.type = '001'
    payment_information.card = card
    request_obj.payment_information = payment_information

    order_information = CyberSource::Ptsv2paymentsidrefundsOrderInformation.new
    amount_details = CyberSource::Ptsv2paymentsidcapturesOrderInformationAmountDetails.new
    amount_details.total_amount = '200'
    amount_details.currency = 'usd'
    order_information.amount_details = amount_details
    bill_to = CyberSource::Ptsv2paymentsidcapturesOrderInformationBillTo.new
    bill_to.first_name = 'John'
    bill_to.last_name = 'Deo'
    bill_to.address1 = '900 Metro Center Blvd'
    bill_to.locality = 'Foster City'
    bill_to.administrative_area = 'CA'
    bill_to.postal_code = '48104-2201'
    bill_to.country = 'US'
    bill_to.email = 'test@cybs.com'
    bill_to.phone_number = '9321499232'
    order_information.bill_to = bill_to
    request_obj.order_information = order_information

    config = merchantConfigProp
    api_client = CyberSource::ApiClient.new
    api_instance = CyberSource::CreditApi.new(api_client, config)

    data, status_code, headers = api_instance.create_credit(request_obj)

    puts data, status_code, headers
    data
  rescue StandardError => e
    puts e.message
  end
end
