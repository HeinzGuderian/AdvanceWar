
	
class SupplyUnitScript (SupplyTroopScript): 
	final NO_UNITS_TO_SUPPLY as string = "No units close by to supply."
	_highlightedTerrains as List = []
	_supplyUnit as LogiTroop 
	_selectMenu as BasicMenu = null
	
	_playerNumber as TeamScript.PlayerNumberEnum
	_gameState as GameState
	_playerEconomy as PlayerEconomy
	
	_waitingForBuyUnit as bool = false
	_isDoneBuyingUnit as bool = false
	_finalUnitList as List = []	
	_lastIteration as List = []
	_lastIteration2 as List = []
	_resourceList as List = []	
	
	_searchFunction as callable
	_searchBuildingsFunction as callable
	DoneBuying as Texture
	_to as bool = true
	_currentIsDumpResources = false
	_currentIsTransferResources = false
	_targetVRPScript as ISupplyTransfer
	
	_currentPlayerGUI as GuiScript
	_supplyMarkers = []
	_resourcesGatherRange = 1
	
	TransferResourcesToButton as Texture
	TransferResourcesFromButton as Texture
	ResupplyAllTroopsButton as Texture
	ResupplyTroopButton as Texture
	GatherVictoryResourcesButton as Texture
	DumpResourcesButton as Texture
	
	final NEED_CLICK_ON_VRP as string = "You need to click on a Victory Resource producing building!"
	final STAND_ON_VRPB as string = "You need to stand on a Victory Resources producing building!"
	final FINISH_MENU as string = "Finish current menu action first."
	final EXCEEDS_MAX as string = "Total transferd amount exceeds maximum weight of the target."
	final OUT_OF_RANGE as string = "You need to stand next to the object!"
	
			

	def Start():
		_library = GameObject.Find('GameRules').GetComponent[of LibraryScript]()
		_gameState = GameObject.Find('GameRules').GetComponent[of GameState]()
		DoneBuying = UnityEngine.Resources.Load("Textures/Buttons/tx_button_DoneBuying", Texture)
		assert _gameState != null
		_supplyUnit = _testInfantryTroop
		assert _supplyUnit != null
		_searchFunction = {ourTeam as TeamScript.PlayerNumberEnum  |  return { x as GameObject | return  DataScript.FindDataScript(x).GameObjectType == DataScript.GameObjectTypeEnum.unit and ourTeam == TeamScript.FindTeamScript(x).Player}}
		_searchBuildingsFunction = {ourTeam as TeamScript.PlayerNumberEnum  |  return { x as GameObject | return  DataScript.FindDataScript(x).GameObjectType == DataScript.GameObjectTypeEnum.building and ourTeam == TeamScript.FindTeamScript(x).Player}}
		currentPlayersGameObject = _library.FindCamera()
		_currentPlayerGUI = currentPlayersGameObject.GetComponent[of GuiScript]()
		TransferResourcesToButton  = UnityEngine.Resources.Load("Textures/Buttons/tx_button_giveRes", Texture)
		TransferResourcesFromButton  = UnityEngine.Resources.Load("Textures/Buttons/tx_button_getRes", Texture)
		ResupplyAllTroopsButton  = UnityEngine.Resources.Load("Textures/Buttons/tx_button_supplyall", Texture)
		ResupplyTroopButton  = UnityEngine.Resources.Load("Textures/Buttons/tx_button_supply1troop", Texture)
		GatherVictoryResourcesButton  = UnityEngine.Resources.Load("Textures/Buttons/tx_button_getVres", Texture)
		DumpResourcesButton  = UnityEngine.Resources.Load("Textures/Buttons/tx_button_dumpRes", Texture)
	
	def Actions():
		actions = [ {"name"  : "Dump Resources", "image": DumpResourcesButton, "object": self as MonoBehaviour, "function"  : self.DumpResources as callable ,   "requireMouseClick" : 0, "requireSelected" : false},
		{"name"  : "Resupply Troop", "image" : ResupplyTroopButton, "object": self as MonoBehaviour, "function"  : self.ResupplyUnit as callable , "requireMouseClick" : 0, "requireSelected" : true, "RunWaitFunction" : true ,"WaitFunction": self.HighlightSupplyableUnits  ,"ShouldRevertWaitFunction":true, "RevertWaitFunction": self.DeHighlightSupplyableUnits} 
		]
		
		startTerrain as TerrainScript = _supplyUnit.OccupiedTerrain
		ourTeam as TeamScript.PlayerNumberEnum = TeamScript.FindTeamScript(gameObject).Player
		count as int = 0
		range as int = 1
		searchMatchedList1 as List = []
		searchedTerrain = []
		startTerrain.RecursiveTerrainObjectsSearchGrids(startTerrain, ourTeam , count , range , searchMatchedList1, _searchFunction(ourTeam), searchedTerrain )
		NoUnitsInRange as bool = searchMatchedList1 == []
		UnitsInresupplyRange as bool = len([troop for troop in searchMatchedList1 if _library.CalculateGridRange(gameObject, troop) <= _resourcesGatherRange]) > 0
		transferIsAdded = false
		transferFunctionList as List = [
				{"name"  : "Transfer Resources To", "image":TransferResourcesToButton, "object": self as MonoBehaviour, "function"  : self.TransferResourcesToTarget as callable ,   "requireMouseClick" : 0, "requireSelected" : true, "RunWaitFunction" : true ,"WaitFunction": self.HighlightSupplyableBuildings,"ShouldRevertWaitFunction":true, "RevertWaitFunction": self.DeHighlightSupplyableUnits} ,
				{"name"  : "Transfer Resources From", "image": TransferResourcesFromButton, "object": self as MonoBehaviour, "function"  : self.TransferResourcesFromTarget as callable ,   "requireMouseClick" : 0, "requireSelected" : true, "RunWaitFunction" : true ,"WaitFunction": self.HighlightSupplyableBuildings,"ShouldRevertWaitFunction":true, "RevertWaitFunction": self.DeHighlightSupplyableUnits} 
				]
		if NoUnitsInRange == false and UnitsInresupplyRange == true: 
			actions.Extend([
				{"name"  : "Resupply All Troops", "image" : ResupplyAllTroopsButton, "object": self as MonoBehaviour, "function"  : {self.ResupplyAllTroops(1)} as callable , "requireMouseClick" : 0, "requireSelected" : false}	
				
				])
			is_a_supply_unit as bool = false
			//a = searchMatchedList1[0]
			//d = searchMatchedList1
			//print(d)
			//print(searchMatchedList1)
			
			//b = searchMatchedList1[1]
			//c = [LibraryScript.GetInterfaceComponent[of ISupplyTransfer](go) for go as GameObject in searchMatchedList1 ]
			is_a_supply_unit = len([go for go as GameObject in searchMatchedList1 if LibraryScript.GetInterfaceComponent[of ISupplyTransfer](go) != null ]) > 0
			if is_a_supply_unit:
				actions.Extend(transferFunctionList)
				transferIsAdded = true
			
			
		searchMatchedList1 = []
		searchedTerrain = []
		
		startTerrain.RecursiveTerrainObjectsSearchGrids(startTerrain, ourTeam , count , range , searchMatchedList1, _searchBuildingsFunction(ourTeam), searchedTerrain )
		//print(len(searchMatchedList1))
		
		//existsVRPbuilding = false
		searchMatchedList1.Extend(_supplyUnit.OccupiedTerrain.ContainedObjects)
		for unit as GameObject in searchMatchedList1:
			if _library.GetInterfaceComponent[of IVRProducing](unit) != null and LibraryScript.CalculateGridRange(gameObject, unit) == 0 : 
				existsVRPbuildingAndWithinRange = true
				break
		if existsVRPbuildingAndWithinRange == true:
			actions.Add({"name"  : "Gather Victory Resources", "image" : GatherVictoryResourcesButton, "object": self as MonoBehaviour, "function"  : self.GatherVictoryResources as callable ,   "requireMouseClick" : 0, "requireSelected" : false} )
			
			
		is_a_warehouse as bool = false
		is_a_warehouse = len([go for go as GameObject in searchMatchedList1 if go.GetComponent[of CentralWarehouseScript]() != null]) > 0
		if is_a_warehouse and transferIsAdded == false:
			actions.Extend(transferFunctionList)	
		return actions
	
				
	def Info():
		return "Available Petrol: " + _supplyUnit.Petrol +"\n"+"SupplyPetrol: "+ (_supplyUnit as LogiTroop).SupplyPetrol
	
	def OnGUI():
		// Check if user is buying
		
		if _waitingForBuyUnit == true and _selectMenu != null:	
			// If user is done buying, then set buy flag to true
			_finalUnitList = _selectMenu.RunMenu()
			/*
			if _selectMenu.RunMenu() != _lastIteration:
				a = _selectMenu.RunMenu()
				_finalUnitList.Extend(_selectMenu.RunMenu()[len(_finalUnitList)-1:] )
				*/
			textStringHeight = 20
			buyButtonWidth = 100
			if _selectMenu.MenuX-buyButtonWidth < 0:
				_selectMenu.MenuX = buyButtonWidth
			if GUI.Button(Rect(_selectMenu.MenuX-buyButtonWidth, _selectMenu.MenuY+textStringHeight, 100, 100), DoneBuying,""):
			//if(GUI.Button (Rect ( 200, 300, 60, 60), GUIContent("Done") ) ): 
				_isDoneBuyingUnit = true
				Destroy(_selectMenu)
				_waitingForBuyUnit = false	
			// Else user is buying, no action is to be taken
			else:
				pass
			_lastIteration = _finalUnitList
	
	
	
	def ChangeSupplyValues(clickedList as List, VictoryResources as int, Ammo as int, Petrol as int):
		countHash = {SupplyAspectClass.SupplyTypes.VR: 0, SupplyAspectClass.SupplyTypes.Petrol: 0, SupplyAspectClass.SupplyTypes.Ammo: 0}
		list1 = []
		for hash as Boo.Lang.Hash in clickedList:
			countHash[hash["Type"] cast SupplyAspectClass.SupplyTypes] =  (countHash[hash["Type"] cast SupplyAspectClass.SupplyTypes] cast int + 1)
			list1.Add(hash["Type"])
		newVR = 100 * countHash[SupplyAspectClass.SupplyTypes.VR] cast int
		//newVR = _VictoryResources if VictoryResources - newVR < 0
			
		newPetrol = 100 * countHash[SupplyAspectClass.SupplyTypes.Petrol] cast int
		//newPetrol = _supplyUnit.SupplyPetrol if SupplyPetrol - newPetrol < 0


		newAmmo = 100 * countHash[SupplyAspectClass.SupplyTypes.Ammo] cast int
		//newAmmo = _supplyUnit.SupplyAmmo if SupplyAmmo - newAmmo < 0
	
		return newVR, newPetrol, newAmmo
									
	def Update ():		
		// If dumping resources
		if _isDoneBuyingUnit == true and _currentIsDumpResources == true:
			newVR, newPetrol, newAmmo = ChangeSupplyValues(_finalUnitList, _supplyUnit.VictoryResources , _supplyUnit.SupplyAmmo, _supplyUnit.SupplyPetrol)
			
			newVR = _supplyUnit.VictoryResources if _supplyUnit.VictoryResources - newVR < 0
			_supplyUnit.VictoryResources -= newVR
			_supplyUnit.LoadWeight -= newVR
			
			newPetrol = _supplyUnit.SupplyPetrol if _supplyUnit.SupplyPetrol - newPetrol < 0
			_supplyUnit.SupplyPetrol -= newPetrol
			_supplyUnit.LoadWeight -= newPetrol
			
			newAmmo = _supplyUnit.SupplyAmmo if _supplyUnit.SupplyAmmo - newAmmo < 0
			_supplyUnit.SupplyAmmo -= newAmmo
			_supplyUnit.LoadWeight -= newAmmo
			
			if _supplyUnit.LoadWeight < 0:
				_supplyUnit.LoadWeight = 0
				
			_isDoneBuyingUnit = false
			_currentIsDumpResources = false
			_selectMenu = null
			
		if _isDoneBuyingUnit == true and _currentIsTransferResources == true:
			newVR, newPetrol, newAmmo = ChangeSupplyValues(_finalUnitList, _supplyUnit.VictoryResources , _supplyUnit.SupplyAmmo, _supplyUnit.SupplyPetrol)
			
			
			if _to == true:
				newPetrol = _supplyUnit.SupplyPetrol if newPetrol > _supplyUnit.SupplyPetrol
				newAmmo = _supplyUnit.SupplyAmmo if newAmmo > _supplyUnit.SupplyAmmo
				newVR = _supplyUnit.VictoryResources if newVR > _supplyUnit.VictoryResources
					
				if (newVR + newPetrol + newAmmo + _targetVRPScript.LoadWeight > _targetVRPScript.MaxWeight):
					_currentPlayerGUI.PrintToScreen(EXCEEDS_MAX)
				elif newVR > _supplyUnit.VictoryResources or newPetrol > _supplyUnit.SupplyPetrol or newAmmo > _supplyUnit.SupplyAmmo:
					print("To much ")
				else:
					_targetVRPScript.VictoryResources += newVR
					_targetVRPScript.LoadWeight += newVR
					_supplyUnit.VictoryResources -= newVR
					_supplyUnit.LoadWeight -= newVR
					
					//newPetrol = _supplyUnit.SupplyPetrol if _supplyUnit.Loadweight + _supplyUnit.SupplyPetrol + newPetrol > _targetVRPScript.MaxWeight
					_targetVRPScript.SupplyPetrol += newPetrol
					_targetVRPScript.LoadWeight += newPetrol
					_supplyUnit.SupplyPetrol -= newPetrol
					_supplyUnit.LoadWeight -= newPetrol
					
					//newAmmo = _supplyUnit.SupplyAmmo if _supplyUnit.Loadweight + _supplyUnit.SupplyAmmo + newAmmo > _targetVRPScript.MaxWeight
					_targetVRPScript.SupplyAmmo += newAmmo
					_targetVRPScript.LoadWeight += newAmmo
					_supplyUnit.SupplyAmmo -= newAmmo
					_supplyUnit.LoadWeight -= newAmmo
				
			elif _to == false:
				newPetrol = _targetVRPScript.SupplyPetrol if newPetrol > _targetVRPScript.SupplyPetrol
				newAmmo = _targetVRPScript.SupplyAmmo if newAmmo > _targetVRPScript.SupplyAmmo
				newVR = _targetVRPScript.VictoryResources if newVR > _targetVRPScript.VictoryResources
				if (newVR + newPetrol + newAmmo + _supplyUnit.LoadWeight > _supplyUnit.MaxWeight or
				newVR > _targetVRPScript.VictoryResources or newPetrol > _targetVRPScript.SupplyPetrol or newAmmo > _targetVRPScript.SupplyAmmo):
					_currentPlayerGUI.PrintToScreen(EXCEEDS_MAX)
				else:
					//newVR = _supplyUnit.VictoryResources if _supplyUnit.Loadweight + _supplyUnit.VictoryResources + newVR > _targetVRPScript.MaxWeight
					_targetVRPScript.VictoryResources -= newVR
					_targetVRPScript.LoadWeight -= newVR
					_supplyUnit.VictoryResources += newVR
					_supplyUnit.LoadWeight += newVR
					//newPetrol = _supplyUnit.SupplyPetrol if _supplyUnit.Loadweight + _supplyUnit.SupplyPetrol + newPetrol > _targetVRPScript.MaxWeight
					_targetVRPScript.SupplyPetrol -= newVR
					_targetVRPScript.LoadWeight -= newVR
					_supplyUnit.SupplyPetrol += newPetrol
					_supplyUnit.LoadWeight += newPetrol
					//newAmmo = _supplyUnit.SupplyAmmo if _supplyUnit.Loadweight + _supplyUnit.SupplyAmmo + newAmmo > _targetVRPScript.MaxWeight
					_targetVRPScript.SupplyAmmo -= newVR
					_targetVRPScript.LoadWeight -= newVR
					_supplyUnit.SupplyAmmo += newAmmo
					_supplyUnit.LoadWeight += newAmmo
					
					assert _targetVRPScript.LoadWeight > -1 
				
			else:
				pass
				
			_targetVRPScript = null	
			_isDoneBuyingUnit = false
			_currentIsTransferResources = false
			_selectMenu = null

	
	def DumpResources():
		if _selectMenu != null:
			_currentPlayerGUI.PrintToScreen(FINISH_MENU)
			return
		_currentIsDumpResources = true
		// Find, allocate and validate teamScript, buying players economy and set wait to build. 
		_playerNumber = TeamScript.FindTeamScript(gameObject).Player //( newbuyingObject.GetComponent("ITeam") as ITeam ).PlayerName
		playerObject as GameObject = _gameState.FindPlayerGameObject(_playerNumber)
		assert playerObject != null
		_playerEconomy = PlayerEconomy.FindPlayerEconomy(playerObject)
		assert _playerEconomy != null
		_waitingForBuyUnit = true
		playerScript = playerObject.GetComponent[of PlayerScript]()
		assert playerScript != null
		
		// If all checks have been passed create a buy menu and set it up 
		_selectMenu = gameObject.AddComponent[of BasicMenu]()
		resourcesToBuy = [{"GUIContent": GUIContent("Victory Resources"), "Type": SupplyAspectClass.SupplyTypes.VR} ,
			{"GUIContent": GUIContent("Petrol"), "Type": SupplyAspectClass.SupplyTypes.Petrol} ,
			{"GUIContent": GUIContent("Ammo"), "Type": SupplyAspectClass.SupplyTypes.Ammo}]
		unitsToBuyMenuFormat = [BasicMenu.BasicMenuItemStruct(ItemsValue:item) for item in resourcesToBuy]
