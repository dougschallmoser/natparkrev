
class UsersController < ApplicationController

    get '/signup' do
        if !logged_in?
            erb :"users/signup"
        else 
            redirect "/users/#{current_user.slug}"
        end
    end

    post '/signup' do 
        @user = User.new(params[:user])
        if @user.save
            flash[:signed_up] = "You have successfully created an account."
            login(params[:user][:username], params[:user][:password])
        else 
            flash[:message] = "Username is already taken. Please try again."
            redirect "/signup"
        end 
    end
    
    get '/users/:username' do 
        redirect_if_not_logged_in
        @user = User.find_by_slug(params[:username])
        if @user && @user.username == session[:username]
            erb :"/users/show"
        else
            flash[:permission] = "You do not have permission to view that user's page."
            redirect "/users/#{current_user.slug}"
        end 
    end

    get '/users/:username/account' do 
        redirect_if_not_logged_in
        @user = User.find_by_slug(params[:username])
        if @user && @user.username == session[:username]
            erb :"/users/account"
        else
            flash[:permission] = "You do not have permission to edit that user's page."
            redirect "/users/#{current_user.slug}"
        end 
    end

    get '/users/:username/edit' do 
        redirect_if_not_logged_in
        @user = User.find_by_slug(params[:username])
        if @user && @user.username == session[:username]
            erb :"/users/edit"
        else
            flash[:permission] = "You do not have permission to edit that user's page."
            redirect "/users/#{current_user.slug}"
        end 
    end

    patch '/users/:username' do
        redirect_if_not_logged_in
        user = User.find_by_slug(params[:username])
        if user && user.username == session[:username]
            authenticate_and_change_password(user)
        else
            flash[:permission] = "You do not have permission to edit that user's page."
            redirect "/users/#{current_user.slug}/account"
        end
    end
    
    get '/login' do 
        if !logged_in?
            erb :"users/login"
        else 
            redirect "/users/#{current_user.slug}"
        end
    end

    post '/login' do 
        login(params[:username], params[:password])
    end

    get '/logout' do 
        if logged_in?
            session.clear
            redirect "/login"
        else
            redirect "/"
        end
    end

end