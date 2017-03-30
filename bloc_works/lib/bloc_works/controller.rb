require "erubis"

module BlocWorks
   class Controller

     def initialize(env)
       @env = env
     end

     def render(view, locals = {})
       #takes whatever the current controller is and gets the filename we want e.g. app/views/labels/name.html.erb
       filename = File.join("../","bloc_books","app", "views", controller_dir, "#{view}.html.erb")
       #template now stores the contents of the file
       template = File.read(filename)
       #this uses some external gem to convert .erb to html for the browser
       eruby = Erubis::Eruby.new(template)

       #we need to get all of the instance variables from the
       #controller and assign them to this instance of Erubis
       instance_variables.each do |var|
         value = instance_variable_get(var)
         eruby.instance_variable_set(var, value)
       end
       eruby.result(locals.merge(env: @env))
       #binding.pry
     end

     #converts CurrentController to "current"
     def controller_dir
       klass = self.class.to_s
       klass.slice!("Controller")
       BlocWorks.snake_case(klass)
     end


   end
 end
