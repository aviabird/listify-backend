class List
  include Mongoid::Document
  field :name,            type: String
  field :description,     type: String, default: ""
  
  has_and_belongs_to_many :members
end
