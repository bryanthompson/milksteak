module Milksteak
  class Cms
    @@pages = []

    def initialize(app)
      @app = app
    end

    def call(env)
      dup._call(env)
    end
    
    def load_pages
      @@pages = []
      Milksteak::Page.list.each do |name|
        name = name.match(/^.+\/(.+)\.yml/)[1]
        page = Milksteak::Page.load(name, "r")
        @@pages << page
      end
    end
  
    def route(url)
      # TODO
    end
  
    def _call(env)
      #puts "OK"
      @status, @headers, @response = @app.call(env)
      [@status, @headers, @response]
    end
  end
end
