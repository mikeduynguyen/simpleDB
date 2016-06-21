require './database'
require './transaction'
#-------- Main --------#
# Init an instance of the Database class
@database = Database.new

# Get commands from STDIN
while input = $stdin.gets
	#puts input
	# Use chomp to remove newline from the command
	# and split it into Command, Name and Value by 
	# the a space
	args = input.chomp.split(' ')
	# Check if input is nil or valid format
	if args.size > 0
		@database.execute(args)
	else
		@database.invalid_command
	end
end