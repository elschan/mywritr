class AddUsersNotesComments < ActiveRecord::Migration
  def change

    create_table :users do |t|
      t.string :username, null: false, unique: true
      t.string :password, null: false
      t.string :tagline
      t.timestamps
    end

    create_table :notes do |t|
      t.integer :user_id, null: false
      t.string :text, null: false
      t.timestamps
    end

    create_table :comments do |t|
      t.integer :user_id, null: false
      t.integer :note_id, null: false
      t.string :text, null: false
      t.string :vote_kind
      t.timestamps
    end

  end
end
