module Pigeon
  class Observer
    def observe(component)
      @components ||= []
      @components << component
    end

    def update(args)
      @components.map do |component|
        Thread.start(component) { component.notify(args) }
      end
    end
  end
end
