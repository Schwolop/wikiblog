class Post < ActiveRecord::Base
  attr_accessible :content, :user_id
  validates :content, :presence
  
  belongs_to :user
end
