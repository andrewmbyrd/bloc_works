module BlocWorks
   class Application
     def controller_and_action(env)
       #path info is in the URL. want the middle two things as those will correspond to
       #controller and action
       #i've updated this line so that a URL like `localhost:3000/books/show/1` will set book_num=1
       _, controller, action, book_num = env["PATH_INFO"].split("/", 4)
       #binding.pry
       unless controller.empty?
         controller = controller.capitalize
         controller = "#{controller}Controller"

         #constant get turns a string into something like the Capitalized Class Name, so that we can actually have
         #the dynamic class name, and not just a string. I'm `send`ing it the action because action is also a String

        #now here if we have a book_num, then we can send that parameter to our show controller action
        #and by the way it needs to be converted to an int first so that SQL knows what to do with it
         unless book_num
           return [200, {'Content-Type' => 'text/html'}, [Object.const_get(controller).new(env).send(action)]]
         else
           #binding.pry
           return [200, {'Content-Type' => 'text/html'}, [Object.const_get(controller).new(env).send(action, book_num.to_i)]]
         end

       else
         return [200,{'Content-Type' => 'text/html'}, ["Hello Blocheads!"] ]
       end
     end

     def fav_icon(env)
       if env['PATH_INFO'] == '/favicon.ico'
         return [404, {'Content-type' => 'text/html'}, []]
       end

     end
   end
 end
