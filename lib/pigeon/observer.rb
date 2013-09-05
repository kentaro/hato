module Pigeon
  class Observer
    def observe(component)
      @components ||= []
      @components << component
    end

    def update(args)
      @components.map { |component|
        Thread.start(component) { component.notify(args) }
      }.each(&:join)
    end
  end
end
