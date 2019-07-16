require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/cookies'
require 'pg'
require 'rubygems'

enable :sessions



client = PG::connect(
  :host => "localhost",
  :user => 'TaikiNakajima', :password => '',
  :dbname => "sinatra_app")
  
  get '/' do
    erb :index
  end
  

  get '/signup' do
    erb :signup
  end


  post '/signup' do
    name = params[:name]
    email = params[:email]
    password = params[:password]
    if params[:name].empty?
      redirect('/signup')
    end
    if params[:email].empty?
      redirect('/signup')
    end
    if params[:password].empty?
      redirect('/signup')
    end

    # if params[:name] == nil || params[:email] == nil || params[:password] ==nil
    #   redirect('/signup')
    # end
    client.exec_params('INSERT INTO users (name, email, password) VALUES ($1,$2,$3)', [name, email, password])

    redirect('/login')
  end


  get '/login' do
    session[:id] = nil
    erb :login
  end


  post '/login' do
    name = params[:name]
    password = params[:password]
    users = client.exec_params ('SELECT * FROM users;')
     users.each do |user|
      if user ['name'] == name && user ['password'] == password
        session[:id] = user['id']
        session[:name] = name
        session[:password] =password
        redirect to('/mypage')
      end
    end

    # if params[:name] = name
    #   redirect to('/login')
    # end

    # if params[:password] = password
    #   redirect to('/login')
    # end
    redirect to('/login') if session[:id].nil?
  
    redirect to('/login')
  end

  
  get '/mypage' do
    redirect to('/login') if session[:id].nil?
    @count = client.exec_params('SELECT COUNT(content) FROM posts WHERE user_id = ($1)',[session[:id]]).first
    @content = client.exec_params('SELECT * FROM posts WHERE user_id = ($1)',[session[:id]])
    @created_at = client.exec_params('SELECT * FROM posts WHERE user_id = ($1)',[session[:id]])
    erb :mypage
  end


  post '/content' do
    content = params[:content]
    if params[:content].empty?
      redirect to('/mypage')
    end
    client.exec_params('INSERT INTO posts (user_id, content, created_at, uploaded_at) VALUES ($1, $2, $3, $4)', [session[:id], content, Time.now(), Time.now()])
    redirect('/mypage')
  end


  get '/delete/:id' do
    redirect to('/login') if session[:id].nil?
    post_id = params['id']
    client.exec_params('DELETE FROM posts WHERE posts.id = ($1)',[params['id']])
    redirect('/mypage')
  end
  

  get '/logout' do
    session[:id] = nil
    redirect('/')
  end

  
 get '/board' do
  redirect to('/login') if session[:id].nil?
  @content = client.exec_params('SELECT * FROM posts LEFT JOIN users ON posts.user_id = users.id' )
  # @content = client.exec_params('SELECT * FROM posts ')
  erb :board
 end 