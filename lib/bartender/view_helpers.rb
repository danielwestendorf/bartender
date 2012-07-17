module Bartender
      
    module ViewHelpers

      #render a simple partial, use Tilt to render it
      #display an error if the partial isn't found
      def partial(filename, variables={})
        Bartender::Partial.new(filename, self.sprockets_env, variables)
      end

      #link the appropriate stylesheet
      def link_stylesheet(filename, options={})
        opts = {:rel => "stylesheet", :type => "text/css", :media => "all"}.merge(options) #these are the default options for the stylesheet

        file_path = File.join('css', filename)                                             #this is where the un-compiled asset currently resides
        asset = Bartender::Asset.new(file_path, self.sprockets_env)

        if asset
          return "<link #{opts.to_a.collect{|opt_a| "#{opt_a[0]}=\"#{opt_a[1]}\""}.join(' ')} src=\"#{asset.site_path}\"/>"
        else
          $stderr.puts "WARNING: Could not find stylesheet '#{filename}' in #{Bartender::DEFAULTS['assets']} for page #{self.page}"
          return "<!-- WARNING: Could not link stylesheet #{filename} -->"
        end
      end #Function link_stylesheet

      #link the appropriate js
      def link_script(filename, options={})
        opts = {:type => "text/javascript"}.merge(options) #these are the default options for the stylesheet

        file_path = File.join('js', filename)                                             #this is where the un-compiled asset currently resides
        asset = Bartender::Asset.new(file_path, self.sprockets_env)

        if asset
          return "<script #{opts.to_a.collect{|opt_a| "#{opt_a[0]}=\"#{opt_a[1]}\""}.join(' ')} src=\"#{asset.site_path}\"> </script>"
        else
          $stderr.puts "WARNING: Could not find javascript '#{filename}' in #{Bartender::DEFAULTS['assets']} for page #{self.page}"
          return "<!-- WARNING: Could not link javascript #{filename} -->"
        end
      end #Function link_script

      #link to the appropriate image
      def link_image(filename, options={})
       opts = {}.merge(options) #these are the default options for the stylesheet

        file_path = File.join('images', filename)                                             #this is where the un-compiled asset currently resides
        asset = Bartender::Asset.new(file_path, self.sprockets_env)

        if asset
          return "<img #{opts.to_a.collect{|opt_a| "#{opt_a[0]}=\"#{opt_a[1]}\""}.join(' ')} src=\"#{asset.site_path}\"/>"
        else
          $stderr.puts "WARNING: Could not find image '#{filename}' in #{Bartender::DEFAULTS['assets']} for page #{self.page}"
          return "<!-- WARNING: Could not link img #{filename} -->"
        end
      end #Function link_image

      #provide the path to the asset
      def asset_url(filename)

        asset = Bartender::Asset.new(filename, self.sprockets_env)

        if asset
          return asset.site_path
        else
          $stderr.puts "WARNING: Could not find asset '#{filename}' in #{Bartender::DEFAULTS['assets']} for page #{self.page}"
          return "<!-- WARNING: Could not find asset #{filename} -->"
        end
      end #Function link_image
        
    end #Module ViewHelpers

end #Module Bartender