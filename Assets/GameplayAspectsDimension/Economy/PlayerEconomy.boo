import UnityEngine

/**
Object that stores one players resources and had functionality to retrive player variables.
*/
class PlayerEconomy (MonoBehaviour, IGameState): 
	
			/*
	AvailableShips as List:
		get:
			return _availableShips
		set:
			_availableShips = _race.ShipList
			
	AvailableTroops as List:
		get:
			return _availableTroops
		set:
			_availableTroops = _race.TroopList
	*/		
	//_availableShips as List = null
	//_availableTroops as List = null
	_race as RaceScript = null
	_playerScript as PlayerScript = null
	_library as LibraryScript = null
	
	_turnIncome as int = 100
	OilfieldIncome as int = 100
	
	TurnIncome as int:
		get:
			ourTeamScript as TeamScript = TeamScript.FindTeamScript(gameObject)
			//print ([OilfieldScript.gameObject for OilfieldScript as OilfieldScript in GameObject.FindObjectsOfType(OilfieldScript) if TeamScript.IsSameTeam(ourTeamScript,TeamScript.FindTeamScript(OilfieldScript.gameObject)) ].Count)
			//print ( OilfieldIncome * [OilfieldScript.gameObject for OilfieldScript as OilfieldScript in GameObject.FindObjectsOfType(OilfieldScript) if TeamScript.IsSameTeam(ourTeamScript,TeamScript.FindTeamScript(OilfieldScript.gameObject)) ].Count)
			return OilfieldIncome * [OilfieldScript.gameObject for OilfieldScript as OilfieldScript in GameObject.FindObjectsOfType(OilfieldScript) if TeamScript.IsSameTeam(ourTeamScript,TeamScript.FindTeamScript(OilfieldScript.gameObject)) ].Count
			//return 100
		set:
			OilfieldIncome = value
			
	def Awake ():
		_race = GetComponent[of RaceScript]()
		_playerScript = PlayerScript.FindPlayerScript(gameObject)
		//_availableShips = _race.ShipList
		//_availableTroops = _race.TroopList
		_library = (GameObject.Find('GameRules').GetComponent[of LibraryScript]() as LibraryScript)
		//ships = null
		//armys = null
		_library.checkInit(_playerScript,_race)
	
	def EndTurnActions():
		_playerScript.UniversalResources += TurnIncome
		
	def StartTurnActions():
		return
	
	def checkInit():
		if _library==null:
			print("library is null")
		if _race==null:
			print("irace is null")
		assert _playerScript != null
			/*
		if _availableShips==null:
			_currentPlayerGUI.PrintToScreen("availableShips is null")
		if _availableTroops==null:
			_currentPlayerGUI.PrintToScreen("availableTroops is null")
			*/
	
	def Update ():
		pass
		
	def Info():
		return "Money: "+_playerScript.UniversalResources.ToString()
		
	def GetMoney ():
		return _playerScript.UniversalResources
	
	def SetMoney (ur as int):
		if(ur < 0):
			print("New _playerScript.UniversalResources value is below 0")
		else:
			_playerScript.UniversalResources = ur
			
	def IncreaseUR (ur as int):
		_playerScript.UniversalResources = _playerScript.UniversalResources+ur
		
	def DecreaseUR (ur as int):
		_playerScript.UniversalResources = _playerScript.UniversalResources-ur
		
	def CanAffordToBuild(cost as int):	
		if _playerScript.UniversalResources >= cost:
			return true
		else:
			return false
			
	static def FindPlayerEconomy(gameObjectToSearch as GameObject):
		playerEconomyScript as PlayerEconomy = gameObjectToSearch.GetComponent[of PlayerEconomy]()
		return playerEconomyScript
	
