# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)  
require "timeslicer/version"
require "timeslicer/ts_error"
require "timeslicer/time_point"
require "timeslicer/time_interval"
require "timeslicer"

Gem::Specification.new do |s|
  s.name        = "timeslicer"
  s.version     = Timeslicer::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jason Douglas"]
  s.email       = ["jason.douglas@trimeego.com"]
  s.homepage    = "http://rubygems.org/gems/timeslicer"
  s.summary     = %q{Slices up a time line...and can still cut through a tin can}
  s.description = %q{Timeslicer will take a span of time, accept time point with values and then slice it into durations (days, weeks, months, etc.), while aggregating the points accross the durations.}
  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "timeslicer"

  s.add_development_dependency "bundler", ">= 1.0.0"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
