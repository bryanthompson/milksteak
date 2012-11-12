module Milksteak
  class Cms
    @@pages = []
    @@routes = nil

    def initialize(app)
      @app = app
    end

    def call(env)
      dup._call(env)
    end
    
    def load_pages
      puts "LOADING PAGES"
      @@pages = []
      Milksteak::Page.list.each do |name|
        name = name.match(/^.+\/(.+)\.yml/)[1]
        page = Milksteak::Page.load(name, "r")
        @@pages << page
      end
    end
  
    # todo: test
    def routes
      return @@routes if @@routes
      puts "LOADING ROUTES"
      load_pages if @@pages.empty?
      @@routes = { :primary => [], :dynamic => [] }
      @@pages.each do |page|
        r = Route.new(page)
        r.primary ? (@@routes[:primary] << r) : (@@routes[:dynamic] << r)
      end
      return @@routes
    end  

    def route(url)
      # search primary first, then dynamic
      routes[:dynamic].sort { |a,b| b.length <=> a.length }.each do |route|
        if tmp = url.match(route.pattern)
          keys = route.page.data["route"].split("/").reject{|x| x[0] != ":"}
          params = {}
          # our match data includes the original string, so compare against 
          # its length minus that position
          if keys.length == tmp.length-1
            keys.each_with_index do |k,i| 
              k = k.gsub(/^\:/, "")
              # our arrays are off-by-one because of the case above
              params[k] = tmp[i+1]
            end
          end
          return { :page => route.page, :params => params }
        end
      end
      routes[:primary].sort { |a,b| b.length <=> a.length }.each do |route|
        if url.match(route.pattern)
          if route.page.data["route"] == "/"
            # do extra checking to see if they asked for /index, /, or /home
            if %w(index home /).include? url
              return { :page => route.page } 
            else
              return {:page => nil}
            end
          else
            return { :page => route.page } 
          end
        end
      end
      return nil
    end
  
    def _call(env)
      if match = route(env["PATH_INFO"]) and match[:page]
puts match.inspect
        @response = [match[:page].render]
        [200, {"Content-Type" => "text/html", "Content-Length" => @response[0].bytesize.to_s}, @response]
      else    
        @status, @headers, @response = @app.call(env)
        [@status, @headers, @response]
      end
    end
  end
  
  # todo: test
  class Route
    attr_accessor :pattern
    attr_accessor :page
    attr_accessor :primary
    attr_accessor :length

    def initialize(page)
      @primary = true
      @length = page.data["route"].length
      @page = page
      @pattern = build_expression(page.data["route"])
      super()
    end 
    
    private
    
    def build_expression(url_string)
      parts = url_string.split("/")
      parts.each_with_index do |part,x|
        if part =~ /\:(.+)/
          parts[x] = "(.+)"
          @primary = false
        end 
      end 
      Regexp.new(parts.join("\/"))
    end 
  end
end
