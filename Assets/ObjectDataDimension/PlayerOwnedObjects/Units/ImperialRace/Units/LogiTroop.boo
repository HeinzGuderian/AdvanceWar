import UnityEngine
	
partial class LogiTroop (TroopClass, ISupplyTransfer ): 
	LogiUnitInfoImage as Texture
	
	override def Awake ():
		_productionCost = 100
		WeaponList = [WeaponSystem(Name: "Infantry close range", Range: 3, HardDamage: 2, HardMinimumDamage: 0, SoftDamage: 2, SoftMinimumDamage: 0 )]
		super()
		
	override def SetUpImagesProcedure():
		StandardUnitInfoPicture = Resources.Load("Textures/tx_unit_info_screen", Texture)
		UnitInfoButton = Resources.Load("Textures/Buttons/tx_button_unitInfo", Texture)
		UnitInfoImage = Resources.Load("Textures/tx_ui_selected_unit_indicator", Texture)
		LogiUnitInfoImage = Resources.Load("Textures/tx_ui_logi_cargo", Texture)
		
	// USed in unit info box
	override def InfoGUI():
		//return ""
		
		health = Health.ToString()
		actionPoints = ActionPoints.ToString()
		petrol = Petrol.ToString()
		ammo = Ammo.ToString()
		
		returnString = ""+actionPoints+" / "+health+" / "+petrol+" / "+ammo
		//return "" 
		return returnString
		
	def logiInfoGUI():
		returnString = ""+SupplyAmmo+"/"+SupplyPetrol+"/"+VictoryResources+"  "+LoadWeight+"/"+MaxWeight
		//return "" 
		return returnString
		
	override def OnGUI():
		
		if OurDataScript.IsSelected == true:
			// Standard info
			GUI.Label(Rect (170,0,128,64), UnitInfoImage,"")
			GUI.Label(Rect (170+5,0+36,128,128), InfoGUI())
			// Extended info image for Logi 
			GUI.Label(Rect (170,0+64,128,64), LogiUnitInfoImage,"")
			GUI.Label(Rect (170+5,0+36+64,128,128), logiInfoGUI())
		ShowUnitScreenProcedure()
	
	[SerializeField]
	_supplyPetrol as int 
	SupplyPetrol as int:
		get:
			return _supplyPetrol
		set:
			if(value<0):
				print("Error: New Petrol value is under zero!")
				_supplyPetrol = 0
			elif(value+(LoadWeight-_supplyPetrol)>MaxWeight):
				_supplyPetrol = MaxWeight-LoadWeight+_supplyPetrol
				print("New value would have breached MaxCurrentHold")
				return
			else:
				_supplyPetrol = value
	[SerializeField]
	_supplyAmmo as int 
	SupplyAmmo as int:
		get:
			return _supplyAmmo
		set:
			if(value<0):
				print("Error: New Ammo value is under zero!")
				_supplyAmmo = 0
			elif(value+(LoadWeight-_supplyAmmo)>MaxWeight):
				_supplyAmmo = MaxWeight-LoadWeight+_supplyAmmo
				print("New value would have breached MaxCurrentHold")
				return
			else:
				_supplyAmmo = value
	[SerializeField]
	_victoryResources as int 
	VictoryResources as int:
		get:
			return _victoryResources
		set:
			if(value<0):
				print("Error: New VictoryResources value is under zero!")
				_victoryResources = 0
			elif(value+(LoadWeight-_victoryResources)>MaxWeight):
				_victoryResources = MaxWeight-LoadWeight+_victoryResources
				print("New value would have breached MaxCurrentHold")
				return
			else:
				_victoryResources = value
	[SerializeField]
	_loadWeight as int 
	LoadWeight as int:
		get:
			return _loadWeight
		set:
			if(value<0):
				print("Error: New LoadWeight value is under zero!")
				_loadWeight = 0
			elif(value>MaxWeight):
				_loadWeight = MaxWeight
			else:
				_loadWeight = value
	[SerializeField]
	_maxWeight as int 
	MaxWeight as int:
		get:
			return _maxWeight
		set:
			if(value<0):
				print("Error: New MaxWeight value is under zero!")
				_maxWeight = 0
			else:
				_maxWeight = value
	

