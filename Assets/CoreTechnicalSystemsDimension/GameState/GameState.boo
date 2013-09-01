import UnityEngine

//import System.Collections

partial public class GameState(MonoBehaviour):
	public static final Z_OBJECT_POSITION_VALUE as double = 0		// The GameState Z position all object should be on in the game.
	public static final Z_SCREEN_POSITION_VALUE as double = 0
	public static final Z_CAMERA_POSITION_VALUE as double = -50
	public static final TERRAIN_SPHERE_RADIUS as double = 3
	public static final TERRAIN_SIDE_DISTANCE as double = 10
	public static final DEBUG_MODE as bool = true
	public static GameStateObject as GameState
	public static final LevelStartNumber as int = 3 
	
	private _turnNumber as int = 0
	private _playerGameObjectList as List
	private _playersGameObject as GameObject
	private playerIndexCount = 0
	private _currentTurn as TeamScript.PlayerNumberEnum = TeamScript.PlayerNumberEnum.player1
	private final executeTurnString as string = "executeTurn"
	private final _playersGameObjectName as string = "Player1"
	private TeamScript as TeamScript
	
	
	
	_currentPlayerGUI as GuiScript
	_haveWon as bool = false
	_haveConceded as bool = false
	_enemyHaveConceded as bool = false
	_winningPlayer as TeamScript.PlayerNumberEnum
	_currentPlayer as TeamScript.PlayerNumberEnum
	public LevelIsLoaded = false
	
	public final Key as string =  "Death to the false emperor, and all his slaves!"
	
	public HaveWon as bool:
		get:
			return _haveWon
		set:
			_haveWon = value
			
	public HaveConceded as bool:
		get:
			return _haveConceded
		set:
			_haveConceded = value
			
	public EnemyHaveConceded as bool:
		get:
			return _enemyHaveConceded
		set:
			_enemyHaveConceded = value
	
	public TurnNumber as int:
		get:
			return _turnNumber
		set:
			_turnNumber = value
	
	public WhosTurn as TeamScript.PlayerNumberEnum:
		get:
			return _currentTurn
		set:
			_currentTurn = value
			
	public CurrentPlayer as TeamScript.PlayerNumberEnum:
		get:
			return _currentPlayer
		set:
			_currentPlayer = value

	public def NextPlayersTurn():	
		_turnNumber += 1
		
		if(_currentTurn == TeamScript.PlayerNumberEnum.player1):
			_currentTurn = TeamScript.PlayerNumberEnum.player2
			WhosTurn = TeamScript.PlayerNumberEnum.player2
			print(WhosTurn)
			print(_currentTurn)
		elif(_currentTurn == TeamScript.PlayerNumberEnum.player2):
			_currentTurn = TeamScript.PlayerNumberEnum.player1
			WhosTurn = TeamScript.PlayerNumberEnum.player1
		else:
			print("Fail in gameState NextPlayerTurn, _currentTurn is:" + _currentTurn)
			
			/*
		if(WhosTurn == TeamScript.PlayerNumberEnum.player1):
			WhosTurn = TeamScript.PlayerNumberEnum.player2
		elif(WhosTurn == TeamScript.PlayerNumberEnum.player2):
			WhosTurn = TeamScript.PlayerNumberEnum.player1
		else:
			print("Fail in gameState NextPlayerTurn, _currentTurn is:" + _currentTurn)	
			*/
	def Awake():
		DontDestroyOnLoad(transform.gameObject)
		print(GameObject.Find('GameRules') != null)
		if( len(GameObject.FindObjectsOfType( GameState ) ) > 1 ):
			Destroy(gameObject)
		GameStateObject = self
		Camera.main.transform.position.z = Z_CAMERA_POSITION_VALUE
		
		

		
		
	/**
	Returns the gamestate object by system lookup, expensive.
	*/
	public static def FindGameState() as GameState:
		return GameObject.Find('GameRules').GetComponent[of GameState]()
		
	[Property(LibraryScript)]
	_library as LibraryScript
	def Start():
		
		_playerGameObjectList = [GameObject.Find("Player1"), GameObject.Find("Player2")]
		_playersGameObject = GameObject.Find(_playersGameObjectName)
		_library = GetComponent[of LibraryScript]()
		currentPlayersGameObject = _library.FindCamera()
		_currentPlayerGUI = currentPlayersGameObject.GetComponent[of GuiScript]()
		checkInit()
		//SaveLoadClass = SaveLoadGameSerialisable(GameName)
		//SaveLoadClass = GetPostWEB()
		//SaveLoadClass.LoadGame()
		
	
	def checkInit():
		if _library==null:
			print("_library is null")
		if _playerGameObjectList==null:
			print("_playerGameObjectList is null")
			
	def getPlayersITeam() as List:
		_playerGameObjectList = [GameObject.Find("Player1"), GameObject.Find("Player2")]
		TeamArray = [ TeamScript.FindTeamScript( item) as TeamScript  for item as GameObject in _playerGameObjectList]
		assert TeamArray != null
		return TeamArray
		
	def getPlayersGameObject() as List:
		return _playerGameObjectList
		
	def FindPlayerScript(playerNumber as TeamScript.PlayerNumberEnum) as PlayerScript:
		return PlayerScript.FindPlayerScript( FindPlayerGameObject(playerNumber)) //.GetComponent[of PlayerScript]()
	
	def FindPlayerGameObject(playerNumber as TeamScript.PlayerNumberEnum) as GameObject:
		return (getPlayersITeam().Find({team as TeamScript | return (team as TeamScript).PlayerNumber == playerNumber }) as MonoBehaviour).gameObject//.GetComponent[of PlayerScript]()
		
	def FindCurrentPlayerGameObject():
		return FindPlayerGameObject(_currentTurn)
	
	def OnGUI():
		if _haveWon == true and Application.loadedLevel > LevelStartNumber-1:
			GUI.Label(Rect(300, 300, 100, 70), ""+_winningPlayer.ToString()+" Wins." )
			if GUI.Button(Rect(300, 370, 100, 70), "Exit Game."):
				//GUIContent()_currentPlayerGUI.PrintToScreen("Win")
				//_haveWon = false
				//DeleteGameHook()
				//_winningPlayer = TeamScript.PlayerNumberEnum.none
				//Application.LoadLevel("mainMenu")
				EndTurn()
					
	public def IsItCurrentPlayersTurn() as bool:
		//return TeamScript.FindTeamScript(FindCurrentPlayerGameObject()).IsOurTurn()	
		return WhosTurn == CurrentPlayer	
								
	public def CheckAndEndTurn():
		CheckIfPlayerWonAndSet()																																											
		EndTurn()
																																																																																																																										
	public def CheckIfPlayerWonAndSet():
		if false == IsItCurrentPlayersTurn():
			_haveWon = false
			LoadLevel("mainMenu")
			return
		if true == DeleteGame:
			SaveLoadClass = GetPostWEB()
			SaveLoadClass.DeleteGame(SaveLoadClass.GameID())
			_haveWon = false
			DeleteGame = false
			LoadLevel("mainMenu")
			return	
		//playerIData as IData = null
		//playerNumber as TeamScript.PlayerNumberEnum
		//for playerIVC as IVictoryCondition in [LibraryScript.GetInterfaceComponent[of IVictoryCondition](item.gameObject) for item as PlayerScript in GameObject.FindObjectsOfType(PlayerScript) ]:	
		for playerScript as PlayerScript in GameObject.FindObjectsOfType(PlayerScript):	
			playerIVC as IVictoryCondition = LibraryScript.GetInterfaceComponent[of IVictoryCondition](playerScript.gameObject)
			if true == playerIVC.CheckIfVictorious():
				_haveWon = true
			//if true == playerIVC.CheckIfHasLost():
			//	_haveWon = false
			if _haveWon == true:
				//_winningPlayer = (playerIVC as PlayerScript).gameObject.GetComponent[of TeamScript]().Player
				_winningPlayer = playerScript.gameObject.GetComponent[of TeamScript]().Player
				break
				
	public def EndTurn():
		if WhosTurn != CurrentPlayer:
			LoadLevel("mainMenu");
			return;
		// Move the camera to the place where the last player clicked end turn
		MoveCameraToCorrectPosition()
		
		
		//playerComponents as List = _library.GetInterfaceComponents[of IGameState](_playersGameObject) //
		
		allGameObjects as (UnityEngine.GameObject) =  (GameObject.FindObjectsOfType(GameObject) as (UnityEngine.GameObject))
		callFunction1 = {x as IGameState | x.EndTurnActions()}
		CallIGameState(allGameObjects, callFunction1)
		_library.FindCamera().GetComponent[of GuiScript]().EndTurnActions()
		
		NextPlayersTurn()
		if LocalGame == true:
			SaveLoadClass = SaveLoadGameSerialisable("test"+_level)
			print("save game true")
		else:
			SaveLoadClass = GetPostWEB()
		SaveLoadClass.SaveGame()
		LoadLevel("mainMenu")
		//Application.LoadLevel(0)
		/*
		
		NextPlayersTurn()
		
		callFunction2 = {x as IGameState | x.StartTurnActions()}
		CallIGameState(allGameObjects, callFunction2)
		_currentPlayerGUI.PrintToScreen(_currentTurn.ToString())
		*/
	
	def MoveCameraToCorrectPosition():
		player1Pos as GameObject
		player2Pos as GameObject
		if CurrentPlayer == TeamScript.PlayerNumberEnum.player2:
			player1Pos = FindPlayerGameObject(TeamScript.PlayerNumberEnum.player1)
			player1Pos.transform.position.x = Camera.main.transform.position.x
			player1Pos.transform.position.y = Camera.main.transform.position.y
			player2Pos = FindPlayerGameObject(TeamScript.PlayerNumberEnum.player2)
			Camera.main.transform.position.x = player2Pos.transform.position .x 
			Camera.main.transform.position.y = player2Pos.transform.position .y
			
		else:
			player2Pos = FindPlayerGameObject(TeamScript.PlayerNumberEnum.player2)
			player2Pos.transform.position .x = Camera.main.transform.position.x
			player2Pos.transform.position .y = Camera.main.transform.position.y
			player1Pos = FindPlayerGameObject(TeamScript.PlayerNumberEnum.player1)
			Camera.main.transform.position.x = player1Pos.transform.position .x 
			Camera.main.transform.position.y = player1Pos.transform.position .y
		Camera.main.transform.position.z = Z_CAMERA_POSITION_VALUE
			
	def CallIGameState( gameObjectList as (UnityEngine.GameObject), function as callable(IGameState)):
		for playerIGameState as GameObject in gameObjectList:
			playerIData  = playerIGameState.GetComponent[of DataScript]()
			aa = playerIGameState
			if(playerIData != null):
				//_currentPlayerGUI.PrintToScreen("GameState error playerIData" + playerIData) 
				if(playerIData.GameObjectType == DataScript.GameObjectTypeEnum.terrain):
					continue
					/*
				if(playerIData.GameObjectType == DataScript.GameObjectTypeEnum.building):
					print("GameState Buildigns EndTurn not implementent!")
					//TODO playerNumber = 
					continue
					*/
			/*
			if( playerIData.GameObjectType == DataScript.GameObjectTypeEnum.unit):
				playerNumber = (playerIGameState.GetComponent("ITeam") as ITeam).Player

			if( playerNumber == _currentTurn):
				*/
			
			for component as MonoBehaviour in playerIGameState.GetComponents[of MonoBehaviour]():
				if component isa IGameState:
					component1 as IGameState = component
					function(component1)
					continue
			/* 	
			// Dont work on webplayer!
			for component in _library.GetInterfaceComponents[of IGameState](playerIGameState):
				function((component as IGameState))
				continue
				*/
				
	/*
	def FindPlayersInList(container as List):
		playerList as List = []
		for force as object in container:
			if (force as IPlayer).Player not in playerList:
				playerList.Add(force.PlayerName)		
		return playerList	
				
	def CheckIfNotOnSameTeam(container as List):
		for player in container:	
			if container[0] != player:
				isFleetHostile = true 		//TODO function to checkl if theplayers are enemies	
				return true	
		return false	
		*/		
		