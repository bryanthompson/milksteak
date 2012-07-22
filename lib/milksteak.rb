require "liquid"
require "milksteak/version"
require "milksteak/cms"
require "milksteak/liquid_helpers"
require "sinatra/base"
require "models/user"
require "models/yml_content"
require "models/layout"
require "models/page"
require "models/fragment"
require "rdiscount"

module Milksteak
  class Admin < Sinatra::Base
    set :views, File.join(File.dirname(__FILE__), "views")
    set :public_folder, File.join(File.dirname(__FILE__), "public")

    helpers do
      def h(s); ERB::Util.h(s); end

      def erb(*args)
        args[0] = args[0].to_sym
        if args[1]
          args[1][:layout] = "layouts/#{args[1][:layout]}".to_sym if args[1][:layout]
        end
        super
      end

      def coffee(*args)
        args[0] = args[0].to_sym
        super
      end
  
      def partial(template, *args)
        template_array = template.to_s.split('/')
        template = template_array[0..-2].join('/') + "/_#{template_array[-1]}"
        options = args.last.is_a?(Hash) ? args.pop : {}
        erb(:"#{template}", options)
      end

      def flash
        session[:flash] = {} if session[:flash] && session[:flash].class != Hash
        session[:flash] ||= {}
      end

      def flash_messages # prints flash messages nicely and consistently
        return if !session[:flash] or session[:flash].empty?
        msgs = []
        [:success, :error, :info].each do |notice|
          msgs << "<div class=\"alert alert-#{notice}\"><a class=\"close\" data-dismiss=\"alert\">x</a>#{flash[notice]}</div>" if flash[notice]
        end
        flash.clear
        msgs.join
      end
    end
  
    before '/ms-admin/?*' do
      # note: it is your responsibility to manage users and login processes. Any
      # reference milksteak uses to a user will be done through the value stored 
      # in session[:ms_user]. It is best to store a string or integer that you can
      # use on your own to reference the user.  This might change at some point to
      # allowing you to put a Milksteak::User in this variable with predictable 
      # fields that you could populate on login. That way, we can present user actions
      # in an easy manner.
 
      unless session[:ms_user]
        flash[:error] = "You must be logged in to see this area."
        redirect "/ms-admin/login" unless request.path_info == "/ms-admin/login"
      end
    end    

    get "/ms-admin" do
      @fragments = Milksteak::Fragment.list
      erb "admin", :layout => "admin"
    end

    # fragment editing  
    get "/ms-admin/fragments/:stub/edit" do
      @fragment = Milksteak::Fragment.load(params[:stub])
      erb "admin/fragments/edit", :layout => "admin"
    end
    post "/ms-admin/fragments/:stub/update" do
      flash[:success] = "Section content updated successfully."
      @fragment = Milksteak::Fragment.load(params[:stub])  
      @fragment = Milksteak::Fragment.write(params[:stub], @fragment.data, params[:page][:content])
      erb "admin/fragments/edit", :layout => "admin"
    end   

    get "/ms-admin/login" do
      erb "admin/login", :layout => "admin"
    end

    get "/ms-admin/app.js" do
      content_type :js
      coffee "app"
    end

  end
end
