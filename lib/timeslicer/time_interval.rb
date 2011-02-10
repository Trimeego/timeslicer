module Timeslicer

  class TimeInterval
    attr_accessor :points
    attr_reader :start_time, :end_time, :interval, :duration
    def initialize(init_time, interval)
      @points = []
      if ['s', 'ss', 'second', 'seconds'].include? interval
        @interval = 'second'
        @dutation = 1;
        @start_time = init_time
        @end_time = init_time      
      elsif ['M', 'MM',  'nn', 'minute', 'minutes'].include? interval        
        @interval = 'minute'
        @duration = 60
        @start_time = init_time - (init_time.to_i % @duration)
        @end_time = @start_time + (@duration-1)
      elsif ['h', 'hh',  'hour', 'hours'].include? interval
        @interval = 'hour'
        @duration = 60*60
        @start_time = init_time - (init_time.to_i % @duration)
        @end_time = @start_time + (@duration-1)
      elsif ['d', 'dd',  'day', 'days'].include? interval
        @interval = 'day'
        @duration = 60*60*24
        @start_time = Time.mktime( init_time.year, init_time.month, init_time.day)
        @end_time = @start_time + (@duration-1)
      elsif ['w', 'ww',  'week', 'weeks'].include? interval 
        @interval = 'week'
        @duration = 60*60*24*7
        day = Time.mktime( init_time.year, init_time.month, init_time.day)
        @start_time = day - (60*60*24*day.wday)
        @end_time = @start_time + (@duration-1)
      elsif ['m', 'mm',  'month', 'months'].include? interval 
        @interval = 'month'
        @start_time = Time.mktime( init_time.year, init_time.month)
        if @start_time.month<12
          @end_time = Time.mktime( @start_time.year, @start_time.month+1)-1
        else
          @end_time = Time.mktime( @start_time.year+1, 1)-1
        end
        @duration = @end_time-@start_time+1
      elsif ['y', 'yyyy', 'yy', 'year', 'years'].include? interval 
        @interval = 'year'
        @start_time = Time.mktime( init_time.year)
        @end_time = Time.mktime( init_time.year+1)-1      
        @duration = @end_time-@start_time+1
      end  
    rescue StandardError => e
      raise Timeslicer::TSError.new(e)
    end

    def next
      Timeslicer::TimeInterval.new(@end_time+1, @interval)
    rescue StandardError => e
      raise Timeslicer::TSError.new(e)
    end

    def previous
      Timeslicer::TimeInterval.new(@end_time-duration, @interval)
    rescue StandardError => e
      raise Timeslicer::TSError.new(e)
    end
  
    def sum
      acc = 0
      @points.inject{|sum, p| sum.to_f + p.value.to_f}.to_f
    rescue StandardError => e
      raise Timeslicer::TSError.new(e)
    end

    def contains?(target_time)
      compare(target_time)==0
    rescue StandardError => e
      raise Timeslicer::TSError.new(e)
    end  

    def compare(compare_time)
      if compare_time < @start_time 
        -1
      elsif compare_time > @end_time
        1
      else
        0
      end
    rescue StandardError => e
      raise Timeslicer::TSError.new(e)
    end  

    def to_json(*a)
      {
        'start_time' => @start_time, 
        'end_time' => @end_time, 
        'duration' => @duration, 
        'points' => @points 
      }.to_json(*a)
    end

  end


end