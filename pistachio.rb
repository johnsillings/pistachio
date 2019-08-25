require 'fileutils'
require 'date'
require './animations'
require './tracker_functions'

Tracker.new.setup
Animation.new.startup_animation
Tracker.new.run
Animation.new.shutdown_animation