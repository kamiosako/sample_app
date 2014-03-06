require 'message_sender'
class Message < ActiveRecord::Base
 attr_accessible :subject, :body, :sender_id, :recepient_id, :read_at, :sender_deleted, :recepient_deleted
 validates_presence_of :subject, :message => "Please enter message title"

 serialize :recipient_ids, Array

 belongs_to :sender,
  :class_name => 'User',
  :primary_key => 'id',
  :foreign_key => 'sender_id'
 belongs_to :recepient,
  :class_name => 'User',
  :primary_key => 'id',
  :foreign_key => 'recepient_id'

 def mark_message_deleted
   self.sender_deleted = true if self.sender_id == id and self.id=id
   self.recepient_deleted = true if self.recepient_id == id and self.id=id
   self.sender_deleted && self.recepient_deleted ? self.destroy : save!
 end
 
 def self.readingmessage(id, reader)
   message = find(id, :conditions => ["sender_id = ? OR recepient_id = ?", reader, reader])
     if message.read_at.nil? && (message.recepient.id==reader)
       message.read_at = Time.now
       message.save!
     end
   message
 end

 def read?
   self.read_at.nil? ? false : true
 end

 def self.received_by(user)
   where(:recepient_id => user.id)
 end

 def self.sent_by(user)
   Message.where(:sender_id => user.id)
 end

 def recepients
   sent? ? children.collect(&:user) : parent.recepients
 end

 def recepients= users
   users.each { |u| recepient_ids << u.id }
 end

 def sent_date
   sent_at || received_at
 end
end
