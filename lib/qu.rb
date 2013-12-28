require 'qu/version'
require 'qu/logger'
require 'qu/hooks'
require 'qu/failure'
require 'qu/payload'
require 'qu/job'
require 'qu/backend/base'
require 'qu/failure/logger'
require 'qu/worker'

require 'forwardable'
require 'logger'

module Qu
  InstrumentationNamespace = :qu

  extend SingleForwardable
  extend self

  attr_accessor :backend, :failure, :logger, :graceful_shutdown, :instrumenter

  def_delegators :backend, :push, :pop, :size, :clear
  def_delegator :instrumenter, :instrument

  def backend
    @backend || raise("Qu backend not configured. Install one of the backend gems like qu-redis.")
  end

  def configure(&block)
    block.call(self)
  end

  # Internal: Convert an object to json.
  def dump_json(object)
    JSON.dump(object) if object
  end

  # Internal: Convert json to an object.
  def load_json(object)
    JSON.load(object) if object
  end
end

require 'qu/instrumenters/noop'

Qu.configure do |config|
  config.logger = Logger.new(STDOUT)
  config.logger.level = Logger::INFO
  config.instrumenter = Qu::Instrumenters::Noop
  config.failure = Qu::Failure::Logger
end

require "qu/failure/logger"
