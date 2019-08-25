require 'fileutils'
require 'date'
require './animations'


class TrackerFunction

	def diet_file
		"./stash/diet_file.txt"
	end

	def current_date
		DateTime.now.strftime("%-m-%-d-%y")
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