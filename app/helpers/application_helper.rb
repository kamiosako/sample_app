module ApplicationHelper

 # ページごとの完全なタイトルを返します。
 def full_title(page_title)
   base_title = "Ruby on Rails Tutorial Sample App"
   if page_title.empty?
      base_title
   else
     "#{base_title} | #{page_title}"
   end
 end

 def message_person(mailbox_name, message)
   mailbox_name == 'inbox' ? message.sender : message.recipient_list.join(', ')
 end
end

