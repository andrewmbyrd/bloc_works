module BlocWorks
   class Application

     def get_rack_app(env)
       if @router.nil?
         raise "No routes defined"
       end

       @router.look_up_url(env["PATH_INFO"])
     end

     def controller_and_action(env)
       #path info is in the URL. want the middle two things as those will correspond to
       #controller and action
       _, controller, action, _ = env["PATH_INFO"].split("/", 4)
       #binding.pry
       unless controller.empty?
         controller = controller.capitalize
         controller = "#{controller}Controller"

         #constant get turns a string into something like the Capitalized Class Name, so that we can actually have
         #the dynamic class name, and not just a string. I'm `send`ing it the action because action is also a String

         return [200, {'Content-Type' => 'text/html'}, [Object.const_get(controller).new(env).send(action)]]
       else
         return [200,{'Content-Type' => 'text/html'}, ["Hello Blocheads!"] ]
       end
     end

     def fav_icon(env)
       if env['PATH_INFO'] == '/favicon.ico'
         return [404, {'Content-type' => 'text/html'}, []]
       end

     end

     #so router only has one instance variable - rules, which is an array
     #instance eval is going to take that array and perform the proc on it
     def route(&block)
       @router ||= Router.new
       @router.instance_eval(&block)
     end
   end


  #a Router is nothing more than an array, whose indices each contain a rule
  # and each rule is a hash with keys regex:, vars:, destintation:,
  # and options:
   class Router
     def initialize
       @rules = []
     end

     #url is a srting.
     #args SHOULD be an array with up to two items:
     #the first is a destintation String
     #the second could be a Hash which contains options
     def map(url, *args)
       #if the last element of args is a hash, take it off and set options
       #to it. Now, if that was there, it should be a hash containing key
       #'default', which, itself has a key of another hash
       #if it wasn't there, then sed options{:default} to the empty Hash
       options = {}
       options = args.pop if args[-1].is_a?(Hash)
       options[:default] ||= {}

       #set destintation to nil, and then set it to whatever is at
       #the last inddex of args. Which looks like should be 0 because
       #after that pop, if there's anything left, then we raise an error
       destination = nil
       destination = args.pop if args.size > 0
       raise "Too many args!" if args.size > 0

      #similar to how we did in controller_and_action get the parts of the
      #url split up into an array based on the forward slash, then take
      #out empty parts (so if the url contained "//")
       parts = url.split("/")
       parts.reject! { |part| part.empty? }

      #vars and regex_parts are both set to the empty array
       vars, regex_parts = [], []

      #so now loop through each part of the array. Each of which is a
      #String
       parts.each do |part|
         #so we're looking at the first letter
         case part[0]
        #if it's a colon, add every following character to the next
        #index of vars. Then put in the next index of regex_parts
        #that the thing to match is any alphanumeric character
        #SO VARS WILL CONTAIN ALL OF OUR SYMBOLS - PATTERNS like
        #:controller, :action, :id
         when ":"
           vars << part[1..-1]
           regex_parts << "([a-zA-Z0-9]+)"
        #if it's a star, add every following character to the next
        #index of vars. And regex_parts gets a /.*/ to match  on
         when "*"
           vars << part[1..-1]
           regex_parts << "(.*)"
        #otherwise, regex_parts simple gets the string at this part of the
        #url (always ignoring "/" from the URL of course)
         else
           regex_parts << part
         end
       end

       #ok so now we're combining all of the regex parts into a single
       #string, which will be our total regex to match on later

       #vars is an array that contains all of the strings that had : or *
       #at the beginning

       #destination is either nil or what was at index 0 of args
       #options is either a blank hash or what was the hash at inded 1
       #of args
       regex = regex_parts.join("/")
       @rules.push({ regex: Regexp.new("^/#{regex}$"),
                     vars: vars, destination: destination,
                     options: options })
     end

     #ok so now we have a bunch of hashes in @rules. We're gonna pass
     #in (presumably) whatever url is of interest now
     def look_up_url(url)
       @rules.each do |rule|
         #so this is either a MatchData object if there is a match with
         #current url and a regex that is in our current rule, or nil
         rule_match = rule[:regex].match(url)

         #so we're only gonna do things when there is a match
         if rule_match
           #so we've found the rule whose regex matches this url, set
           #local options to its options hash
           options = rule[:options]
           #local params will be a 'shallow copy' of the hash at default
           #that means it will have options[default]'s isntance vars
           params = options[:default].dup

           #ok so now for each VAR, we're gonna assign params[var] to
           #the thing that's actually there. so  at then end, we should
           #have like params[controller] = books and so on
           rule[:vars].each_with_index do |var, index|
             params[var] = rule_match.captures[index]
           end

           if rule[:destination]
             return get_destination(rule[:destination], params)
           else
             controller = params["controller"]
             action = params["action"]
             return get_destination("#{controller}##{action}", params)
           end
         end
       end
     end

     #so if destination is an object with a call method, return it
     def get_destination(destination, routing_params = {})
       if destination.respond_to?(:call)
         return destination
       end

       #if destination is something like books#welcome
       if destination =~ /^([^#]+)#([^#]+)$/
         #name will be Books
         name = $1.capitalize
         #controller will be the Constant BooksController
         controller = Object.const_get("#{name}Controller")
         #ah, now here we use the class.action from above. passing in
         #welcome as the action, and routing params as the response object
         return controller.action($2, routing_params)
       end
       #otherwise we messed up by coming here
       raise "Destination no found: #{destination}"
     end

   end


end
