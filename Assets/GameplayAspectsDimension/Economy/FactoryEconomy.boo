import UnityEngine

class FactoryEconomy (BuildingEconomy, IGUI):
	_buyMenu as BasicMenu = null
	_highlightedTerrains as List = []
	
	_waitingForBuyUnit as bool = false
	_isDoneBuyingUnit as bool = false
	_finalUnitList as List = null				
	_newBuyUnitTerrain as TerrainScript = null
	_unitNewPositon as Vector3
	
	
	
	final TARGET_NOT_TERRAIN as string = "You need to select a terrain tile."
	final TARGET_TERRANI_IS_OCCUPIED as string= "The terrain is already occupied."
	final MENU_NAME as string = "Buy Unit" 
	final TARGET_TO_FAR as string = "You clicked a tile to far away"
	
	ButtonImage as Texture
	
	def Actions():
		return [ {"name" : "Buy Troops", "image": ButtonImage, "function"  : self.BuyShips, "RunWaitFunction" : true ,"WaitFunction": self.HighlightSelectableTiles,"ShouldRevertWaitFunction":true, "RevertWaitFunction": self.DeHighlightSelectableTiles,  "requireMouseClick" : 0, "requireSelected" : true}]
	
	def Info():
		return "ArmyEconomy"

	override def Awake():
		super()
		_waitingForBuyUnit = false
		_isDoneBuyingUnit = false 
		_buildingScript = gameObject.GetComponent[of FactoryScript]()
		//_newBuyUnitTerrain = transform.position	
		
	def Start():
		super()
		
		ButtonImage = Resources.Load("Textures/Buttons/tx_button_buyUnit", Texture)
		assert _buildingScript != null
	
	
	static def CreateBuilding(preFabObject as GameObject, newPosition as Vector3, playerNumber as TeamScript.PlayerNumberEnum):
		newGameObject as GameObject = Instantiate(preFabObject, newPosition,  Quaternion.identity  )
		newGOteamScript = newGameObject.GetComponent[of TeamBuildingScript]()
		newGOteamScript.SetTeam(playerNumber)
		
		//newGameObject.transform.rotation.x = 90 // Becouse otherwise they bug out and are turnd odd
		newGameObject.transform.rotation = Quaternion.Euler(270, 0, 0)
		//GameObject.RecursiveRendererEnable(newGameObject)
		//newGOsightScript = newGameObject.GetComponent[of SightTroop]()
		//newGOsightScript.StartTurnActions()
		//newGOsightScript.CheckSurroundings()
		
		return newGameObject
							
	static def CreateUnit(preFabObject as GameObject, newPosition as Vector3, playerNumber as TeamScript.PlayerNumberEnum):
		newGameObject as GameObject = Instantiate(preFabObject, newPosition, Quaternion.identity  )
		newGOteamScript = newGameObject.GetComponent[of TeamScript]()
		newGOteamScript.SetTeam(playerNumber)
		
		//GameObject.RecursiveRendererEnable(newGameObject)
		newGOsightScript = newGameObject.GetComponent[of SightTroop]()
		newGOsightScript.StartTurnActions()
		//newGOsightScript.CheckSurroundings()
		
		return newGameObject
		/*
		for scriptDataPair as List in (ship["value"] as Boo.Lang.Hash)['scripts'] as List:
 			script as IData = newGameObject.AddComponent((scriptDataPair[0] as System.Type))
 			script.SetValues(scriptDataPair[1] as Boo.Lang.Hash) 
 			*/
 		
	def HighlightSelectableTiles():
		// Highlight terrain that you can build on.
		startTerrain as TerrainScript = TerrainScript.FindTerrainScript(_buildingScript.OccupiedTerrainGameObject)
		
		ourTeam as TeamScript.PlayerNumberEnum = TeamScript.FindTeamScript(gameObject).Player
		count as int = 0
		range as int = 1
		//searchMatchedList as List = []
		_highlightedTerrains = []
		notOccupiedNotWater ={go as GameObject | return TerrainScript.FindTerrainScript(go).IsOccupied == false and TerrainScript.FindTerrainScript(go).TerrainType != TerrainScript.TerrainTypeEnum.water} 
		/*
		notOccupied = def(go as GameObject, ref searchList as List ):
			if TerrainScript.FindTerrainScript(go).IsOccupied == false:
				searchList.AddUnique(go)
				//return true
			else:
				pass
				//return false
		*/
		searchedTerrain = []
		startTerrain.RecursiveTerrainSearchGrids(startTerrain, ourTeam, count , range , _highlightedTerrains, notOccupiedNotWater, searchedTerrain)
		//a = [(TerrainScript.FindTerrainScript(go) as TerrainScript) for go as GameObject in _highlightedTerrains ]
		for go as TerrainScript in [(TerrainScript.FindTerrainScript(go) as TerrainScript) for go as GameObject in _highlightedTerrains ]:
			go.Highlight()
			
	def DeHighlightSelectableTiles():
		for go as TerrainScript in [(TerrainScript.FindTerrainScript(go) as TerrainScript) for go as GameObject in _highlightedTerrains ]:
			go.DeHighlight()
		
	
	def Update ():		
		if _isDoneBuyingUnit == true:
			unitCostList = [unit["cost"] for unit as Boo.Lang.Hash in _finalUnitList]
			finalUnitCost as int = 0
			for unitCost as int in unitCostList:
				finalUnitCost += unitCost
			okayToBuild = _playerEconomy.CanAffordToBuild(finalUnitCost)
			
			if okayToBuild == true:
				_playerEconomy.DecreaseUR(finalUnitCost)
				newUnit = CreateUnit( (_finalUnitList[0] as Boo.Lang.Hash)["value"], _unitNewPositon, _playerNumber)
				newUnit.SendMessage('StartTurnActions',null)
				assert newUnit != null
				newUnitTeamScript = TeamScript.FindTeamScript(newUnit)
				assert newUnitTeamScript != null
				teamScript = TeamScript.FindTeamScript(gameObject)
				assert teamScript != null
				print(teamScript.Player)
				//newUnitTeamScript.Player = teamScript.Player
				
				//instantiatedUnit = [CreateShip(ship) for ship as Boo.Lang.Hash in _finalUnitList]
				//FleetData.CreateFleet(_playerNumber, instantiatedShips, _newBuyUnitTerrain)
			elif okayToBuild == false:
				_currentPlayerGUI.PrintToScreen("Not enough money")
			
			_isDoneBuyingUnit = false
			_buyMenu = null
			for go as TerrainScript in [(TerrainScript.FindTerrainScript(go) as TerrainScript) for go as GameObject in _highlightedTerrains ]:
				go.DeHighlight()
				 
		
	def OnGUI():
		// Check if user is buying
		if _waitingForBuyUnit == true and _buyMenu != null:	
			// If user is done buying, then set buy flag to true	
			_finalUnitList = _buyMenu.RunMenu()
			if(len(_finalUnitList)==1):
				_isDoneBuyingUnit = true
				Destroy(_buyMenu)
				_waitingForBuyUnit = false	
			// Else user is buying, no action is to be taken
			else:
				pass
		
		
		
	def BuyShips(newTerrain1 as GameObject) as System.Collections.IEnumerator:
		// Check that the target terrain is valid
		newTerrain as TerrainScript = TerrainScript.FindTerrainScript(newTerrain1)
		if newTerrain == null or not ((newTerrain as TerrainScript) isa TerrainScript):
			_currentPlayerGUI.PrintToScreen(TARGET_NOT_TERRAIN)
			return null
		if newTerrain.IsOccupied == true:
			_currentPlayerGUI.PrintToScreen(TARGET_TERRANI_IS_OCCUPIED)
			return null
		if _library.CalculateGridRange(newTerrain1, gameObject) >= 2:
			_currentPlayerGUI.PrintToScreen(TARGET_TO_FAR)
			return
			
		// Find, allocate and validate teamScript, buying players economy and set wait to build. 
		_waitingForBuyUnit = true
		// If all checks have been passed create a buy menu and set it up 
		_buyMenu = gameObject.AddComponent[of BasicMenu]()
		_unitNewPositon = newTerrain.gameObject.transform.position
		_newBuyUnitTerrain = newTerrain
		unitsToBuy = _playerScript.AvailableTroops
		unitsToBuyMenuFormat = [BasicMenu.BasicMenuItemStruct(ItemsValue:item) for item in unitsToBuy]
		toScreenCoords = Camera.main.WorldToViewportPoint(Vector3(newTerrain1.transform.position.x,newTerrain1.transform.position.y, _gameState.Z_SCREEN_POSITION_VALUE))
	
		//backToWorld = Camera.main.ScreenToWorldPoint ( toScreenCoords)
		print(toScreenCoords.x * Screen.width + " : " + toScreenCoords.y * Screen.height)
		print(toScreenCoords)
		// static def SetupBasicMenu(ref basicMenu as BasicMenu, MenuName as string, objectList as List, x as int, y as int, maxMenuWidth as int, 	objectRowWidth as int, rowHeight as int, callingObject as GameObject, itemCodeBlock as MenuItemCallable)
		//BasicMenu.SetupBasicMenu(_buyMenu, MENU_NAME, unitsToBuyMenuFormat,toScreenCoords.x * Screen.width, Screen.height-(toScreenCoords.y * Screen.height), 100, 70, 50, gameObject, EconomyAspectClass.BuyMenuCode)
		BasicMenu.SetupBasicMenu(_buyMenu, MENU_NAME, unitsToBuyMenuFormat,toScreenCoords.x * Screen.width, Screen.height-(toScreenCoords.y * Screen.height), 300, 100, 100, gameObject, EconomyAspectClass.BuyMenuCode)		
		if _buyMenu.MenuY+_buyMenu.SelectMenuHeight > Screen.height:
			_buyMenu.MenuY = Screen.height-_buyMenu.SelectMenuHeight
	
		
		//passedData = []
		//searchFunction = {currentTerrain as GameObject | return MoveAspectClass.terrainMoveCost(gameObject,currentTerrain) <=  }
		//RecursiveTerrainSearch(startPoint, ourTeam, {data as List | return data[0] == data[1] }, {ref data as List | data[0] =  data[0] cast int+1}, [count, range], searchMatchedList, searchFunction)
		
		yield
		/*
		objectTypes = []
		shipTypesNumber = [] 
		for shipType in [shipType1["value"] for shipType1 as Boo.Lang.Hash in shipsToBuy]:
			if shipType not in shipTypes:
				shipTypes.Add(shipType)
		
		shipTypesNumber.Add(0)
		_ShipTypesAndNumber = [object1 for object1 in zip(shipTypes, shipTypesNumber)]
		*/
		
		//_buyMenu = _library.CreateBuyMenu(troopsToBuy, 50, 50, gameObject)	
		
	
