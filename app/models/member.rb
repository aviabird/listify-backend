class Member
  include Mongoid::Document

  field :twitter_id , type: String
  field :screen_name, type: String
  field :uri,         type: String

  has_and_belongs_to_many :lists
end
