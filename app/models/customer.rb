class Customer < ApplicationRecord
    has_many :invoices
    belongs_to :user

    before_create :issue_merchant_id

    def issue_merchant_id
          self.merchant_customer_id = SecureRandom.uuid
    end
end
