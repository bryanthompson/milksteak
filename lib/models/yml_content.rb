module Milksteak
  class YmlContent
    attr_accessor :name, :file, :data, :content, :output

    def self.list
      milk_root = Milksteak::Admin.milk_root
      page_dir = File.join(Milksteak::Admin.milk_root, folder)
      FileUtils.mkdir(milk_root) unless File.exist? milk_root
      FileUtils.mkdir(page_dir) unless File.exist? page_dir
      Dir.glob("#{page_dir}/*.yml")
    end
    
    # loads a page from yaml, sets data and content attributes, returns a Milksteak::Page
    def self.load(name, mode = "r")
      milk_root = Milksteak::Admin.milk_root
      page_dir = File.join(Milksteak::Admin.milk_root, folder)
      FileUtils.mkdir(milk_root) unless File.exist? milk_root
      FileUtils.mkdir(page_dir) unless File.exist? page_dir

      page_dir = File.join(page_dir, "#{name}.yml")
      f = File.exist?(page_dir) ? File.open(page_dir, mode) : File.new(page_dir, mode)

      p = self.new
      p.name = name
      p.file = f
      p.read_yaml
      p
    end
    
    # writes to a page.  Replaces params and content, doesn't merge. 
    def self.write(name, params = {}, content)
      p = self.load(name, "w+")
      p.data = params
      p.content = content
      p.write_yaml
      p.file.close
      p
    end  
  
    def self.render(name, params = {})
      begin
        p = self.load(name, "r")
        p.render(params)
      rescue Errno::ENOENT => e
        ""
      end
    end  

    def write_yaml
      if self.data.empty?
        self.file.write("---\n")
      else
        self.file.write(YAML.dump(self.data))
      end
      self.file.write("---\n\n")
      self.file.write(self.content)
    end

    def read_yaml
      self.content = self.file.read
      begin
        if self.content =~ /^(---\s*\n.*?\n?)^(---\s*$\n?)(.*)/m
          self.content = $3
          self.data = YAML.load($1)
        end
      rescue => e
        puts "YAML Exception reading #{name}: #{e.message}"
      end
      self.data ||= {}
    end
    
    # todo: test
    def render(params = {})
      rendered = Liquid::Template.parse(self.content).render(self.data.merge("params" => params))

      if self.data["format"]
        rendered = RDiscount.new(rendered, :smart).to_html if self.data["format"] == "markdown"
      end

      if self.data["layout"]
        layout = Milksteak::Layout.load(self.data["layout"])
        data = layout.data.merge("yield" => rendered, "params" => params)
        rendered = Liquid::Template.parse(layout.content).render(data)
      end

      return rendered
    end
  end
end
