#-------- Database class --------#
class Database
	# Constants
	## Command definitions
	COMMAND_SET = 'SET'
	COMMAND_GET = 'GET'
	COMMAND_UNSET = 'UNSET'
	COMMAND_NUMEQUALTO = 'NUMEQUALTO'
	COMMAND_END = 'END'
	## NULL
	NULL_VALUE = '> NULL'
	## Output indicator
	OUTPUT_INDICATOR = '> '
	
	def initialize
		# Init default transaction for the db, 
		# which always lives at the bottom of the
		# stack permanenly.
		@default_transaction = Transaction.new

		# Transaction stack (LIFO)
		@transaction_stack = Stack.new
		@transaction_stack.push(@default_transaction)

		@data = @default_transaction.data
		@current_transaction = nil
	end

	# Execute command
	# args[0]: command
	# args[1]: name
	# args[2]: value
	def execute(args)
		case args[0]
		when COMMAND_SET
			# Check if name & value are nil
			if args.size == 3
				set(args[1], args[2])
			else
				invalid_command
			end
		when COMMAND_GET
			# Check if name is nil
			if args.size == 2
				get(args[1]) 
			else
				invalid_command
			end
		when COMMAND_UNSET
			# Check if name is nil
			if args.size == 2
				unset(args[1])
			else
				invalid_command
			end
		when COMMAND_NUMEQUALTO
			# Check if name is nil
			if args.size == 2
				num_equal_to(args[1])
			else
				invalid_command
			end
		when COMMAND_END
			exit
		else
			invalid_command
		end
	end

	# Display error when command is invalid
	def invalid_command
		# Invalid command message here
		# puts 'Invalid command!'
	end

	private
	def set(key, value)
		@data[key] = value
	end

	def get(key)
		unless @data[key].nil?
			puts OUTPUT_INDICATOR + @data[key]
		else
			puts NULL_VALUE
		end		
	end

	def unset(key)
		@data[key] = nil
	end

	# Count number of occurences for a value
	def num_equal_to(value)
		puts OUTPUT_INDICATOR + @data.values.count(value).to_s
	end
end

#-------- Database transaction class --------#
class Transaction	
	def initialize
		# @data: hash for storing data
		@data = {}
	end
end

#-------- Simple stack implementation --------#
def Stack
	def initialize
		@stack = []
	end

	def push(item)
		@stack.push(item)
	end

	def pop
		# Prevent the default transaction
		# to be popped
		unless @stack.size == 1
			@stack.pop
		end
	end

	def get_last_item
		@stack.last 
	end
end

#-------- Main --------#
# Init an instance of the Database class
@database = Database.new

# Get commands from STDIN
while input = $stdin.gets
	puts input
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