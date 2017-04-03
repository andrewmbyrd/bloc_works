module BlocWorks
   class Application
     attr_reader :router
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
  # and each rule is a hash with keys regex:, vars:, destination:,
  # and options:
   class Router
     attr_reader :rules
     def initialize
       @rules = []
     end

     #if it's there at all, options_hash will be a hash in our current
     #setup of routes, but I'll add that extra check just in case
     def get_options(options_hash)
       return {default: {}} unless options_hash && options_hash.is_a?(Hash)
       options_hash[:default] ||= {}
       options_hash
     end

     def assign_destination(destination_string)
       return nil unless destination_string && destination_string.is_a?(String)
       destination_string
     end

     def define_regular_expression_for_this_url_pattern(url_pattern)

       parts = url_pattern.split("/")
       parts.reject! { |part| part.empty? }

       regex_parts = []

       parts.each do |part|

        case part[0]

         when ":"
           if part == ":id"
             regex_parts << "([0-9]+)"
           else
             regex_parts << "([a-zA-Z0-9]+)"
           end

         when "*"
           regex_parts << "(.*)"

         else
           regex_parts << part
         end
       end

       regex_parts.join("/")

     end

     def assign_vars_for_this_url_pattern(url_pattern)

       parts = url_pattern.split("/")
       parts.reject! { |part| part.empty? }

       vars = []

       parts.each do |part|

        case part[0]

         when ":"
           vars << part[1..-1]

         when "*"
           vars << part[1..-1]

         end
       end

       vars
     end

     def build_rule_for_this_route(regex, vars, dest, options)
       rule = {regex: Regexp.new("^/#{regex}$"),
               vars: vars,
               destination: dest,
               options: options}
       @rules.push(rule)
     end

     #build the rules for the url patterns and options given in
     #config.ru
     def map(url, *args)

       raise "Too many args!" if args.size > 2

       #get_options needs to be run at least once in order to set our
       #`default` key in the hash. Options can be at position 0 or 1,
       #destination will be at position 0 or not there at all
       options = get_options(args.pop) if args[1]
       destination = assign_destination(args[0])
       options = get_options(args[0])


       #i realize that splitting the two following variables below  into
       #two funciton isn't DRY, but I'm just refacotring here to make things
       #as clear as possible
       vars_array = assign_vars_for_this_url_pattern(url)
       regex = define_regular_expression_for_this_url_pattern(url)

       build_rule_for_this_route(regex, vars_array, destination, options)


     end

     #we need the symbol :books in config.ru so that we know how to define
     #the blank url
     def resources(controller)
       controller_string = controller.to_s
       map "", "#{controller_string}#welcome"
       map ":controller/:id/:action"
       map ":controller/:action"
       map ":controller/:id", default: { "action" => "show" }
       map ":controller", default: { "action" => "index" }
     end


     def set_controller_action (rule, params)
       if rule[:destination]
         return get_destination(rule[:destination], params)
       else
         controller = params["controller"]
         action = params["action"]
         return get_destination("#{controller}##{action}", params)
       end

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

           rule[:vars].each_with_index do |var, index|
             params[var] = rule_match.captures[index]
           end

           #correct for the overlap in the pattern of :controller/:id
           # and :controller/:action
           if params["action"].to_i > 0
             params["id"] = params["action"]
             params["action"] = "show"
           end

           #so we have to RETURN the result of the function here
           #in order to break out of our loop
           return set_controller_action(rule, params)
         end
       end
     end

     #so if destination is an object with a call method, return it
     def get_destination(destination, routing_params = {})
       puts destination
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
       raise "Destination not found: #{destination}"
     end

   end


end
