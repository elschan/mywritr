class AddNewUserFollowNotificationColumn < ActiveRecord::Migration
  def change

    change_table :user_follows do |t|
      t.boolean :notification_flag, default: false
    end

  end
end
