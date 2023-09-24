class Order < ApplicationRecord
    belongs_to :invoice
    has_many :line_items
end
