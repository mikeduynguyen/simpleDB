# simpleDB 
Simple IMDB written in Ruby by Mike Nguyen (mikeduynguyen@gmail.com)

## Commands:

`SET <name> <value>`  
	set __value__ with key __name__  
`GET <name>`  
	get __value__ with key __name__  
`UNSET <name>`  
	remove key __name__  
`NUMEQUALTO <value>`  
	count number of occurences for a __value__  
`BEGIN`  
	open a transaction block  
`COMMIT`  
	permanently write changes and close all open transaction blocks  
`ROLLBACK`  
	undo all changes in the latest open transaction block  
`END`  
	exit

## Try it out!
After cloning the repo, cd to the folder and run `ruby main.rb`