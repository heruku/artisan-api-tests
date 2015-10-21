require 'yaml'
require 'ostruct'

module Inputs
  def config
    @yaml ||= YAML.load_file('.config')
  end

  def base
    OpenStruct.new(config.fetch('base'))
  end

  def compare
    OpenStruct.new(config.fetch('compare'))
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.include Inputs

  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.disable_monkey_patching!
  config.order = :random
  Kernel.srand config.seed
end
