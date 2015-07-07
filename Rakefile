require 'json'
require 'rake'
require "sinatra/activerecord/rake"
require ::File.expand_path('../config/environment', __FILE__)

Rake::Task["db:create"].clear
Rake::Task["db:drop"].clear

# NOTE: Assumes SQLite3 DB
desc "create the database"
task "db:create" do
  touch 'db/db.sqlite3'
end

desc "drop the database"
task "db:drop" do
  rm_f 'db/db.sqlite3'
end

desc 'Retrieves the current schema version number'
task "db:version" do
  puts "Current version: #{ActiveRecord::Migrator.current_version}"
end

desc 'Adds some sample data to the database'
task "db:populate" do
  # Users
  john = User.create(username: 'john', password: '123')
  bob = User.create(username: 'bob', password: '456')
  voldemort = User.create(username: 'voldemort', password: 'avadacadavra')
  gandalf = User.create(username: 'gandalf', password: 'youshallnotpassword')
  # Notes
  johns_note_1 = john.notes.create(text: "Just read John Locke's 'Leviathan' and I'm not impressed. Why would he go into so much detail regarding pies?")
  johns_note_2 = john.notes.create(text: "Turns out that my ancestor is actually Renee Descartes himself! Sweet!")
  bobs_note = bob.notes.create(text: "This is meant to be a clearly racist and hated remark, but I don't want to write one of those.")
  voldys_note = voldemort.notes.create(text: "I don't know why people hate me for Harry Potter's scar. I think it's pretty fashionable, in all honesty.")
  # Comments
  ###
  johns_note_1.comments.create(user_id: bob.id, text: "Good job on getting through that tome!", vote_kind: 'like')
  johns_note_1.comments.create(user_id: john.id, text: "Thanks, bob. I appreciate it.")
  johns_note_1.comments.create(user_id: voldemort.id, text: "I also like pie. Just thought you should know that.")
  ###
  johns_note_2.comments.create(user_id: bob.id, text: "That's incredible!", vote_kind: 'omg')
  johns_note_2.comments.create(user_id: bob.id, text: "That's really, really incredible!", vote_kind: 'omg')
  johns_note_2.comments.create(user_id: voldemort.id, text: "I don't like this.", vote_kind: 'dislike')
  johns_note_2.comments.create(user_id: john.id, text: "I don't like you, voldemort.")
  ###
  bobs_note.comments.create(user_id: john.id, text: "Seriously?!", vote_kind: 'wtf')
  bobs_note.comments.create(user_id: john.id, text: "Really, seriously?!", vote_kind: 'wtf')
  bobs_note.comments.create(user_id: john.id, text: "Why would you SAY something like this?", vote_kind: 'wtf')
  bobs_note.comments.create(user_id: voldemort.id, text: "I approve!", vote_kind: 'like')
  bobs_note.comments.create(user_id: voldemort.id, text: "I approve a lot!", vote_kind: 'like')
  # User Follows
  bob.follow_user(john.id)
  bob.follow_user(voldemort.id)
  john.follow_user(voldemort.id)
  voldemort.follow_user(bob.id)
  UserFollow.all.each do |follow|
    follow.notification_flag = true
    follow.save
  end
end


