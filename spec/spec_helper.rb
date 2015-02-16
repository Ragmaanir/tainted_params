require "tainted_params"
require 'wrong'

RSpec.configure do |config|
  include Wrong::Assert
  Wrong.config.colors
end
