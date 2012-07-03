module Bartender

  class Site

    def initialize(config)
      Bartender.configure(config)
    end #Function initialize


    def self.create(name)
      name = File.join(Bartender::DEFAULTS["root"], name)
      if File.directory?(name)
        $stderr.puts "ERROR: Could not create a new site by that name (#{name}), it already exists!"
        exit 0
      else #no conflicts with the site name, create some shit
        Dir.mkdir(name) #make new site dir
        Bartender::DEFAULTS.values_at("layouts", "pages", "assets").each do |dir| #make default directories
          Dir.mkdir(File.join(name, dir))
        end

        #make asset directories
        ["js", "css", "images"].each do |asset_dir|
          Dir.mkdir(File.join(File.join(name, Bartender::DEFAULTS["assets"]), asset_dir))
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