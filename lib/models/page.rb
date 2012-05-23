module Milksteak
  class Page < YmlContent
    attr_accessor :route

    def self.folder; "pages"; end
    
    # override write to include validation for :route.  If validation
    # becomes something that is needed on a bigger scale, we'll need
    # to put this into another method activerecord-style
    
    def self.write(name, params = {}, content)
      super
    end
  end
end
