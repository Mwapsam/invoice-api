require 'cybersource_rest_client'

class Api::V1::InvoicesController < ApplicationController
    def merchantConfigProp
        merchantId='zedle23'
        runEnvironment='apitest.cybersource.com'
        timeout=1000 
        authenticationType='http_signature'
        jsonFilePath='resource/request.json'
        enableLog=true
        loggingLevel='DEBUG'
        logDirectory='log'
        logFilename='cybs'
        maxLogSize=10485760
        maxLogFiles=5
        enableMasking=true

        merchantKeyId='66ee0640-c132-4e8d-96b4-37766451266e'
        merchantSecretKey='l0woo+vrasW4RJyHKIfe6bNw8i8fhdKXD0U2GUI2nrg='

        keysDirectory='resource'
        keyAlias='zedle23'
        keyPass='zedle23'
        keyFilename='zedle23'
    
        useMetaKey = false
        portfolioID = ''
        
        configurationDictionary={}
        configurationDictionary['merchantID'] = merchantId
        configurationDictionary['runEnvironment'] = runEnvironment
        configurationDictionary['timeout'] = timeout
        configurationDictionary['authenticationType'] = authenticationType
        configurationDictionary['jsonFilePath'] = jsonFilePath

        configurationDictionary['merchantsecretKey'] = merchantSecretKey
        configurationDictionary['merchantKeyId'] = merchantKeyId
        configurationDictionary['keysDirectory'] = keysDirectory
        configurationDictionary['keyAlias'] = keyAlias
        configurationDictionary['keyPass'] = keyPass
        configurationDictionary['useMetaKey'] = useMetaKey
        configurationDictionary['portfolioID'] = portfolioID
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
    def create
        request_obj = CyberSource::CreateInvoiceRequest.new
        customer_information = CyberSource::Invoicingv2invoicesCustomerInformation.new
        customer_information.name = "Tanya Lee"
        customer_information.email = "tanya.lee@my-email.world"
        request_obj.customer_information = customer_information

        invoice_information = CyberSource::Invoicingv2invoicesInvoiceInformation.new
        invoice_information.invoice_number = "A123"
        invoice_information.description = "This is a test invoice"
        invoice_information.due_date = "2019-07-11"
        invoice_information.send_immediately = true
        invoice_information.allow_partial_payments = true
        invoice_information.delivery_mode = "none"
        request_obj.invoice_information = invoice_information

        order_information = CyberSource::Invoicingv2invoicesOrderInformation.new
        amount_details = CyberSource::Invoicingv2invoicesOrderInformationAmountDetails.new
        amount_details.total_amount = "2623.64"
        amount_details.currency = "USD"
        amount_details.discount_amount = "126.08"
        amount_details.discount_percent = 5.0
        amount_details.sub_amount = 2749.72
        amount_details.minimum_partial_amount = 20.00
        tax_details = CyberSource::Invoicingv2invoicesOrderInformationAmountDetailsTaxDetails.new
        tax_details.type = "State Tax"
        tax_details.amount = "208.04"
        tax_details.rate = "8.25"
        amount_details.tax_details = tax_details
        freight = CyberSource::Invoicingv2invoicesOrderInformationAmountDetailsFreight.new
        freight.amount = "20.00"
        freight.taxable = true
        amount_details.freight = freight
        order_information.amount_details = amount_details

        line_items = []
        line_items1 = CyberSource::Invoicingv2invoicesOrderInformationLineItems.new
        line_items1.product_sku = "P653727383"
        line_items1.product_name = "First line item's name"
        line_items1.quantity = 21
        line_items1.unit_price = "120.08"
        line_items << line_items1

        order_information.line_items = line_items
        request_obj.order_information = order_information

        config = merchantConfigProp
        api_client = CyberSource::ApiClient.new
        api_instance = CyberSource::InvoicesApi.new(api_client, config)

        data, status_code, headers = api_instance.create_invoice(request_obj)

        p '---------------------------'
        p data, status_code, headers
        p '---------------------------'

        begin
            if status_code == '201'
                render json: data, status: :ok
            else
                error_message = response.status_reason
                render json: { error: error_message }, status: :unprocessable_entity
            end
        rescue CyberSource::ApiError => e
            error_message = e.message
            render json: { error: error_message }, status: :unprocessable_entity
        end
    end
end
