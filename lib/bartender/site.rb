require 'sprockets'
require 'tilt'
module Bartender

  class Site

    #Load the config, and compile the site
    def initialize(config)
      Bartender.configure(config)

      @sprockets_env = Sprockets::Environment.new
      @sprockets_env.append_path Bartender::DEFAULTS["assets"]
      compile_assets

      Dir.glob(File.join(Bartender::DEFAULTS["pages"], '/**/*')).each do |page|
        Page.new(page, @sprockets_env).compile unless page.split('/')[-1].match /^_/
      end
    end #Function initialize


    #compile the css and js assets for use in the page
    #uses sprokets set an environment, compile them, then get accessed
    def compile_assets
      Dir.glob(File.join(Bartender::DEFAULTS["assets"], '/**/*')).each do |asset|
        asset = Bartender::Asset.new(asset.gsub(File.join(Bartender::DEFAULTS["assets"], '/'), ''), @sprockets_env)

        if asset.found #make sure sprockets can find the asset
          asset.sprockets_object.write_to(asset.dest_path)
        end
      end
    end #Function compile_assets



    def self.create(name)
      name = File.join(Bartender::DEFAULTS["root"], name)
      if File.directory?(name)
        $stderr.puts "ERROR: Could not create a new site by that name (#{name}), it already exists!"
        exit 0
      else #no conflicts with the site name, create some shit
        Dir.mkdir(name) #make new site dir
        Dir.mkdir(File.join(name, Bartender::DEFAULTS["output"]))
        Bartender::DEFAULTS.values_at("layouts", "pages", "assets").each do |dir| #make default directories
          Dir.mkdir(File.join(name, dir))
        end

        #make asset directories
        ["js", "css", "images"].each do |asset_dir|
          Dir.mkdir(File.join(File.join(name, Bartender::DEFAULTS["assets"]), asset_dir)) #this is where un-comiled assets go
          Dir.mkdir(File.join(File.join(name, Bartender::DEFAULTS["output"]), asset_dir)) #this is where compiled assets will go
        end

        #copy over the default files
        templates = File.join(File.dirname(__FILE__), *%w[.. .. templates])
        FileUtils.cp(File.join(templates, "app.js"), File.join(File.join(name, Bartender::DEFAULTS["assets"]), "js"))     #app.js
        FileUtils.cp(File.join(templates, "app.css"), File.join(File.join(name, Bartender::DEFAULTS["assets"]), "css"))   #app.css
        FileUtils.cp(File.join(templates, "application.html.erb"), File.join(name, Bartender::DEFAULTS["layouts"]))       #application.html.erb
        FileUtils.cp(File.join(templates, "index.html.erb"), File.join(name, Bartender::DEFAULTS["pages"]))               #index.html.erb

      end

    end #Function create

  end #Class Site

end #Module Bartender