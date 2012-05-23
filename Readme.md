# Installation

    gem install milksteak 
    gem 'milksteak' # if using bundler

# Configuration

In your site's config, make sure milksteak is being required, then set your milk_root:

    # This would create and use a milk/ folder in the root of your site.
    Milksteak::Admin.set :milk_root, File.join(File.dirname(__FILE__), "milk")

If you plan on using the Milksteak::Admin module, include it in your rack cascade.  Here's an example, but you might need to figure out an alternative way if using rails or some other setup:

    run Rack::Cascade.new [Sinatra::Application, Milksteak::Admin]

# Usage

There are several ways to use Milksteak for content management.  The simplest example would be to include an editable area on a random page.  Let's say we want some sidebar text to be editable.  

    # views/sidebar.erb
    <%= Milksteak::Page.render("sidebar-content") %>

    # milk/pages/sidebar-content.yml
    ---
    yml_variables: can go here
    and_then_you: can use them below in content.
    ---
    
    Here's the sidebar content. I can use the {{yml_variables}} and such.

