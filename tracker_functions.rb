require 'fileutils'
require 'date'
require './animations'


class Tracker

	def setup
		unless Dir.exist?("./stash/")
			system("mkdir stash")
		end

		unless Dir.exist?("./todo/")
			system("mkdir todo")
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

	def todo_file
		"./todo/#{current_date}.txt"
	end

	def parse(input)
		input.split(" ")[0].to_s
	end

	def run
		prompt = "~> "
		print prompt
		while (input = gets.chomp)
			if input == "exit"
				break
			elsif input == "today"
				system("cat #{today_file}")
				print prompt
			elsif input == "todos"
				system("cat #{todo_file}")
				print prompt
			elsif parse(input) == "todo"
				open(todo_file, "a+") do |file|
					file << input + "\n"
				end
				puts "logged \"#{input}\" in today's todo_file."
				print prompt
			else 
				open(today_file, "a+") do |file|
		 			file << "#{current_time}" + " " + input + "\n"
		 		end
		 		puts "logged \"#{input}\" at #{current_time} in #{current_date}.txt"
				print prompt
			end
		end
	end

end