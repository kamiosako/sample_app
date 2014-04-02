require 'message_sender'
class Message < ActiveRecord::Base
 attr_accessible :subject, :body, :sender_id, :recepient_id, :read_at, :sender_deleted, :recepient_deleted
 validates_presence_of :subject, :message => "Please enter message title"

 default_scope -> { order('created_at DESC') }

 belongs_to :sender,
  :class_name => 'User',
  :primary_key => 'id',
  :foreign_key => 'sender_id'
 belongs_to :recepient,
  :class_name => 'User',
  :primary_key => 'id',
  :foreign_key => 'recepient_id'

 def self.readingmessage(id, reader)
   message = find(id, :conditions => ["sender_id = ? OR recepient_id = ?", reader, reader])
   if message.read_at.nil? && (message.recepient.id==reader)
     message.read_at = Time.now
     message.save!
   end
   message
 end

 def self.received_by(user)
   where(:recepient_id => user.id)
 end

 def self.sent_by(user)
   Message.where(:sender_id => user.id)
 end

 def sent_date
   sent_at || received_at
 end
end
