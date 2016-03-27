helpers do
  #check database to see if user exists, if exists return user other wise nil.
  def current_user
    @users = User.all
    @users.find { |u| u[:id] == session[:user_id] }
  end

end


get '/' do
  erb :index
end

get '/users/new' do
  @user = User.new
  erb :'users/new'
end

post '/users/new' do
  @user = User.new(
    first_name: params[:first_name],
    last_name: params[:last_name],
    username: params[:username],
    email: params[:email],
    password:  params[:password]
  )
  if @user.save
    redirect '/users/login'
  else
    erb :'users/new'
  end
end

get '/users/login' do
  erb :'users/login'
end

post '/users/login' do
  @users = User.all
  @user = @users.find { |u| u[:username] == params[:username] }
  if @user && @user[:password] == params[:password]
    session[:user_id] = @user[:id]
  end
  redirect '/home'
end

get '/users/logout' do
  session[:user_id] = nil
  redirect '/'
end

get '/users/profile' do
  @posts = Post.where(user_id: current_user.id)
  erb :'users/profile'
end

get '/users/edit' do
  erb :'users/edit'
end

post '/users/edit' do
  @user = current_user

  @filename = params[:file][:filename]
  file = params[:file][:tempfile]
                      #users id.jpg
  File.open("./public/user_pics/#{@filename}", 'wb') do |f|
    f.write(file.read)
  end
  if @user
    @user.update_attributes(
      first_name: params[:first_name],
      last_name: params[:last_name],
      username: params[:username],
      email: params[:email],
      password:  params[:password],
      about_you: params[:about_you],
      location: params[:location],
      user_pic: "/user_pics/#{@filename}"
    )
    if @user.save!
      redirect '/users/profile'
    else
      erb :'users/edit'
    end
  end
end

#################

get '/posts/new' do
  @post=Post.new
  erb :'posts/new'
end

post '/posts/new' do
  if current_user
    @post = current_user.posts.create(
      post_title: params[:post_title],
      description: params[:description],
      date:  params[:date],
      location:  params[:location],
      post_pic:  params[:post_pic]
    )
    # @post.user_id = current_user.id
    if @post.save
      redirect '/home'
    else
      flash[:danger] = 'Please fill all required fields.'
      erb :'posts/new'
    end
  else
      flash[:danger] = 'You must login to create a post!'
      redirect '/users/login'

  end
end

get '/posts/edit/:id' do
  @post = Post.find params[:id]
  erb :'posts/edit'
end

post '/posts/edit' do
  @post = Post.find params[:id]
  @filename = params[:file][:filename]
  file = params[:file][:tempfile]
                      #users id.jpg
  File.open("./public/post_pics/#{@filename}", 'wb') do |f|
    f.write(file.read)
  end
  if @post
    @post.update_attributes(
      post_title: params[:post_title],
      description: params[:description],
      date:  params[:date],
      location:  params[:location],
      post_pic: "/post_pics/#{@filename}"
    )
    if @post.save!
      redirect '/users/profile'
    else
      erb :'posts/edit'
    end
  end
end

post '/post/delete/:id' do
  @post= Post.find params[:id]
  @post.destroy!
  redirect '/users/profile'
end

# display all the posts / homepage
get '/home' do
  @posts = Post.all
  erb :'/home'
end
###########

post '/liked' do
  @like = Like.create(
    user_id: session[:user_id],
    post_id: params[:post_id]
    )
  @like.save
  redirect '/home'
end

post '/disliked' do
  @like = Like.find_by(
    user_id: session[:user_id],
    post_id: params[:post_id])
  @like.destroy
  redirect '/home'
end

post '/disliked_in_show' do
  @like = Like.find_by(
    user_id: session[:user_id],
    post_id: params[:post_id])
  @like.destroy
  redirect "/users/profile"
end

post '/liked_in_show' do
  @like = Like.create(
    user_id: session[:user_id],
    post_id: params[:post_id]
    )
  @like.save
  redirect "/users/profile"
end
#########



get '/messages/new' do
  # @message = Message.new
  # && @post_info
  unless params[:post_id].nil?
    @post_info ={
      post_id: params[:post_id],
      post_name: params[:post_name],
      recipient_id: params[:recipient_id]
    }
  end
  erb :'/messages/new'
end

post '/messages/new' do
  if current_user
    @message = Message.create(
      recipient_id: params[:recipient_id],
      text:  params[:text],
      sender_id: current_user.id,
      post_id:  params[:post_id],
      subject:  params[:subject]
    )
  end
  if @message.save
    redirect '/home'
  else
    @post_info ={
      post_id: params[:post_id],
      post_name: params[:subject],
      recipient_id: params[:recipient_id]
    }
    erb :'/messages/new'
  end
end

get '/messages/all' do
  @messages = Message.where(recipient_id: current_user.id)
  erb :'/messages/all'
end

get '/messages/sent' do
  @messages = Message.where(sender_id: current_user.id)
  erb :'/messages/sent'
end

post '/messages/delete/:id' do
  @message= Message.find params[:id]
  @message.destroy!
  redirect '/messages/all'
end

