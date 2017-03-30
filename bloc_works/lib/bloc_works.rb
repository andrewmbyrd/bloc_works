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
       controller_and_action(env)
     end
   end
end
