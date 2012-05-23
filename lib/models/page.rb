module Milksteak
  class Page
    def self.list
      milk_root = Milksteak::Admin.milk_root
      page_dir = File.join(Milksteak::Admin.milk_root, "pages")
      FileUtils.mkdir(milk_root) unless File.exist? milk_root
      FileUtils.mkdir(page_dir) unless File.exist? page_dir
      Dir.glob("#{page_dir}/*.yml")
    end
    
    def self.open(name, mode = "r")
      page_dir = File.join(Milksteak::Admin.milk_root, "pages", "#{name}.yml")
      if File.exist?(page_dir)
        f = File.open(page_dir, mode)
      else
        f = File.new(page_dir, mode)
      end
      f
    end
    
    # reads a page into parsed params.  Pages are set up as yaml on top and
    # content below, parsed as liquid.  jekyll style.
    def self.read(name)
    end

    # writes params into a page.  
    def self.write(name, params = {})
    end  
  end
end
