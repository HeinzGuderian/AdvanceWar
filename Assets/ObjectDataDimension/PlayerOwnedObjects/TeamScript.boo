import UnityEngine
//import testExtension

class TeamScript (MonoBehaviour, ITeam): 
	
	[SerializeField] playersTeam as string
	[SerializeField] _playerNumber as PlayerNumberEnum
	public materials as (Material)
	_player as PlayerScript = null
	_gameState as GameState = null
	start = true
	
	
	virtual def SetTeam(playerNumber as PlayerNumberEnum):
		_playerNumber = playerNumber
		if playerNumber == PlayerNumberEnum.player1:
			GetComponent[of Renderer]().material = materials[0]
			
			RecursiveSetRendererMaterial(gameObject, materials[0])
		elif playerNumber == PlayerNumberEnum.player2:
			GetComponent[of Renderer]().material = materials[1]
			RecursiveSetRendererMaterial(gameObject, materials[1])
		else:
			pass
		if start == false:
			for IAfterTeamSwitchScript as MonoBehaviour in gameObject.GetComponents[of MonoBehaviour]():
				if IAfterTeamSwitchScript isa IAfterTeamSwitch:
					IAfterTeamSwitchScript1 as IAfterTeamSwitch = IAfterTeamSwitchScript
					IAfterTeamSwitchScript1.OnTeamSwitch() unless start == true
				/*
			for IAfterTeamSwitchScript as IAfterTeamSwitch in LibraryScript.GetInterfaceComponents[of IAfterTeamSwitch](gameObject):
				IAfterTeamSwitchScript.OnTeamSwitch() unless start == true
				*/
			//print("SetTeam playerNumber is unknown playernumber: " +playerNumber.ToString() )
		if start == true:
			start = false
		
	def DeHighlight():
		GetComponent[of Renderer]().material = materials[0]
	
	public enum PlayerNumberEnum:
		player1 = 0
		player2 = 1
		none = 2
		
		
	Player as TeamScript.PlayerNumberEnum:
		get:
			return _playerNumber
		set:
			_playerNumber = value
			
			/*
			_player = _gameState.FindPlayerScript(value) 
			_player
			if(_player is null): // TODO remove from production code
				_currentPlayerGUI.PrintToScreen("troopClass._playerNumber.set. error _player = _library.FindPlayer(_playerNumber)  is null")
			*/

/*
	PlayerScript as PlayerScript:
		get:
			return _player
	*/
	PlayerNumber as PlayerNumberEnum:
		get:
			return _playerNumber
	
	PlayersTeam as string:
		get: 
			return playersTeam
			
	def IsOurTurn() as bool:
		gameRules = (GameObject.Find('GameRules').GetComponent[of GameState]() as GameState)
		print("Player: "+Player+" WhosTurn: "+gameRules.WhosTurn+" CurrentPlayer: "+gameRules.CurrentPlayer)
		return Player == gameRules.WhosTurn
		
	def CanPlay() as bool:
		gameRules = (GameObject.Find('GameRules').GetComponent[of GameState]() as GameState)
		print("Player: "+Player+" WhosTurn: "+gameRules.WhosTurn+" CurrentPlayer: "+gameRules.CurrentPlayer)
		return Player == gameRules.WhosTurn and gameRules.WhosTurn == gameRules.CurrentPlayer

	static def FindTeamScript(gameObjectToSearch as GameObject):
		teamScript as TeamScript = gameObjectToSearch.GetComponent[of TeamScript]()
		return teamScript
		
	static def IsNotSameTeam(firstGO as TeamScript, secondGO as TeamScript):
		return firstGO.Player != secondGO.Player
		
	static def IsSameTeam(firstGO as TeamScript, secondGO as TeamScript):
		return firstGO.Player == secondGO.Player
		
	static def StringToPlayerNumber(sourceString as string):
		if sourceString.Equals("player1") or sourceString.Equals("Player1"):
			return PlayerNumberEnum.player1
		if sourceString.Equals("player2") or sourceString.Equals("Player2"):
			return PlayerNumberEnum.player2
		if sourceString.Equals("none") or sourceString.Equals("None"):
			return PlayerNumberEnum.none
		else:
			raise "StringToPlayer error: "+sourceString
		
		
	virtual def Awake():
		_gameState = GameObject.Find("GameRules").GetComponent[of GameState]()
		//_player = (GameObject.Find('GameRules').GetComponent[of GameState]() as GameState).WhosTurn
		assert _gameState != null
		if gameObject.GetComponent[of DataScript]() != null:
			SetTeam(_playerNumber)
		//assert _player != null
	
	def Update ():
		pass
