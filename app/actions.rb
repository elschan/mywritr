helpers do

  def current_user
    if session[:id] && session[:id] != "" 
      User.find(session[:id])
    end
  end
   
 #Return the new array


end

## Home and Session Login ##
get '/' do
  @notes = Note.order(created_at: :desc)
  erb :'notes/index'
end

get '/session/new' do
  erb :'/user_session/new'
end 

post '/session' do
  @user = User.find_by(username: params[:username])
  @username = params[:username]
  if @user && @user.password == params[:password]
    session[:id] = @user.id
    redirect '/'
  else
    #error messages
    @error_message = ""
    if params[:username].empty? && params[:password].empty?
      @error_message = "Please fill in your username and password."
    elsif params[:username].empty?
      @error_message = "Please fill in your username."
    elsif !@user
      @error_message = "Username does not exist."
    elsif @user && @user.password != params[:password]
      @error_message = "Your password is wrong"
    end
    erb :'/user_session/new'
  end
end

delete '/session' do
  session[:id] = ""
  redirect '/'
end

## Users ##
get '/users/new' do
  erb :'/users/new'
end 

post '/save_tag' do
  user = current_user
  user.tagline = params[:new_tag]
  user.tagline = nil if user.tagline.blank?
  if user.save
    { :success => 'good' }.to_json
  else
    @error_message_tagline = current_user.errors
    @error_message_tagline.to_json
  end
  

end

post '/users' do
  user = User.new(username: params[:username], password: params[:password], tagline: params[:tagline])
  if user.save
    session[:id] = user.id
    redirect "/"
  else
    @errors = user.errors
    erb :'/users/new'
  end
end 

get '/users/:id/follows' do
  @user = User.find(params[:id])
  new_user_follows = @user.user_follows.where(notification_flag: false)
  @is_followed_by_new_ids = new_user_follows.pluck(:is_following_id)
  new_user_follows.each do |follow|
    follow.notification_flag = true
    follow.save
  end
  erb :'users/follows'
end

get '/users/:id' do
  @user = User.find(params[:id])
  @notes = @user.notes.order(created_at: :desc)
  erb :'users/profile'
end

post '/users/newfollow' do
  new_follow = current_user.follow_user(params[:user_id_to_follow].to_i)
  @errors = new_follow.errors
  redirect "/users/#{params[:user_id_to_follow]}"
end

post '/users/unfollow' do
  current_user.unfollow_user(params[:user_id_to_unfollow].to_i)
  redirect "/users/#{params[:user_id_to_unfollow]}"
end

## Notes ##
get '/notes' do
  @notes = Note.order(created_at: :desc)
  erb :'notes/index'
end

get '/notes/new' do
  erb :'notes/new'
end

post '/notes' do
  if params[:text].empty?
    @error_message = "Please write something!"
    erb :'notes/new'
  else
    @note = Note.create(user_id: current_user.id, text: params[:text])

    redirect "/notes/#{@note.id}"
  end
end

get '/notes/:id' do
  @note = Note.find(params[:id])
  erb :'notes/note'
end

post '/notes/:id/comments' do
  new_comment = Comment.new(user_id: current_user.id, note_id: params[:id], text: params[:text])
  new_comment.vote_kind = params[:vote_kind] if params[:vote_kind]
  if new_comment.save
    redirect "/notes/#{params[:id]}"
  else
    @note = Note.find(params[:id])
    @errors = new_comment.errors
    erb :'notes/note'
  end
end
## Search ##
get '/search'  do
  @results_notes = []
  @results_users = []
  @results_notes_based_on_users = []
  @notes = Note.all
  @users = User.all
  @no_search_results_error = "No search results. Please try again"
  @top_searches = []
  if params[:query]
    if params[:query].length == 1 
      @notes.each do |result|
      @results_notes << result if result.text[0].downcase == params[:query].downcase  
        end
      @users.each do |result|
      @results_users << result if result.username[0].downcase == params[:query].downcase
        end
      @notes.each do |result|
      @results_notes_based_on_users << result if result.author[0].downcase == params[:query].downcase   
        end
    else
      query_array = params[:query].split(" ")
      query_array.each do |word|
         # @results_notes = Note.find_by_sql(["SELECT *, count(text) FROM notes WHERE text LIKE ? GROUP BY text ORDER BY count(text)","%#{word.downcase.gsub("'", "''")}%"]) 
        Note.where("lower(text) LIKE ?", "%#{word.downcase.gsub("'", "''")}%").each do |result|
            @results_notes << result
        end
        User.where("lower(username) LIKE ?", "%#{word.downcase.gsub("'", "''")}%").each do |result|
            @results_users << result
        end
      end

    end
  end
  erb :'search/index'
end

