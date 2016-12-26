class Bike
  include Mongoid::Document

  field :bike_name, type: String
  field :bike_price, type: String

end
