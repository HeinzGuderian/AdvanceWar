require 'net/http'
require 'uri'
require 'rubygems'
require 'json'

=begin
	Script to cahnge start entitys on maps
	You can change display mode by chanign display functions, see further down.
	NOT IMPLEMENTED: An manipulation of "Player" entitys.
	The default hashes here under are used as templates, modify them and restart the script to modify insert values.
	-1 means int value, -2 means string value.
	The row that that starts the script is the botton row "Menu(commands)", follow this if you want to modify teh code

=end

$troop_class_hash= {
	'MapID' => -1,
	'Health' => -1,
	'CombatInitiative' => -1,
	'Spotted' => -1,
	'Entrenched' => -1, 
	'Initiative' => -1,
	'Ammo' => -1,
	'Petrol' => -1,
	'ActionPoints' => -1,
	'IsMoving' => -1,
	'PositionX' => -1,
	'PositionY' => -1,
	'PositionZ' => 0,
	'Team' => -1,
	'Name' => -1,
	'Type' => -1,
}

$troop_class_default_hash= {
	'MapID' => -1,
	'Health' => 100,
	'CombatInitiative'  => 2,
	'Spotted' => 0,
	'Entrenched' => 0, 
	'Initiative' => 2,
	'Ammo' => 100,
	'Petrol' => 100,
	'ActionPoints' => 100,
	'IsMoving' => 0,
	'PositionX' => -1,
	'PositionY' => -1,
	'PositionZ' => 0,
	'Team' => -2,
	'Name' => "aaa",
	'Type' => -2
}

$central_warehouse_default_hash= {
	'MapID' => -1,
	'SupplyPetrol' => 1000,
	'SupplyAmmo'  => 1000,
	'VictoryResources' => 0,
	'LoadWeight' => 2000, 
	'MaxWeight' => 10000,
	'PositionX' => -1,
	'PositionY' => -1,
	'PositionZ' => 0,
	'Team' => -2,
	'Name' => "aaa",
	'Type' => -2
}

$factory_default_hash= {
	'MapID' => -1,
	'PositionX' => -1,
	'PositionY' => -1,
	'PositionZ' => 0,
	'Team' => -2,
	'Name' => "aaa",
	'Type' => -2
}

$central_warehouse_default_hash= {
	'MapID' => -1,
	'SupplyPetrol' => 1000,
	'SupplyAmmo'  => 1000,
	'VictoryResources' => 0,
	'LoadWeight' => 2000, 
	'MaxWeight' => 10000,
	'PositionX' => -1,
	'PositionY' => -1,
	'PositionZ' => 0,
	'Team' => -2,
	'Name' => "aaa",
	'Type' => -2
}

$oilfield_default_hash= {
	'MapID' => -1,
	'ProducedVRPerTurn' => 5,
	'CurrentVRHold'  => 0,
	'MaxVRHold' => 100,
	'PositionX' => -1,
	'PositionY' => -1,
	'PositionZ' => 0,
	'Team' => -2,
	'Name' => "aaa",
	'Type' => -2
}



def jsonEmpty(jsonString)
	return jsonString.length < 3
end

def emptyString()
	return "Return was empty"
end

# 3 Print functions that are used in display functions, you can change between these in the display
def allFormatHeight (jsonString)
	if true == jsonEmpty(jsonString) then
		puts emptyString()
		return 
	end
	puts JSON.pretty_generate(jsonString)
end
def allFormatSemiHeight (jsonString)
	if true == jsonEmpty(jsonString) then
		puts emptyString()
		return
	end
	jsonString.each do |hash|
		puts "\n"
		hash.each {|(key,value)| print key+": "+value.to_s()+" , "}
		puts "\n"
	end
end

def allFormatSemiHeightOnlyPos (jsonString)
	if true == jsonEmpty(jsonString) then
		puts emptyString()
		return 
	end
	jsonString.each do |hash|
		print "\n ( "
		hash.each {|(key,value)| if key=="PositionX" or key=="PositionY" or key=="PositionZ" or key=="Type" or key=="Team" then print key+": "+value.to_s()+" , " end}
		puts " )\n"
	end
end
	
	
def SendCommand(parameters)
	#returnString = Net::HTTP.post_form( URI.parse('http://85.8.7.133/game/index.php'), parameters).body
	returnString = Net::HTTP.post_form( URI.parse('http://localhost/game/index.php'), parameters).body
	#puts returnString
	if jsonEmpty(returnString) then
		return ""
	else
		return  JSON.parse( returnString )
	end
