require 'fileutils'
require 'date'
require './animations'


class Tracker

	def setup
		unless Dir.exist?("./stash/")
			system("mkdir stash")
		end
	end

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

	def diet
		prompt = "What did you eat?"
		print prompt
		while (input = gets.chomp)
		break if input == ""
				open(diet_file, "a+") { |f|
								f << "#{current_date}" + " " + input + "\n"
				}
		end
	end

end