class List
  include Mongoid::Document
  
  field :twitter_list_id, type: String
  field :name,            type: String
  field :description,     type: String
  field :mode,            type: String, default: "public"
  field :slug,            type: String
  belongs_to :user
  has_many :members
end
