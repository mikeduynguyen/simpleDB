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