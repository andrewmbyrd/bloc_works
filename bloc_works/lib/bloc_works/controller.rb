require "erubis"

module BlocWorks
   class Controller

     def initialize(env)
       @env = env
     end

     def render(view, locals = {})
       #takes whatever the current controller is and gets the filename we want e.g. app/views/labels/name.html.erb
       filename = File.join("app", "views", controller_dir, "#{view}.html.erb")
       #template now stores the contents of the file
       template = File.read(filename)
       #this uses some external gem to convert .erb to html for the browser
       eruby = Erubis::Eruby.new(template)
       eruby.result(locals.merge(env: @env))
     end

     #converts CurrentController to "current"
     def controller_dir
       klass = self.class.to_s
       klass.slice!("Controller")
       BlocWorks.snake_case(klass)
     end


   end
 end
