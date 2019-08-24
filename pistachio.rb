require 'fileutils'
require 'date'
require './animations'
require './tracker_functions'

class Tracker

	def current_date
		DateTime.now.strftime("%-m-%-d-%y")
	end

	def current_time
		DateTime.now.strftime("%R")
	end

	def today_file
		"./stash/#{current_date}.txt"
	end

	def run
		prompt = "~> "
		print prompt
		while (input = gets.chomp)
			break if input == "exit"
				if input == "today"
					# Animation.new.test_animation
					system("cat #{today_file}")
				# case input == "diet"
				  	# TrackerFunction.new.diet
				else
					open(today_file, "a+") { |f|
						f << "#{current_time}" + " " + input + "\n"
					}
					puts "logged \"#{input}\" at #{current_time} in #{current_date}.txt"
				end
			print prompt
		end
	end

end

Animation.new.startup_animation
Tracker.new.run
Animation.new.shutdown_animation