require 'clockwork'
require 'observed'
require "observed/clockwork/version"
require "observed/application"

module Observed
  module Clockwork
    extend self

    def register_observed_handler(args)
      Observed.init!
      Observed.configure args
      Observed.load! args[:config_file]
      ::Clockwork.handler do |job|
        Observed.run job
      end
    end

  end
end
