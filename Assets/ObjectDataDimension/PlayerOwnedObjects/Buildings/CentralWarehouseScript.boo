import UnityEngine

partial class CentralWarehouseScript (BuildingScript, ISupplyTransfer): 
	
	/*
	def Awake():
		InitialiseSerialize(self)
		*/
	
	
	override def SetUpImagesProcedure():
		UnitInfoImage = Resources.Load("Textures/tx_ui_centralbase_info", Texture)	
		
		
	override def OnGUI():
		if OurDataScript.IsSelected == true:
			GUI.Label(Rect (170,0,128,64), UnitInfoImage,"")
			GUI.Label(Rect (170+5,0+36,128,128), InfoGUI())
		
	def InfoGUI() as string:
		returnString = ""+SupplyAmmo+"/"+SupplyPetrol+"/"+VictoryResources+"  "+LoadWeight+"/"+MaxWeight
		//return "" 
		return returnString
		
	
	[SerializeField]
	_health as int = 100	
	Health as int:
		get:
			return _health
		set:
			_health = value
	
	[SerializeField]
	_petrol as int 
	SupplyPetrol as int:
		get:
			return _petrol
		set:
			if(value<0):
				print("Error: New Petrol value is under zero!")
				_petrol = 0
			elif(value+(LoadWeight-_petrol)>MaxWeight):
				_petrol = MaxWeight-LoadWeight+_petrol
				print("New value would have breached MaxCurrentHold")
				return
			else:
				_petrol = value
	[SerializeField]
	_Ammo as int 
	SupplyAmmo as int:
		get:
			return _Ammo
		set:
			if(value<0):
				print("Error: New Ammo value is under zero!")
				_Ammo = 0
			elif(value+(LoadWeight-_Ammo)>MaxWeight):
				_Ammo = MaxWeight-LoadWeight+_Ammo
				print("New value would have breached MaxCurrentHold")
				return
			else:
				_Ammo = value
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
				
				
	
	def Info():
		return "VictoryResources: "+VictoryResources
