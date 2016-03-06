import UnityEngine

class PostWEB (MonoBehaviour, ISaveLoadGame):
	
	//final STANDARD_URL as string = "http://85.8.6.204/game/index.php"
	//"http://54.217.213.92/game.com/index.php"//"http://localhost/game/index.php"
	//"http://mobilewebservicewars.apphb.com:80/"
	//"http://localhost:49341/Index" 
	//final STANDARD_URL as string = "http://localhost/game/index.php"
	final STANDARD_URL as string = "http://mobilewebservicewars.apphb.com:80/"//"http://localhost/game/index.php" //"http://mobilewebservicewars.apphb.com:80/" //
	//final STANDARD_URL as string = "http://54.217.213.92/game.com/index.php" 
	
	_gameState as GameState
	
	def Awake():
		_gameState = gameObject.GetComponent[of GameState]()
		assert _gameState != null
		
	def GameID() as int:
		return _gameState.GameID
		//return _gameState.GameID
		
	def DeleteGame(id as int):
		SendDataStandard("ClearGame",id,{},null)
	
	def SaveGame():
		//SendDataStandard("ClearGame",GameID(),{},null)
		//WaitForSeconds (1);
		gameState = GameObject.Find("GameRules").GetComponent[of GameState]()
		assert gameState != null
		//SendDataStandard("InsertGame",GameID(), constructTypeHash(gameState),null)
		
		hashToString = def(hash as Boo.Lang.Hash) as string:
			returnString = ""
			for pair in hash:
				returnString += pair.Key+":"+pair.Value+";" 
			return returnString
		
		loopThroughTypes = def(searchType as System.Type, command as string) as string:
			allOfTheTypes = GameObject.FindObjectsOfType(searchType)
			//print(len(allOfTheTypes))
			allTypesString as string = ""
			typeString as string = searchType.ToString()
			//print(typeString)
			for currentGameObject in allOfTheTypes:
				continue if searchType is TroopClass and currentGameObject.GetType() == LogiTroop
				//print(currentGameObject)
				//print(currentGameObject.GetType())
				//typeScript as MonoBehaviour = currentGameObject.GetComponent(typeString as string)
				sendHash = constructTypeHash(currentGameObject )
				allTypesString += "Command:"+command+";"+hashToString(sendHash) +"|"

			return allTypesString
			
		//construct holder hash
		
		types = [[PlayerScript,"InsertPlayer"], [TroopClass,"InsertTroop"],[LogiTroop,"InsertSupplyTroop"], [FactoryScript,"InsertFactory"], 
		[OilfieldScript,"InsertOilfield"], [CentralWarehouseScript,"InsertCentralWarehouse"]]
		
		allTypesString = ""
		// loop through all types 
		for index as int in range(len(types)):
			type1 as Type = (types[index] as List)[0]
			command = (types[index] as List)[1]
			// add the hash to the holder
			allTypesString += loopThroughTypes(type1,command)
		
		allTypesString = allTypesString.Substring(0,allTypesString.Length-1)
		SaveGameHash as Boo.Lang.Hash = {"gameEntitys" : allTypesString, "game":hashToString(constructTypeHash(gameState))}
		// SendData with save game
		SendDataStandard("SaveGame",GameID(), SaveGameHash,null)
		/*
		for player in (GameObject.FindObjectsOfType(PlayerScript) as (PlayerScript)):
			typeScript = player.GetComponent[of PlayerScript]()
			SendDataStandard("InsertPlayer",GameID(), constructTypeHash(typeScript),null)
			
		for currentGameObject in (GameObject.FindObjectsOfType(TroopClass) as (TroopClass)):
			typeScript = currentGameObject.GetComponent[of TroopClass]()
			sendHash = constructTypeHash(typeScript )
			if( Type.GetType(sendHash["Type"] as string) is LogiTroop ):
				SendDataStandard("InsertSupplyTroop",GameID(),sendHash,null)
			else:
				SendDataStandard("InsertTroop",GameID(),sendHash,null)
		for currentGameObject in (GameObject.FindObjectsOfType(FactoryScript) as (FactoryScript)):
			typeScript = currentGameObject.GetComponent[of FactoryScript]()
			SendDataStandard("InsertFactory",GameID(), constructTypeHash(typeScript),null)
		for currentGameObject in (GameObject.FindObjectsOfType(OilfieldScript) as (OilfieldScript)):
			typeScript = currentGameObject.GetComponent[of OilfieldScript]()
			SendDataStandard("InsertOilfield",GameID(), constructTypeHash(typeScript),null)
		for currentGameObject in (GameObject.FindObjectsOfType(CentralWarehouseScript) as (CentralWarehouseScript)):
			typeScript = currentGameObject.GetComponent[of CentralWarehouseScript]()
			SendDataStandard("InsertCentralWarehouse",GameID(),constructTypeHash(typeScript),null)
			
			*/
			
	def constructTypeHash(typeScript as INormalForm) as Boo.Lang.Hash:
			//typeScript = currentGameObject.GetComponent[of type]()
			sendHash = {}
			normalForm = typeScript.ProduceNormalForm()
			LibraryScript.ExtendHash(sendHash, normalForm.propertyInfo)
			LibraryScript.ExtendHash(sendHash, normalForm.metaInfo)
			//LibraryScript.ExtendHash(sendHash, {"MapID": 0});
			sendHash["Type"] = normalForm.type
			return sendHash

