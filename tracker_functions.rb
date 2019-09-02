require 'fileutils'
require 'tempfile'
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

		unless Dir.exist?("./setup/")
			system "mkdir setup"
		end
	end

	def startup
		system("git pull --quiet")
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

	def parse_output(input)
		input.split(" ")[1..-1].join(" ").to_s
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
			elsif parse(input) == "todo" #|| parse(input) == "test"
				open(todo_file, "a+") do |file|
					file << parse_output(input) + "\n"
				end
				puts "logged \"#{parse_output(input)}\" in today's todo_file."
				todo_number_lines
				print prompt
			elsif parse(input) == "done"
				line_number = parse_output(input)
				if input.split(" ").size == 2 && is_number?(line_number)
					todo_done(line_number)
				else
					puts "That's not a valid command.  To mark a todo as done, just type 'done' and then the number of the todo item."
				end	
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

	def is_number?(line_number)
		line_number = line_number.to_s unless line_number.is_a? String
 		/\A[+-]?\d+(\.[\d]+)?\z/.match(line_number)
		# https://medium.com/launch-school/number-validation-with-regex-ruby-393954e46797
	end

	def todo_number_lines
		temp_file = Tempfile.new('todo_temp.txt')
		File.open(todo_file, 'r') do |f|
			n = 1
			f.each_line{|line|
				if is_number?(parse(line).gsub(":",""))
					line = line.split(" ")[1..-1].join(" ")
					temp_file.puts line.prepend("#{n}: ")
				else
					temp_file.puts line.prepend("#{n}: ")
				end 
				n += 1
			}
		end
		temp_file.close
		FileUtils.mv(temp_file.path, todo_file)
	end

	def todo_done(line_number)
		ln = line_number.to_i
		lc = `wc -l "#{todo_file}"`.strip.split(" ")[0].to_i
		lna = ln - 1
		lnb = line_number.to_s + ":"
		puts lc
		if ln > lc
			output = "You don't have that many todo's, champ."
		else
			content = File.open(todo_file).readlines[lna].split(" ")[1..-1].join(" ")
			open(today_file, "a+") do |f|
				f << "#{current_time}" + " #{content}" + "\n"
			end
			output = "logged \"#{content}\" from today's todo_file in #{current_date}.txt"
			open(todo_file, 'r') do |f|
				open('temp_todo_file.txt', 'w') do |f2|
					f.each_line do |line|
						f2.write(line) unless parse(line) == lnb
					end
				end
			end
			FileUtils.mv('temp_todo_file.txt',todo_file)
			todo_number_lines
		end
		puts output
		# output = "error"
		# line_count = `wc -l "#{todo_file}"`.strip.split(" ")[0].to_i
		# ln = line_number.to_i
		# if ln > line_count
		# 	output = "You don't have that many todo items!"
		# else
		# 	File.open(todo_file, 'r') do |f|
		# 		n = 0
		# 		f.each_line{|line|
		# 			until n = ln
		# 				output = line
		# 			else
		# 				n += 1
		# 			end
		# 		}
		# 	end
		# end
		# puts output
	end

	def shutdown
		puts "Attempting to shut down gracefully and save your work."
		if File.exist?(todo_file)
			system("git add #{todo_file}")
			system('git commit -m "update"')
		end
		# if File.exist?(today_file)
			system("git add #{today_file}")
			system('git commit -m "update"')
		# end
		system("git push")
	end

end