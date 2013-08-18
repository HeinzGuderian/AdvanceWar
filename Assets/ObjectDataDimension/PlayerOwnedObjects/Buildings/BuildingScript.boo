import UnityEngine

/*
Using template desing pattertn with functions Start, SetUpImagesProcedure, SetUpStructProcedure, UpdateUnitInfo, StandardInfoCode, OnGUI
*/
partial class BuildingScript (MonoBehaviour, IGUI, IUseTerrain): 

	_currentOwner as TeamScript.PlayerNumberEnum
	_gameState as GameState
	_library as LibraryScript
	OurDataScript as DataScript 
	
	UnitInfoImage as Texture
	
	
	virtual def Info():
		return ""
		
	virtual def Actions():
		return []
		//return [{"name" : "Buy Troops", "function"  : self.BuyTroops, "requireMouseClick" : 0, "requireSelected" : false}]
	
	
	
	virtual def Start():
		_library = GameObject.Find('GameRules').GetComponent[of LibraryScript]()
		_gameState = GameObject.Find('GameRules').GetComponent[of GameState]()
		OurDataScript = gameObject.GetComponent[of DataScript]()
		assert _gameState != null
		assert _library != null
		assert OurDataScript != null
		
		SetUpImagesProcedure()
		//SetUpStructProcedure()
		//_unitInfoMenu = gameObject.AddComponent[of BasicMenu]()
		
	
		
	virtual def SetUpImagesProcedure():
		UnitInfoImage = Resources.Load("Textures/tx_ui_selected_unit_indicator", Texture)
		
		
	static def FindBuildingScript(gameObjectToSearch as GameObject):
		troopScript as BuildingScript = gameObjectToSearch.GetComponent[of BuildingScript]()
		return troopScript
		
	virtual def OnGUI():
		if OurDataScript.IsSelected == true:
			GUI.Label(Rect (170,0,128,64), UnitInfoImage,"")
			GUI.Label(Rect (170+5,0+36,128,128), InfoGUI() )
		
	virtual def InfoGUI() as string:
		return ""
	
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	CurrentOwner as TeamScript.PlayerNumberEnum:
		get:
			return _currentOwner
		set:
			playerScript = _gameState.FindPlayerScript(value)
			assert playerScript != null
			//ProduceObjects = playerScript.AvailableTroops
			_currentOwner = value
			
			
	[SerializeField]
	_occupiedTerrainGameObject as GameObject = null
	OccupiedTerrainGameObject as GameObject:
		get:
			return _occupiedTerrainGameObject
		set:
			_occupiedTerrainGameObject = value
	[SerializeField]
	_occupiedTerrain as TerrainScript
	OccupiedTerrain as TerrainScript:
		get:
			return _occupiedTerrain
		set:
			_occupiedTerrain = value
	
	
		
	