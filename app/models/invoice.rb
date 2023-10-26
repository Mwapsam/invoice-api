class Invoice < ApplicationRecord
  belongs_to :customer
  has_one :order, dependent: :destroy
  has_one :payment, dependent: :destroy
  has_many :line_items, through: :order
  has_many :token_validates

  def total_entries
    self.class.where(customer_id:).count
  end
end
