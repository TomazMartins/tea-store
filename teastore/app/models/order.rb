class Order < ApplicationRecord
  has_many :teas
  accepts_nested_attributes_for :teas
end
