class Message < ActiveRecord::Base
  belongs_to :sender, :foreign_key => :sender_id, :class_name => "User"
  
  validates :body, presence: true
end