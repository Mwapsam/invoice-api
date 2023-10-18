module LineItemCreation
    extend ActiveSupport::Concern
    
    included do
      has_many :line_items, dependent: :destroy
    end
    
    def add_line_item(product_sku, product_name, quantity, unit_price, discount_amount, tax_amount, tax_rate, total_amount)
      line_items.create!(
        product_sku: product_sku,
        product_name: product_name,
        quantity: quantity,
        unit_price: unit_price,
        discount_amount: discount_amount,
        tax_amount: tax_amount,
        tax_rate: tax_rate,
        total_amount: total_amount
      )
    end
end
  