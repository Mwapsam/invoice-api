require 'cybersource_rest_client'

module CyberSourcePayment
    def merchantConfigProp
        merchantId='zedle23'
        runEnvironment='apitest.cybersource.com'
        timeout=1000 
        authenticationType='jwt'
        enableLog=true
        loggingLevel='DEBUG'
        logDirectory='log'
        logFilename='cybs'
        maxLogSize=10485760
        maxLogFiles=5
        enableMasking=true
        # merchantKeyId='66ee0640-c132-4e8d-96b4-37766451266e'
        # merchantSecretKey='l0woo+vrasW4RJyHKIfe6bNw8i8fhdKXD0U2GUI2nrg='

        keysDirectory='utils'
        keyAlias='zedle23'
        keyPass='zedle23'
        keyFilename='zedle23'
        
        configurationDictionary={}
        configurationDictionary['merchantID'] = merchantId
        configurationDictionary['runEnvironment'] = runEnvironment
        configurationDictionary['timeout'] = timeout
        configurationDictionary['authenticationType'] = authenticationType

        # configurationDictionary['merchantsecretKey'] = merchantSecretKey
        # configurationDictionary['merchantKeyId'] = merchantKeyId

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
        return configurationDictionary
    end

    def process_payment(order, payment_details)
        request_obj = CyberSource::CreatePaymentRequest.new
        client_reference_information = CyberSource::Ptsv2paymentsClientReferenceInformation.new
        client_reference_information.code = "TC50171_33"
        request_obj.client_reference_information = client_reference_information

        processing_information = CyberSource::Ptsv2paymentsProcessingInformation.new
        processing_information.capture = false

        request_obj.processing_information = processing_information

        payment_information = CyberSource::Ptsv2paymentsPaymentInformation.new
        card = CyberSource::Ptsv2paymentsPaymentInformationCard.new
        card.number = "4111111111111111"
        card.expiration_month = "12"
        card.expiration_year = "2031"
        payment_information.card = card
        request_obj.payment_information = payment_information

        order_information = CyberSource::Ptsv2paymentsOrderInformation.new
        amount_details = CyberSource::Ptsv2paymentsOrderInformationAmountDetails.new
        amount_details.total_amount = "1000.21"
        amount_details.currency = "USD"
        order_information.amount_details = amount_details
        bill_to = CyberSource::Ptsv2paymentsOrderInformationBillTo.new
        bill_to.first_name = "John"
        bill_to.last_name = "Doe"
        bill_to.address1 = "1 Market St"
        bill_to.locality = "san francisco"
        bill_to.administrative_area = "CA"
        bill_to.postal_code = "94105"
        bill_to.country = "US"
        bill_to.email = "test@cybs.com"
        bill_to.phone_number = "4158880000"
        order_information.bill_to = bill_to
        request_obj.order_information = order_information

        config = merchantConfigProp
        api_client = CyberSource::ApiClient.new
        api_instance = CyberSource::PaymentsApi.new(api_client, config)

        data, status_code, headers = api_instance.create_payment(request_obj)
        
        return status_code == 201 ? [data, status_code, headers] : { error: "Transaction failed!" }

    rescue StandardError => err
        puts err.message
    end
end
  