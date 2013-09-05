module Pigeon
  class Observer
    def observe(component)
      @components ||= []
      @components << component
    end

    def update(args)
      @components.each do |component|
        component.notify(args)
      end
    end
  end
end
