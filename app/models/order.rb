class Order < ApplicationRecord
  include OrderCreation
  include LineItemCreation
  belongs_to :invoice
  belongs_to :user
end
