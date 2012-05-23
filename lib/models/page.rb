module Milksteak
  class Page
    attr_accessor :data, :content, :output

    def self.list
      milk_root = Milksteak::Admin.milk_root
      page_dir = File.join(Milksteak::Admin.milk_root, "pages")
      FileUtils.mkdir(milk_root) unless File.exist? milk_root
      FileUtils.mkdir(page_dir) unless File.exist? page_dir
      Dir.glob("#{page_dir}/*.yml")
    end
    
    # loads a page from yaml, sets data and content attributes, returns a Milksteak::Page
    def self.load(name, mode = "r")
      page_dir = File.join(Milksteak::Admin.milk_root, "pages", "#{name}.yml")
      f = File.exist?(page_dir) ? File.open(page_dir, mode) : File.new(page_dir, mode)
      p = self.new
      p.read_yaml(name, f)
      p
    end
    
    # writes params into a page.  
    def self.write(name, params = {})
    end  

    def read_yaml(name, file)
      self.content = file.read
      begin
        if self.content =~ /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
          self.content = $POSTMATCH
          self.data = YAML.load($1)
        end
      rescue => e
        puts "YAML Exception reading #{name}: #{e.message}"
      end
      self.data ||= {}
    end
  end
end
