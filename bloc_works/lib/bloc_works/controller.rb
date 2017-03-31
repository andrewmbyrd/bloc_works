require "erubis"

module BlocWorks
   class Controller

     def initialize(env)
       @env = env
       @routing_params = {}
     end

     def dispatch(action, routing_params = {})

       @routing_params = routing_params
       text = self.send(action)
       if has_response?
         rack_response = get_response
         [rack_response.status, rack_response.header, [rack_response.body].flatten]
       else
         [200, {'Content-type' => 'text/html'}, [text].flatten]
       end

     end

     def self.action(action, response = {})
       #so this will actually create a new instance of controller (Rack object)
       #every time it is called. and when is it called? iff we get a
       #route defined of the type 'books#welcome'
       proc { |env| self.new(env).dispatch(action, response) }
     end

     def request
       @request ||=Rack::Request.new(@env)
     end

     def params
       #override new request.params with what is stored in @routing_params
       request.params.merge(@routing_params)
     end

     def response(text, status = 200, headers = {})
       raise "Cannot respond multiple times" unless @response.nil?
       @response = Rack::Response.new([text].flatten, status, headers)
     end

     #def render(*args)
    #   response(create_reponse_array(*args))
     #end

     def get_response
       @response
     end

     def has_response?
       !@response.nil?
     end

     def render(view, locals = {})
       #takes whatever the current controller is and gets the filename we want e.g. app/views/labels/name.html.erb
       filename = File.join("../","bloc_books","app", "views", controller_dir, "#{view}.html.erb")
       #template now stores the contents of the file
       template = File.read(filename)
       #this uses some external gem to convert .erb to html for the browser
       eruby = Erubis::Eruby.new(template)
       response(eruby.result(locals.merge(env: @env)), 200, {'Content-type' => "text/html"})
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
