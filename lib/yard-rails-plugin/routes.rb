module YARD
  module Rails
    module Plugin
      class Routes
        def initialize
          puts '[rails-plugin] Analyzing Routes...'
          ::Rails.application.reload_routes!
          all_routes = ::Rails.application.routes.routes
          @routes = all_routes.collect do |route|            
            reqs = route.requirements.dup
            rack_app =  route.app.class.name.to_s =~ /^ActionDispatch::Routing/ ? nil : route.app.inspect
            constraints = reqs.except(:controller, :action).empty? ? '' : reqs.except(:controller, :action).inspect
            if reqs[:controller]
              controller = reqs[:controller] + '_controller'
              controller = (controller.split('_').map{ |s| s[0].upcase + s[1..-1] }).join('')
              controller = (controller.split('/').map{ |s| s[0].upcase + s[1..-1] }).join('::')
            else
              controller = ''
            end
            { name: route.name.to_s, verb: route.verb.to_s, path: route.path,
              controller: controller , action: reqs[:action], rack_app: rack_app, constraints: constraints}
          end
          @routes.reject! { |r| r[:path] =~ %r{/rails/info/properties|^/assets} }
        end

        def generate_routes_description_file(filename)
          File.open(File.join(Dir.pwd, filename), 'w') do |f|
            f.puts "<h1>Routes</h1><br /><br />"
            f.puts "<table><tr style='background: #EAF0FF; font-weight: bold; line-height: 28px; text-align: left'><th>&nbsp;&nbsp;Rails Method</th><th>&nbsp;&nbsp;Verb</th><th>&nbsp;&nbsp;Endpoint</th><th>&nbsp;&nbsp;Destionation</th></tr>"
            i = 0
            @routes.each do |r|
              odd_or_even = ((i % 2  == 0) ? 'even' : 'odd')  
              if r[:rack_app]
                destination = "<pre>#{r[:rack_app].inspect} #{r[:constraints]}</pre>"
              else
                destination = "{#{r[:controller]} #{r[:controller]}}##{r[:action]}  #{r[:constraints]}"
              end
              endpoint = r[:path].gsub(/(:|\*)\w+/) { |m| "<span style='font-family: monospace; color: green'>#{m}</span>"}
              f.puts "<tr class='#{odd_or_even}'><td>#{r[:name]}</td><td>#{r[:verb]}</td><td>#{endpoint}</td><td>#{destination}</td></tr>"
              i += 1
            end
            f.puts "</table>"
          end
        end

        def enrich_controllers
          @routes.each do |r|
            if r[:controller] && node = YARD::Registry.resolve(nil, r[:controller], true)
              (node[:routes] ||= []) << r
            end
            if r[:controller] && r[:action] && node = YARD::Registry.resolve(nil, r[:controller]+'#'+r[:action], true)
              (node[:routes] ||= []) << r
            end
          end
        end
      end
    end
  end
end