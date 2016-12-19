class List
  include Mongoid::Document
  field :name,            type: String
  field :description,     type: String, default: ""
  field :image_url,       type: String, default: "https://avatars2.githubusercontent.com/u/210414?v=3&s=400"  
  has_and_belongs_to_many :members
end
