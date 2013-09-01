import UnityEngine

partial public class GameState (INormalForm):
	
	public static GameID as int = 3 
	public static MapID as int = 0
	public static PlayerID as int = 1
	public static AccountName as string = ""
	public static Player1AccountName as string = ""
	public static Player2AccountName as string = ""
	public static DeleteGame = false
	public static LocalGame = false
	public static ResetGame = false
	
	public _player1HaveWon as bool = false
	public _player2HaveWon as bool = false
	public _player1HaveConcede as bool = false
	public _player2HaveConcede as bool = false
	
	private _baseLevel as int = 5
	private _level as int = 0
	
	public Player1HaveWon as bool:
		get:
			return _player1HaveWon
		set:
			_player1HaveWon = value
			
	public Player2HaveWon as bool:
		get:
			return _player2HaveWon
		set:
			_player2HaveWon = value
	
	public Player1HaveConcede as bool:
		get:
			return _player1HaveConcede
		set:
			_player1HaveConcede = value
			
	public Player2HaveConcede as bool:
		get:
			return _player2HaveConcede
		set:
			_player2HaveConcede = value
	

	[SerializeField]
	_gameName as string = "game1"
	GameName as string:
		get:
			return _gameName
		set:
			_gameName = value
	
	PropertyInfo as Boo.Lang.Hash:
		get:
			hash = {}
			//hash["GameName"] = GameName
			//if WhosTurn == TeamScript.PlayerNumberEnum.player1:
			//hash["WhosTurn"] = 0
			if _haveWon == true and _winningPlayer == TeamScript.PlayerNumberEnum.player1:
				hash["Player1HaveWon"] = true
			else:
				hash["Player1HaveWon"] = Player1HaveWon
			//elif WhosTurn == TeamScript.PlayerNumberEnum.player2:
			//hash["WhosTurn"] = 1
			if _haveWon == true and _winningPlayer == TeamScript.PlayerNumberEnum.player2:
				hash["Player2HaveWon"] = true
			else:
				hash["Player2HaveWon"] = Player2HaveWon
			//else:
			//	raise "Whos turn was not player1 or player2"
			//hash["WhosTurn"] = WhosTurn
			if WhosTurn == TeamScript.PlayerNumberEnum.player1:
				hash["WhosTurn"] = 0
			elif WhosTurn == TeamScript.PlayerNumberEnum.player2:
				hash["WhosTurn"] = 1
			else:
				raise "whos turn fault"
			hash["TurnNumber"] = TurnNumber
			hash["Player1HaveConceded"] = Player1HaveConcede
			hash["Player2HaveConceded"] = Player2HaveConcede
			//hash["MapID"] = MapID
			//hash["AccountName"] = AccountName
			return hash

	def ProduceNormalForm() as SaveLoadMultiplayerAspectClass.SaveLoadMultiplayerInfoStruct:
		infoStruct = SaveLoadMultiplayerAspectClass.SaveLoadMultiplayerInfoStruct(propertyInfo: {}, metaInfo: {}, type: "")
		infoStruct.propertyInfo = PropertyInfo
		//infoStruct.propertyInfo["VictoryResources"] = VictoryResources
		//infoStruct.propertyInfo["UniversalResources"] = UniversalResources
		infoStruct.metaInfo["TurnHasEnded"] =  true
		infoStruct.metaInfo["MapID"] =  MapID
		infoStruct.metaInfo["Player1"] = Player1AccountName
		infoStruct.metaInfo["Player2"] = Player2AccountName
		
		infoStruct.type = self.GetType().ToString()
		return infoStruct
		
	static def CreateUnit(infoHash as Boo.Lang.Hash):
		
		normalStruct = SaveLoadMultiplayerAspectClass.ProduceTroopNormalStruct(infoHash)
		/*
		ab = Type.GetType(normalStruct.type as string)
		ba = ResourcesLoadTable[Type.GetType(normalStruct.type as string)]
		cd = normalStruct.metaInfo["Team"] as string
		dc = TeamScript.StringToPlayerNumber( normalStruct.metaInfo["Team"] as string )
		*/
		
		gameState as GameState = GameObject.Find("GameRules").GetComponent[of GameState]()
		assert gameState != null
		gameState.LoadFromNormalForm(normalStruct)
		gameState.MapID = infoHash["MapID"]
		gameState.Player1AccountName = infoHash["Player1"]
		gameState.Player2AccountName = infoHash["Player2"]
		//gameState.AccountName = infoHash["AccountName"]
		
		//newGameObject as GameObject = Instantiate(UnityEngine.Resources.Load("PlayerPreFab"), Vector3(0,0,0),  Quaternion.identity  )
		//newGOteamScript = newGameObject.GetComponent[of TeamBuildingScript]()
		//newGOteamScript.SetTeam(TeamScript.StringToPlayerNumber(infoHash["Player"]))
		
		//newGameObject.transform.rotation.x = 90 // Becouse otherwise they bug out and are turnd odd
		//newGameObject.transform.rotation = Quaternion.Euler(270, 0, 0)
		//newGameObject.GetComponent[of PlayerScript]().LoadFromNormalForm(infoHash)
		
	virtual def LoadFromNormalForm(propertyHash as Boo.Lang.Hash):
		 for pair in propertyHash: 
		 	currentProperty = self.GetType().GetProperty(pair.Key.ToString())
		 	if currentProperty != null:
		 		currentProperty.SetValue(self, pair.Value, null);
		 		
	virtual def LoadFromNormalForm(propertyStruct as SaveLoadMultiplayerAspectClass.SaveLoadMultiplayerInfoStruct):
		 for pair in propertyStruct.propertyInfo as Boo.Lang.Hash: 
		 	currentProperty = self.GetType().GetProperty(pair.Key.ToString())
		 	if currentProperty != null:
		 		// Handle bools
		 		if currentProperty.PropertyType is bool:
		 			if pair.Value == 1:
		 				currentProperty.SetValue(self, true, null);
		 			elif pair.Value == 0:
		 				currentProperty.SetValue(self, false, null);
		 			else:
		 				raise "Parse failed, should never occor"
		 		else:
		 			currentProperty.SetValue(self, pair.Value, null);
	
	
	
	SaveLoadClass as ISaveLoadGame

	def SaveGame():
		SaveLoadClass.SaveGame()
			
	def LoadGame(gameName as string):
		SaveLoadClass.LoadGame()
			
	def LoadLevel(level as int):
		Application.LoadLevel(level)
		
	def LoadLevel(level as string):
		Application.LoadLevel(level)
		
	def OnLevelWasLoaded(level as int):
		
		return if level < _baseLevel
		_level = level
		print("level "+level)
		print("_baseLevel "+_baseLevel)
		print(CurrentPlayer)
		if LocalGame == true:
			SaveLoadClass = SaveLoadGameSerialisable("test"+_level)
			CurrentPlayer = WhosTurn
			print("load game true")
		else:
			SaveLoadClass = GetPostWEB()
			for currentGameObject in (GameObject.FindObjectsOfType(TroopClass) as (TroopClass)):
				Destroy(currentGameObject.gameObject)
			for currentGameObject in (GameObject.FindObjectsOfType(FactoryScript) as (FactoryScript)):
				Destroy(currentGameObject.gameObject)
			for currentGameObject in (GameObject.FindObjectsOfType(OilfieldScript) as (OilfieldScript)):
				Destroy(currentGameObject.gameObject)
			for currentGameObject in (GameObject.FindObjectsOfType(CentralWarehouseScript) as (CentralWarehouseScript)):
				Destroy(currentGameObject.gameObject)

		Start()
		if LocalGame == true:
			if ResetGame == false:
				for currentGameObject in (GameObject.FindObjectsOfType(TroopClass) as (TroopClass)):
					Destroy(currentGameObject.gameObject)
				for currentGameObject in (GameObject.FindObjectsOfType(FactoryScript) as (FactoryScript)):
					Destroy(currentGameObject.gameObject)
				for currentGameObject in (GameObject.FindObjectsOfType(OilfieldScript) as (OilfieldScript)):
					Destroy(currentGameObject.gameObject)
				for currentGameObject in (GameObject.FindObjectsOfType(CentralWarehouseScript) as (CentralWarehouseScript)):
					Destroy(currentGameObject.gameObject)
				SaveLoadClass.LoadGame()
			else:
				SaveLoadClass.DeleteGame("test"+_level)
		else:
			SaveLoadClass.LoadGame()
			
			
		ResetGame = false
		MoveCameraToCorrectPosition()
		//LevelIsLoaded = true
		//yield WaitForSeconds(2)
			

			
		
