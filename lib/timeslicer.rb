$:.push File.expand_path("../lib", __FILE__)  
require "timeslicer/version"
require "timeslicer/ts_error"
require "timeslicer/time_point"
require "timeslicer/time_interval"
require 'date'
require 'json'

module Timeslicer

  class Slicer
    attr_accessor :start_time, :end_time
    attr_reader :timepoints

    def initialize(start_time=nil, end_time=nil, timepoints=[])
      @start_time, @end_time, @timepoints = to_time(start_time), to_time(end_time), timepoints
    rescue StandardError => e
      raise Timeslicer::TSError.new(e)
    end

    def add_timepoint(*args)
      if(args.size==1&&args[0].class==TimePoint)
        tp = args[0]
      else
        tp = Timeslicer::TimePoint.new(to_time(args[0]), args[1].to_f(), args[2])
      end

      @timepoints << tp
      @start_time = tp.time if @start_time.nil? || @start_time>tp.time
      @end_time = tp.time if @end_time.nil? || @end_time<tp.time
    rescue StandardError => e
      raise Timeslicer::TSError.new(e)
    end

    def slice(interval, &block)
      #interval can be either a number or a string
      slices = []
      unless @start_time.nil?||@end_time.nil?
        slice = Timeslicer::TimeInterval.new(@start_time, interval)
        until slice.start_time > @end_time
          slices << slice
          slice = slice.next
        end
      end

      # There must be an easier way to do this
      @timepoints.each do |timepoint|
        if !block||yield(timepoint)
          plot_point_in_slices(timepoint, slices)
        end
      end

      slices

    rescue StandardError => e
      raise Timeslicer::TSError.new(e)
    end


  private 

    def plot_point_in_slices(timepoint, slices)
      unless timepoint.nil? || slices.nil?
        # try to figure out where in the sequence the value will likely be wihtout iteration.
        chucksize = (@end_time.to_i - @start_time.to_i) / slices.size
        approx_index = (timepoint.time.to_i - @start_time.to_i) / chucksize
        offset = slices[approx_index].compare(timepoint.time)
        # should work most time, but the following allows us to adjust for inconsistent durations, like months.
        # and work backward/forward 
        until offset==0 
          approx_index += offset
          offset = slices[approx_index].compare(timepoint.time)
        end
        slices[approx_index].points << timepoint
      end
    end

    def to_time(value)
      unless value.nil?
        case value.class.to_s
          when 'Time' then value
          when 'DateTime' then Time.mktime( value.year, value.month, value.day, value.hour, value.min, value.sec )
          when 'Date' then Time.mktime( value.year, value.month, value.day)
          when 'String' then 
            dt=DateTime.parse(value)
            unless dt.nil?
              Time.mktime( dt.year, dt.month, dt.day, dt.hour, dt.min, dt.sec )
            end

        end
      end
    end  

  end
end
