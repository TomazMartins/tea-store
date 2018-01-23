class Client < ApplicationRecord
  has_many :orders

  def self.search( name )
    if name
      Client.where( 'name LIKE ?', "%#{ name }%" )
    else
      Client.all
    end
  end
end