end

def LoadMapWrapper()
	puts "write ID for map"
	id = Integer(gets.chomp)
	LoadMap(id)
end

def LoadMap(id)
	defaultOutputFunction = method(:allFormatSemiHeightOnlyPos)
	params = {'Command'=> 'LoadGame', 'GameID'=> id}
	defaultOutputFunction.call(SendCommand(params))
	
end

def DisplayPlayerOnMap()
	return
end

def DisplayEntity(params)
	defaultOutputFunction = method(:allFormatSemiHeightOnlyPos) # Here you can change from :allFormatSemiHeightOnlyPos to :allFormatHeight or :allFormatSemiHeight
	defaultOutputFunction.call(SendCommand(params))
end


def DisplayWrapper()
	
	commands = [['DisplayPlayerOnMap', method(:DisplayPlayerOnMap)],['DisplayTroopOnMap', method(:DisplayEntity)],['DisplayFactoryOnMap', method(:DisplayEntity)],
		['DisplayOilfieldOnMap', method(:DisplayEntity)],['DisplayCentralWarehouseOnMap', method(:DisplayEntity)]]
	quitCommandNumber = commands.length	
	choice = PrintOptionsAndReturnChoice(commands)
	
	if choice == quitCommandNumber then
		return
	end
	puts "Input MapID: "
	mapID = Integer(gets.chomp)  
	commands[choice][1].call({'Command'=> commands[choice][0], 'MapID' => mapID})
end

def DeleteWrapper()
	commands = [['DeletePlayerOnMap', method(:DisplayPlayerOnMap)],['DeleteTroopOnMap', method(:DisplayEntity)],['DeleteFactoryOnMap', method(:DisplayEntity)],
		['DeleteOilfieldOnMap', method(:DisplayEntity)],['DeleteCentralWarehouseOnMap', method(:DisplayEntity)]]
		
	choice = PrintOptionsAndReturnChoice(commands)
	puts "Input Position X: "
	xCommand = Integer(gets.chomp) 
	puts "Input Position Y: "
	yCommand = Integer(gets.chomp) 
	puts "Input MapID: "
	mapID = Integer(gets.chomp) 
	posParams = {'PositionX' => xCommand, 'PositionY' => xCommand, 'MapID'=> mapID}
	SendCommand({'Command'=> commands[choice][0]}.merge(posParams))
end

def InsertWrapper()
	commands = [['InsertPlayerOnMap', {}],['InsertTroopOnMap', $troop_class_default_hash],['InsertFactoryOnMap', $factory_default_hash],
		['InsertOilfieldOnMap', $oilfield_default_hash],['InsertCentralWarehouseOnMap', $central_warehouse_default_hash]]
		
	choice = PrintOptionsAndReturnChoice(commands)
		
	newHash = commands[choice][1].clone
	newHash.each do |key, value|
		if value==-1 then
			puts key+" input value: " 
			newValue = Integer(gets.chomp)
			newHash[key]=newValue
		elsif value==-2 then
			puts key+" input value: " 
			newValue = gets.chomp
			newHash[key]= newValue
		end
	end
	puts newHash
	#choice = PrintOptionsAndReturnChoice(commands)
	SendCommand({'Command'=> commands[choice][0]}.merge(newHash))
end

def PrintOptionsAndReturnChoice(commands)
	quitCommandNumber = commands.length
	commands.each_with_index  do |(commandString, storedFunction), index| 
		# loop through and print
		puts index.to_s() + "."+commandString
	end
	puts quitCommandNumber.to_s()+ ".Quit"
	# get input and convert to int
	userCommand = Integer(gets.chomp) 
	return userCommand
end

def Menu(commands)
	# quit command last
	quitCommandNumber = commands.length
	begin
		# Prints menu options
		userCommand = PrintOptionsAndReturnChoice(commands)
		if userCommand == quitCommandNumber then
			break
		end
		commands[userCommand][1].call()
	end while true

end
=begin
postData = Net::HTTP.post_form(URI.parse('http://85.8.7.133/game/index.php'), 
                               {'Command'=> 'LoadGame', 'GameID'=> 5})
                               
jsonFormattedString =  JSON.parse(postData.body)
puts jsonFormattedString
=end

#List that stores command strings and their functions
commands = [ ["LoadMap", method(:LoadMapWrapper)], ["Display", method(:DisplayWrapper)], ["Insert", method(:InsertWrapper)], ["Delete", method(:DeleteWrapper)]]
Menu(commands)
