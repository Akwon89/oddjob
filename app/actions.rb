helpers do
  #check database to see if user exists, if exists return user other wise nil.
  def current_user
    @users = User.all
    @users.find { |u| u[:id] == session[:user_id] }
  end

end

# Homepage (Root path)
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
  if @user
    @user.update_attributes(
      first_name: params[:first_name],
      last_name: params[:last_name],
      username: params[:username],
      email: params[:email],
      password:  params[:password]
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
  if @post
    @post.update_attributes(
      post_title: params[:post_title],
      description: params[:description],
      date:  params[:date],
      location:  params[:location],
      post_pic:  params[:post_pic]
    )
    if @post.save!
      redirect '/users/profile'
    else
      erb :'posts/edit'
    end
  end
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


