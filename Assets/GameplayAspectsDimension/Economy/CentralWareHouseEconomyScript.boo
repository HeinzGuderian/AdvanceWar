import UnityEngine

class CentralWareHouseEconomyScript (BuildingEconomy, IGUI): 
	_buyMenu as BasicMenu = null
	_waitingForBuyUnit as bool = false
	_isDoneBuyingUnit as bool = false
	_finalSupplyList as List = null	
	
	final MENU_NAME as string = "Buy Supplies" 
	ButtonImage as Texture
	DoneBuying as Texture

	def Start():
		super()
		_buildingScript = gameObject.GetComponent[of CentralWarehouseScript]()
		ButtonImage = Resources.Load("Textures/Buttons/tx_button_buySupplies", Texture)
		DoneBuying = Resources.Load("Textures/Buttons/tx_button_DoneBuying", Texture)
		assert _buildingScript != null

	def Actions():
		return [ {"name" : "Buy Supplies", "image": ButtonImage, "function"  : self.BuySupplies, "RunWaitFunction" : false ,"ShouldRevertWaitFunction":false,  "requireMouseClick" : 0, "requireSelected" : false}]
	
	def Info():
		return "ArmyEconomy"
		
	def Update ():		
		if _isDoneBuyingUnit == true:
			warehouse = (_buildingScript as CentralWarehouseScript)
			unitCostList = [unit["cost"] for unit as Boo.Lang.Hash in _finalSupplyList]
			finalUnitCost as int = 0
			for unitCost as int in unitCostList:
				finalUnitCost += unitCost
				
			if warehouse.LoadWeight + len(unitCostList)*100 > warehouse.MaxWeight:
				finalUnitCost -= warehouse.LoadWeight + finalUnitCost - warehouse.MaxWeight
			
			okayToBuild = _playerEconomy.CanAffordToBuild(finalUnitCost)
			
			
			
			if okayToBuild == true:
				_playerEconomy.DecreaseUR(finalUnitCost)
				

				for supplyHash as Boo.Lang.Hash in _finalSupplyList:
					if supplyHash["value"] cast SupplyAspectClass.SupplyTypes ==  SupplyAspectClass.SupplyTypes.Petrol:
						warehouse.SupplyPetrol += 100 
						warehouse.LoadWeight += 100
					elif supplyHash["value"] cast SupplyAspectClass.SupplyTypes ==  SupplyAspectClass.SupplyTypes.Ammo:
						warehouse.SupplyAmmo += 100 
						warehouse.LoadWeight += 100
					// add 100 fuel to warhouse
					else:
						print(supplyHash["value"])
						raise " Buy wrong: "+supplyHash["value"].ToString()
			elif okayToBuild == false:
				_currentPlayerGUI.PrintToScreen("Not enough money")
			
			_isDoneBuyingUnit = false
			_buyMenu = null
				
	def OnGUI():
		// Check if user is buying
		if _waitingForBuyUnit == true and _buyMenu != null:	
			// If user is done buying, then set buy flag to true	
			_finalSupplyList = _buyMenu.RunMenu()
			textStringHeight = 20
			buyButtonWidth = 100
			if _buyMenu.MenuX-buyButtonWidth < 0:
				_buyMenu.MenuX = buyButtonWidth
			if GUI.Button(Rect(_buyMenu.MenuX-buyButtonWidth, _buyMenu.MenuY+textStringHeight, 100, 100), DoneBuying,""):
				_isDoneBuyingUnit = true
				Destroy(_buyMenu)
				_waitingForBuyUnit = false	
			// Else user is buying, no action is to be taken
			else:
				pass
				
	def BuySupplies():
		// Find, allocate and validate teamScript, buying players economy and set wait to build. 
		_waitingForBuyUnit = true
		// If all checks have been passed create a buy menu and set it up 
		_buyMenu = gameObject.AddComponent[of BasicMenu]()
		suppliesToBuy = [
		{"GUIContent" : GUIContent(Resources.Load("Textures/Buttons/tx_button_buyPetrol", Texture)), "value": SupplyAspectClass.SupplyTypes.Petrol, "cost": SupplyAspectClass.SupplyCostTable[SupplyAspectClass.SupplyTypes.Petrol]} ,
		{"GUIContent" : GUIContent(Resources.Load("Textures/Buttons/tx_button_buyAmmo", Texture)), "value": SupplyAspectClass.SupplyTypes.Ammo, "cost": SupplyAspectClass.SupplyCostTable[SupplyAspectClass.SupplyTypes.Ammo]} 
		]
		
		unitsToBuyMenuFormat = [BasicMenu.BasicMenuItemStruct(ItemsValue:item) for item in suppliesToBuy]
		BasicMenu.SetupBasicMenu(_buyMenu, MENU_NAME, unitsToBuyMenuFormat,300, 300, 300, 150, 200, gameObject, EconomyAspectClass.MultipleBuyChoiceCode)		
		if _buyMenu.MenuY+_buyMenu.SelectMenuHeight > Screen.height:
			_buyMenu.MenuY = Screen.height-_buyMenu.SelectMenuHeight
			