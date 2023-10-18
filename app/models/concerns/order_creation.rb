module OrderCreation
    extend ActiveSupport::Concern
    
    included do
      belongs_to :invoice
    end
    
    def create_order(amount_details)
      create!(
        amount_details: amount_details
      )
    end
end