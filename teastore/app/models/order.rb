class Order < ApplicationRecord
  before_update :sanitilize
  before_save :sanitilize

  has_many :teas
  accepts_nested_attributes_for :teas

  def calculate_total_price
    total_price = 0

    self.teas.each do |tea|
      total_price = total_price + ( tea.price * tea.ordered_quantity )
    end

    self.total_price = total_price
  end

  private
  def sanitilize
    new_teas = sanitilize_order

    self.teas.replace( new_teas )
    self.calculate_total_price
  end

  def sanitilize_order
    self.teas.to_a.delete_if do |tea|
      tea.ordered_quantity.nil? || tea.ordered_quantity == 0
    end
  end
end
