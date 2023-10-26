class LineItem < ApplicationRecord
  include LineItemCreation
  belongs_to :order
end
