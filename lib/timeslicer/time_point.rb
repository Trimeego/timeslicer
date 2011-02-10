module Timeslicer
  class TimePoint
    attr_accessor :time, :value, :data
    def initialize(time, value, data)
      @time, @value, @data = time, value, data
    rescue StandardError => e
      raise Timeslicer::TSError.new(e)
    end
  
    def to_f
      @value.to_f
    rescue StandardError => e
      raise Timeslicer::TSError.new(e)
    end

    def to_json(*a)
      {
        'time' => @time, 
        'value' => @value, 
        'data' => @data
      }.to_json(*a)
    end
  
  end
end