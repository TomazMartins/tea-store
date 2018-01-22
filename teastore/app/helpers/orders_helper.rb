module OrdersHelper
  def get_quantity( ordered_teas, compared_tea )
    quantity = 0

    ordered_teas.to_a.each do |tea|
      if( tea.name == compared_tea.name )
        quantity = tea.ordered_quantity
      end
    end

    quantity
  end
end
