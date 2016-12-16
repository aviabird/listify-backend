class UsersList
  include Mongoid::Document
  field :twitter_list_id,  type: String
  field :slug,             type: String
  field :name,             type: String
  belongs_to :user
  # has_and_belongs_to_many :user_members, class_name: 'Member'
end
