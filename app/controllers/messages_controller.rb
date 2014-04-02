class MessagesController < ApplicationController
 
 before_filter :set_user
 
 def index
   @inbox_messages = @user.received_messages
 end

 def sent
   @sent_messages = @user.sent_messages
 end

 def new
   @message = Message.new
 end

 def create
   @message = Message.new(params[:message])
   user = User.find_by(name:params[:name])
   @message.recepient_id = user.id
  # if user && user.authenticate(params[:name])
  #   @message.recepient_id = user.id
  #   @message.sender_id = @user.id
  #     if @message.save
  #       flash[:notice] = "Message has been sent"
  #       redirect_to index_messages_path(current_user, :mailbox=>:inbox)
  #     else
  #       render :action => :new
  #     end     
  # else
  #   flash[:error] = "Invalid recipient name"
  #   render 'new'
  # end
   @message.sender_id = @user.id
   if @message.save
     flash[:notice] = "Message has been sent"
     redirect_to index_messages_path(current_user, :mailbox=>:inbox)
   else
     render :action => :new
   end
 end
 
 def show
   @message = Message.readingmessage(params[:id],@user.id)
 end
 
 def more
   @message = Message.readingmessage(params[:id],@user.id)
 end

 def delete_multiple
   if params[:delete]
     params[:delete].each { |id|
     @message = Message.find(id)
     @message.mark_message_deleted(@message.id,@user.id) unless @message.nil?
     } 
     flash[:notice] = "Messages deleted"
     end
   redirect_to user_messages_path(@user, @messages)
 end

 def update
   @message = Message.new(params[:message])
   @message.sender_id = @user.id
   if @message.save
     flash[:notice] = "Message has been sent"
     redirect_to index_messages_path(current_user, :mailbox=>:inbox)
   else
     render :action => :new
   end
 end
 
 private
 def set_user
   @user = current_user
 end

 def message_params
   params[:message]
 end
end
