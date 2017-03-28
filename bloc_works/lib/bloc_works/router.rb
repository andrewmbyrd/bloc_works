module BlocWorks
   class Application
     def controller_and_action(env)
       #path info is in the URL. want the middle two things as those will correspond to
       #controller and action
       _, controller, action, _ = env["PATH_INFO"].split("/", 4)
       controller = controller.capitalize
       controller = "#{controller}Controller"

       #constant get turns a string into something like the Capitalized Class Name, so that we can actually have
       #the dynamic class name, and not just a string
       
     end

     def fav_icon(env)
       if env['PATH_INFO'] == '/favicon.ico'
         return [404, {'Content-type' => 'text/html'}, []]
       end

     end
   end
 end
