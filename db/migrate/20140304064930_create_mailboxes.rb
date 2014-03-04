class CreateMailboxes < ActiveRecord::Migration
  def change
    create_table :mailboxes do |t|

      t.timestamps
    end
  end
end
