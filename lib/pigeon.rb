require 'pigeon/version'
require 'pigeon/core'

module Pigeon
  def self.run(opts={})
    Core.new(opts).run
  end
end
