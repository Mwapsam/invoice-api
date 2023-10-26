class Order < ApplicationRecord
  include OrderCreation
  include LineItemCreation
  belongs_to :invoice
end