/*
	def ParseValue(parseValue):
		number as int
		result as bool = Int32.TryParse(field.Value.ToString(), number);
		if field.Value isa bool:
			return number
		elif (false == result):
			form.AddField( field.Key, field.Value.ToString() as string )
		else:
			form.AddField( field.Key, number )
		*/
	def SendDataStandard(command as string,gameID as int, dataToTransmit as Boo.Lang.Hash, callback as callable):
		SendData(command,gameID,dataToTransmit,STANDARD_URL, callback)
				
	def SendData(command as string,gameID as int, dataToTransmit as Boo.Lang.Hash, url as string, callback as callable):
		//url as string = "http://localhost/hi/index.php";

		form as WWWForm = WWWForm();
		form.AddField("Command", command)
		form.AddField("GameID", gameID)
		print(command)
		print(dataToTransmit)
		for field in dataToTransmit as Boo.Lang.Hash:
			//nt32.TryParse(String, Int32)// - http://msdn.microsoft.com/en-us/library/f02979c7.aspx
			number as int
			result as bool = Int32.TryParse(field.Value.ToString(), number);
			if field.Value isa bool:
				number = field.Value
				form.AddField( field.Key, number )
				print(field.Key +" : " + number)
			elif (false == result):
    			form.AddField( field.Key, field.Value.ToString() as string )
    			print(field.Key + " : " + field.Value.ToString())
    		else:
				form.AddField( field.Key, number )
				print(field.Key + " : " + number)
		//form.AddField("var1", "value1");
		//form.AddField("var2", "value2");
		www as WWW = WWW(url, form);
		StartCoroutine(WaitForRequest(www,callback));
		
		
		
	def LoadGame():
		callback = def(jsonString as string ):
			for currentGameObject in (GameObject.FindObjectsOfType(TroopClass) as (TroopClass)):
				Destroy(currentGameObject.gameObject)
			for currentGameObject in (GameObject.FindObjectsOfType(FactoryScript) as (FactoryScript)):
				Destroy(currentGameObject.gameObject)
			for currentGameObject in (GameObject.FindObjectsOfType(OilfieldScript) as (OilfieldScript)):
				Destroy(currentGameObject.gameObject)
			for currentGameObject in (GameObject.FindObjectsOfType(CentralWarehouseScript) as (CentralWarehouseScript)):
				Destroy(currentGameObject.gameObject)
				
			
			for hash as Boo.Lang.Hash in ReadJSON(jsonString):
				if( Type.GetType(hash["Type"] as string) is LogiTroop ):
					LogiTroop.CreateUnit(hash)
				elif( Type.GetType(hash["Type"] as string) is BuildingScript ):
					BuildingScript.CreateUnit(hash)
				elif( Type.GetType(hash["Type"] as string) is GameState ):
					GameState.CreateUnit(hash)
				elif( Type.GetType(hash["Type"] as string) is FactoryScript ):
					BuildingScript.CreateUnit(hash)
				elif( Type.GetType(hash["Type"] as string) is OilfieldScript ):
					BuildingScript.CreateUnit(hash)
				elif( Type.GetType(hash["Type"] as string) is CentralWarehouseScript ):
					BuildingScript.CreateUnit(hash)
				elif( Type.GetType(hash["Type"] as string) is PlayerScript ):
					PlayerScript.CreateUnit(hash)
				else:
					TroopClass.CreateUnit(hash)
			gameObject.GetComponent[of GameState]().LevelIsLoaded = true
		SendDataStandard("LoadGame",GameID(),{},callback)


	static def ReadJSON(jsonString as string):
		troops = @/}/.Split(jsonString) //split on whitespace (could use \s)
		list = []
		return [] if not jsonString.StartsWith("[")
		for troop in troops:
			troop = @/{/.Replace(troop, "")
			fields = @/,/.Split(troop)
			hash = {}
			for field in fields:
				pair = @/:/.Split(field)
				continue if pair == null or len(pair) == 1
				key as string = @/[",\\\]\[]+/.Replace(pair[0], "")
				//key.Trim((Char.Parse(' '),))
				//value1 as string = @/"\\\]\[ /.Escape(pair[1])
				value1 as string = @/[,"\\\]\[]+/.Replace(pair[1], "")
				//value1Len = value1.Length
				//value1.Trim((Char.Parse(' '),))
				
				number as int
				result as bool = Int32.TryParse(value1, number);
				if (false == result):
    				hash[key] = value1
    			else:
					hash[key] = number
			list.Add(hash) unless len(hash) == 0
		return list
		

	def WaitForRequest(www as WWW, callback as callable) as System.Collections.IEnumerator:

		yield  www
		
		

		// check for errors
		if (www.error == null):
			print(www.data)
			Debug.Log("WWW Ok!: " + www.data + "\n");
		else:
			Debug.Log("WWW Error: "+ www.error);
			Debug.Log("WWW Ok!: " + www.data + "\n");
			
		if callback != null:
			callback(www.data)
   
	static def FindWebScript() as PostWEB:
		gameRules = GameObject.Find('GameRules')
		assert gameRules != null
		this = gameRules.GetComponent[of PostWEB]()
		return this
        

