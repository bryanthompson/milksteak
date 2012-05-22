module Milksteak
  module Cms
    def initialize(app)
      @app = app
    end

    def call(env)
      dup._call(env)
    end

    def _call(env)
      puts "OK"
      @status, @headers, @response = @app.call(env)
      [@status, @headers, @response]
    end
  end
end
