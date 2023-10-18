class Invoice < ApplicationRecord
    belongs_to :customer
    has_one :order
    has_many :line_items, through: :order
end
  