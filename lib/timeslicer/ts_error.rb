module Timeslicer
  class TSError < StandardError
    def initialize(parent)
    @parent=parent
    end
    attr :parent
  end
end