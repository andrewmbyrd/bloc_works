require "bloc_works/version"
require_relative "bloc_works/controller"
require_relative "bloc_works/dependencies"

module BlocWorks
  # Your code goes here...
  class Application
     def call(env)
       [200, {'Content-Type' => 'text/html'}, ["Hello Blocheads!"]]
     end
   end
end
