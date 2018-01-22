module OrdersHelper
  def get_quantity( ordered_teas, compared_tea )
    quantity = 0

    ordered_teas.to_a.each do |tea|
      if( tea.category == compared_tea.category )
        quantity = tea.quantity
      end
    end

    quantity
  end
end
