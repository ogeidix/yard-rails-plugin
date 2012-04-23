module YARD
  module Rails
    module Plugin
      class ControllerParamsHandler < YARD::Handlers::Ruby::Base
        handles(/params\[(:|')\w+'?\]/)
        def process
          return unless owner.is_a?(YARD::CodeObjects::MethodObject)
          return unless owner.parent.is_a?(YARD::CodeObjects::ClassObject)
          return unless owner.parent.name.to_s[/Controller/]
          (owner[:params] ||= []) << statement.source.match(/params\[((:|')\w+'?)\]/)[1]
        end
      end
    end
  end
end