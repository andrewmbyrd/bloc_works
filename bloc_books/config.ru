require './config/application'
app = BlocWorks::Application.new

 use Rack::ContentType

#ok so here is where we draw up all those routes that just got defined.
#they're never called anywhere else, so you have to make sure to put a route
#here if you want it to exist. So then our config.ru file here acts as the
#config/routes file in a Rails application
 app.route do
   map "", "books#welcome"
   map ":controller/:id/:action"
   map ":controller/:id", default: { "action" => "show" }
   map ":controller", default: { "action" => "index" }
 end

 run(app)
