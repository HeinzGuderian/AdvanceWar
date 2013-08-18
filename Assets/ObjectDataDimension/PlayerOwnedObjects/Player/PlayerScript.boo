import UnityEngine

/**
Object that stores one players resources and had functionality to retrive player variables.
*/
partial class PlayerScript (MonoBehaviour): 
	ships as duck	
	armys as duck
	public Buildings as List = []
			
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
			
	public _universalResources as int
	//[SerializeField]
	public _victoryResources as int
	
	UniversalResources as int:
		get:
			return _universalResources
			/*
			vr as int = 0
			for building as BuildingScript in [item.GetComponent[of BuildingScript]() for item as GameObject in Buildings]: 
				if building isa CentralWarehouseScript:
					
					vr += (building as CentralWarehouseScript).VictoryResources
			
			return vr
			*/
		set:
			_universalResources = value
	
	VictoryResources as int:
		get:
			return _victoryResources
			/*
			vr as int = 0
			for building as BuildingScript in [item.GetComponent[of BuildingScript]() for item as GameObject in Buildings]: 
				if building isa CentralWarehouseScript:
					
					vr += (building as CentralWarehouseScript).VictoryResources
			
			return vr
			*/
		set:
			_victoryResources = value
			
	_availableShips as List = null
	_availableTroops as List = null
	_race as RaceScript = null
	_library as LibraryScript = null
	def Awake ():
		_race = GetComponent[of RaceScript]()
		//_availableShips = _race.ShipList TODO
		_library = (GameObject.Find('GameRules').GetComponent[of LibraryScript]() as LibraryScript)
		ships = null
		armys = null
		
	def Start():
		_availableTroops = _race.TroopList 
		_library.checkInit(_race,_availableTroops)
	
	def checkInit():
		if _library==null:
			print("library is null")
			/*
			
		if _race==null:
			_currentPlayerGUI.PrintToScreen("irace is null")
		if _availableShips==null:
			_currentPlayerGUI.PrintToScreen("availableShips is null")
		if _availableTroops==null:
			_currentPlayerGUI.PrintToScreen("availableTroops is null")
			*/
	/*		
	def CheckIfVictorious() as bool:
		
		victoryResources = 0
		for logi as CentralWarehouseScript in FindObjectsOfType(CentralWarehouseScript):
			if TeamScript.FindTeamScript(logi.gameObject).Player == TeamScript.FindTeamScript(gameObject).Player:
				victoryResources += logi.VictoryResources
		self.VictoryResources = victoryResources
		return _race.CheckIfVictorious()
		
	def CheckIfHasLost() as bool:
		return _race.CheckIfHasLost()
	*/
	static def FindPlayerScript(gameObjectToSearch as GameObject):
		return gameObjectToSearch.GetComponent[of PlayerScript]()