require 'fileutils'
require 'date'
require './animations'
require './tracker_functions'

Tracker.new.setup
Tracker.new.startup
Animation.new.startup_animation
Tracker.new.run
Tracker.new.shutdown
Animation.new.shutdown_animation