//		toScreenCoords = Camera.main.WorldToViewportPoint(Vector3(newTerrain1.transform.position.x,newTerrain1.transform.position.y, _gameState.Z_SCREEN_POSITION_VALUE))
	
		//backToWorld = Camera.main.ScreenToWorldPoint ( toScreenCoords)
		//_currentPlayerGUI.PrintToScreen(toScreenCoords.x * Screen.width + " : " + toScreenCoords.y * Screen.height)
		//_currentPlayerGUI.PrintToScreen(toScreenCoords)
		// static def SetupBasicMenu(ref basicMenu as BasicMenu, MenuName as string, objectList as List, x as int, y as int, maxMenuWidth as int, 	objectRowWidth as int, rowHeight as int, callingObject as GameObject, itemCodeBlock as MenuItemCallable)
		BasicMenu.SetupBasicMenu(_selectMenu, "Wiee!", unitsToBuyMenuFormat,400, 400, 100, 70, 50, gameObject, EconomyAspectClass.MultipleBuyChoiceCode)
	
	def TransferResourcesToTarget(target as GameObject) as System.Collections.IEnumerator:
		_to	= true
		TransferResources(target)
		yield
	def TransferResourcesFromTarget(target as GameObject) as System.Collections.IEnumerator:
		_to = false
		TransferResources(target)
		yield
								
	def TransferResources(target as GameObject):
		if _selectMenu != null:
			_currentPlayerGUI.PrintToScreen(FINISH_MENU)
		_currentIsTransferResources = true	
		
		if LibraryScript.CalculateGridRange(gameObject, target) > 1:
			_currentPlayerGUI.PrintToScreen(OUT_OF_RANGE)
			return
		// Try to get VRP script
		_targetVRPScript = LibraryScript.GetInterfaceComponent[of ISupplyTransfer](target)
		if _targetVRPScript == null:
			_currentPlayerGUI.PrintToScreen(NEED_CLICK_ON_VRP)
			return
		_waitingForBuyUnit = true	
		// If all checks have been passed create a buy menu and set it up 
		_selectMenu = gameObject.AddComponent[of BasicMenu]()
		resourcesToBuy = [{"GUIContent": GUIContent(UnityEngine.Resources.Load("Textures/Buttons/tx_button_buyVres", Texture)), "Type": SupplyAspectClass.SupplyTypes.VR} ,
			{"GUIContent": GUIContent(UnityEngine.Resources.Load("Textures/Buttons/tx_button_buyPetrol", Texture)), "Type": SupplyAspectClass.SupplyTypes.Petrol} ,
			{"GUIContent": GUIContent(UnityEngine.Resources.Load("Textures/Buttons/tx_button_buyAmmo", Texture)), "Type": SupplyAspectClass.SupplyTypes.Ammo}]
		unitsToBuyMenuFormat = [BasicMenu.BasicMenuItemStruct(ItemsValue:item) for item in resourcesToBuy]	
		BasicMenu.SetupBasicMenu(_selectMenu, "Wiee!", unitsToBuyMenuFormat,300, 100, 300, 150, 180, gameObject, EconomyAspectClass.MultipleBuyChoiceCode)
			/*
		// Read VR current hold.
		VRhold = targetVRPScript.CurrentVRHold
		// check if VR hold smaller then our free capacity
		if VRhold <= (_supplyUnit.MaxLoadWeight - _supplyUnit.LoadWeight): // VictoryResources
			// Then transfer over the VR
			_supplyUnit.VictoryResources += VRhold
			_supplyUnit.LoadWeight += VRhold
			// remove same amount from VRP unit
		else:	
			// if not calculate the maximum we can take
			maximumVRHold = _supplyUnit.MaxLoadWeight - _supplyUnit.LoadWeight
			// transafer the maximum
			_supplyUnit.VictoryResources += maximumVRHold
			_supplyUnit.LoadWeight += maximumVRHold
			// remove same amount from VRP unit
			targetVRPScript.CurrentVRHold -= maximumVRHold
		yield
		
		// Find, allocate and validate teamScript, buying players economy and set wait to build. 
		_playerNumber = TeamScript.FindTeamScript(gameObject).Player //( newbuyingObject.GetComponent("ITeam") as ITeam ).PlayerName
		playerObject as GameObject = _gameState.FindPlayerGameObject(_playerNumber)
		assert playerObject != null
		_playerEconomy = PlayerEconomy.FindPlayerEconomy(playerObject)
		assert _playerEconomy != null
		
		playerScript = playerObject.GetComponent[of PlayerScript]()
		assert playerScript != null

	*/
	// Will fill up this units supply hold with VR, will also remove VR of that amount from the VRP script	
	def GatherVictoryResources():
		target as GameObject = [go for go as GameObject in _testInfantryTroop.OccupiedTerrain.ContainedObjects if go.GetInstanceID() != gameObject.GetInstanceID()][0]
		//a = LibraryScript.CalculateGridRange(gameObject, target)
		/*if LibraryScript.CalculateGridRange(gameObject, target) > 1:
			_currentPlayerGUI.PrintToScreen(OUT_OF_RANGE)
			return*/
		// Try to get VRP script
		targetVRPScript as IVRProducing = LibraryScript.GetInterfaceComponent[of IVRProducing](target)
		if targetVRPScript == null:
			_currentPlayerGUI.PrintToScreen(STAND_ON_VRPB)
			return
		// Read VR current hold.
		VRhold = targetVRPScript.CurrentVRHold
		// check if VR hold smaller then our free capacity
		if VRhold <= (_supplyUnit.MaxWeight - _supplyUnit.LoadWeight): // VictoryResources
			// Then transfer over the VR
			_supplyUnit.VictoryResources += VRhold
			_supplyUnit.LoadWeight += VRhold
			// remove same amount from VRP unit
			targetVRPScript.CurrentVRHold -= VRhold
		else:	
			// if not calculate the maximum we can take
			maximumVRHold = _supplyUnit.MaxWeight - _supplyUnit.LoadWeight
			// transafer the maximum
			_supplyUnit.VictoryResources += maximumVRHold
			_supplyUnit.LoadWeight += maximumVRHold
			// remove same amount from VRP unit
			targetVRPScript.CurrentVRHold -= maximumVRHold
		
			
		
	def ResupplyAllTroops(rangeGrid as int):
		// Get all friendly units in the vicinity
		startTerrain as TerrainScript = _supplyUnit.OccupiedTerrain
		ourTeam as TeamScript.PlayerNumberEnum = TeamScript.FindTeamScript(gameObject).Player
		count as int = 0
		range as int = 1
		searchMatchedList as List = []
		searchedTerrain = []
		startTerrain.RecursiveTerrainObjectsSearchGrids(startTerrain, ourTeam , count , range , searchMatchedList, _searchFunction(ourTeam), searchedTerrain )
		NoUnitsInRange as bool = searchMatchedList == []
		// If no units in teh vicinity print and exit
		if NoUnitsInRange:
			_currentPlayerGUI.PrintToScreen(NO_UNITS_TO_SUPPLY)
			return null
		
		// Resupply all units
		//c = searchMatchedList
		//b = [TroopClass.FindTroopScript(unit)  for unit as GameObject in searchMatchedList]
		for unit as GameObject in  searchMatchedList:
			//itemsToresupply = [unit.Petrol, unit.Ammo]
			ResupplyAnyUnitFromAnyUnit(TroopClass.FindTroopScript(unit),(_supplyUnit as LogiTroop) )
		return
			
	// Note that this function has side-effect of reducing the supply in the supply unit
	def ResupplyUnit(unitToResupply as GameObject) as System.Collections.IEnumerator:
		unit as TroopClass = TroopClass.FindTroopScript(unitToResupply)
		ResupplyAnyUnitFromAnyUnit(unit, _supplyUnit)
		yield
	
	static def ResupplyAnyUnitFromAnyUnit(unitToResupply as TroopClass, resupplyer as LogiTroop):
		assert unitToResupply != null
		assert resupplyer != null
		petrolRefillNeed =  unitToResupply.MaxPetrol - unitToResupply.Petrol
		if resupplyer.SupplyPetrol - petrolRefillNeed >= 0:
			unitToResupply.Petrol += petrolRefillNeed
			resupplyer.SupplyPetrol -= petrolRefillNeed
			
		ammoRefillNeed = unitToResupply.MaxAmmo - unitToResupply.Ammo
		if resupplyer.SupplyAmmo - ammoRefillNeed >= 0:
			unitToResupply.Ammo += ammoRefillNeed
			resupplyer.SupplyAmmo -= ammoRefillNeed
			
	def HighlightSupplyableUnits():
		// Highlight terrain that you can build on.
		startTerrain as TerrainScript = TerrainScript.FindTerrainScript(_supplyUnit.OccupiedTerrainGameObject)
		ourTeam as TeamScript.PlayerNumberEnum = TeamScript.FindTeamScript(gameObject).Player
		count as int = 0
		range as int = 1
		_highlightedTerrains = []
		searchedTerrain = []
		startTerrain.RecursiveTerrainObjectsSearchGrids(startTerrain, ourTeam, count , range , _highlightedTerrains, _searchFunction(ourTeam), searchedTerrain)
		_highlightedTerrains.Add(gameObject)
		for go as TroopClass in [(TroopClass.FindTroopScript(go) as TroopClass) for go as GameObject in _highlightedTerrains ]:
			_supplyMarkers.Add(Instantiate(UnityEngine.Resources.Load('Effects/IndicatorTargetFriendlyPreFab'), go.gameObject.transform.position, Quaternion.identity))
			//(go as IHighlight).Highlight()
			
	def HighlightSupplyableBuildings():
		// Highlight terrain that you can build on.
		startTerrain as TerrainScript = TerrainScript.FindTerrainScript(_supplyUnit.OccupiedTerrainGameObject)
		ourTeam as TeamScript.PlayerNumberEnum = TeamScript.FindTeamScript(gameObject).Player
		count as int = 0
		range as int = 1
		_highlightedTerrains = []
		searchedTerrain = []
		startTerrain.RecursiveTerrainObjectsSearchGrids(startTerrain, ourTeam, count , range , _highlightedTerrains, _searchBuildingsFunction(ourTeam), searchedTerrain)
		for go as BuildingScript in [(BuildingScript.FindBuildingScript(go) as BuildingScript) for go as GameObject in _highlightedTerrains ]:
			_supplyMarkers.Add(Instantiate(UnityEngine.Resources.Load('Effects/IndicatorTargetFriendlyPreFab'), go.gameObject.transform.position, Quaternion.identity))
			
	def DeHighlightSupplyableUnits():
			
		for marker in _supplyMarkers :
			Destroy(marker)
		_supplyMarkers = []
			
			
		
		

