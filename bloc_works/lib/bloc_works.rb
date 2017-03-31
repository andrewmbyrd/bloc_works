require "bloc_works/version"
require_relative "bloc_works/controller"
require_relative "bloc_works/dependencies"
require_relative "bloc_works/router"
require_relative "bloc_works/utility"
require "pry"

module BlocWorks
  # Your code goes here...
  class Application
     def call(env)

       if env['PATH_INFO'] == '/favicon.ico'
         return [404, {'Content-Type' => 'text/html'}, []]
       end

       #controller_and_action(env)

       #so rack app is the thing in `destination` in our
       #router.rules list
       rack_app = get_rack_app(env)
       rack_app.call(env)

     end
   end
end
