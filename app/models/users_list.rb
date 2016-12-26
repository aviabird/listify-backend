class UsersList
  include Mongoid::Document
  field :twitter_list_id,  type: String
  field :slug,             type: String
  field :name,             type: String
  belongs_to :user
  belongs_to :list
end
