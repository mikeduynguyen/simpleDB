#-------- Database class --------#
class Database
	# Constants
	## Command definitions
	COMMAND_SET = 'SET'
	COMMAND_GET = 'GET'
	COMMAND_UNSET = 'UNSET'
	COMMAND_NUMEQUALTO = 'NUMEQUALTO'
	COMMAND_BEGIN = 'BEGIN'
	COMMAND_ROLLBACK = 'ROLLBACK'
	COMMAND_COMMIT = 'COMMIT'
	COMMAND_END = 'END'
	## No transaction message
	NO_TRANSACTION = 'NO TRANSACTION'
	## NULL
	NULL_VALUE = '> NULL'
	## Output indicator
	OUTPUT_INDICATOR = '> '
	
	def initialize
		# Hash to store data
		@data = {}

		# Transaction stack (LIFO)
		@transaction_stack = []
	end

	# Execute command
	# args[0]: command
	# args[1]: name
	# args[2]: value
	def execute(args)
		# Switch command
		case args[0]

		when COMMAND_SET
			# Check if name & value are nil
			if args.size == 3
				# Check if in a transaction block
				if @transaction_stack.size > 0
					if @data.key?(args[1])
						# If existing data is being
						# overwritten save its current state
						@transaction_stack.last.save_data_state(args[1], @data[args[1]])
					else
						# else keep a record that 
						# it's a new data entry
						@transaction_stack.last.insert_new_key(args[1])
					end		
				end
						
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
				# Check if in a transaction block
				if @transaction_stack.size > 0
					if @data.key?(args[1])
						# If existing data is being
						# overwritten save its current state
						@transaction_stack.last.save_data_state(args[1], @data[args[1]])					
					end		
				end	

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

		when COMMAND_BEGIN
			# Create new transaction and
			# push to stack
			@transaction_stack.push(Transaction.new)

		when COMMAND_COMMIT
			if @transaction_stack.size == 0
				puts OUTPUT_INDICATOR + NO_TRANSACTION
			else
				# Commit by clearing the transaction 
				# stack, doing this will erase all the
				# saved data. Hence the current data
				# changes become permanent
				@transaction_stack.clear
			end

		when COMMAND_ROLLBACK
			if @transaction_stack.size == 0
				puts OUTPUT_INDICATOR + NO_TRANSACTION
			else
				# Rollback changes by writing saved data
				# from the transaction to the db data
				@transaction_stack.last.saved_data.each do |name, value|
					set(name, value)
				end
				# and delete newly created data
				@transaction_stack.last.new_data.each do |name|
					unset(name)
				end
				@transaction_stack.pop
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
	def set(name, value)
		@data[name] = value
	end

	def get(name)
		unless @data[name].nil?
			puts OUTPUT_INDICATOR + @data[name]
		else
			puts NULL_VALUE
		end		
	end

	def unset(name)
		@data[name] = nil
	end

	# Count number of occurrences for a value
	def num_equal_to(value)
		puts OUTPUT_INDICATOR + @data.values.count(value).to_s
	end

end

#-------- Database transaction class --------#
class Transaction	
	attr_reader :saved_data
	attr_reader :new_data 

	def initialize
		# @saved_data: hash for storing current 
		# version of data for each write 
		# command
		@saved_data = {}

		# @new_data: hash for storing new data
		# keys created in the transaction
		@new_data = []
	end

	def save_data_state(name, value)
		# Only save current state of
		# data point, if data is already
		# saved, do nothing.
		if @saved_data[name].nil?
			@saved_data[name] = value
		end
	end

	def insert_new_key(name)
		@new_data << name
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