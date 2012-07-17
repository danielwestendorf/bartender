module Bartender
      
  class Partial
    include ViewHelpers

    def initialize(partial, sprockets_env, variables={})
      @tempalte = ""
      @sprockets_env = sprockets_env
      variables.each {|k,v| instance_variable_set "@#{k}", v}
      search_string = File.join(Bartender::DEFAULTS['pages'], '_' + partial + "*")
      file = Dir.glob(search_string)[0]
      if file && File.exists?(file)
        @template = Tilt.new(file).render(self)
      else
        $stderr.puts "ERROR: Could not find partial file '#{partial}' in #{Bartender::DEFAULTS['pages']} for page #{self.page}"
        exit 0
      end
    end #Function init

    def to_s
      @template.to_s
    end #Function to_s


    def method_missing(m, *args)
      if m =~ /^(\w+)=$/
        instance_variable_set "@#{$1}", args[0]
      else
        instance_variable_get "@#{m}"
      end
    end #Funciton method_missing

  end #Class partial

end #Module Bartender