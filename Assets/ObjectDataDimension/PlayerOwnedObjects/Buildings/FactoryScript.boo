import UnityEngine

partial class FactoryScript (BuildingScript):
	_produceObjects as List = null
	
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
		return ""
			
	ProduceObjects as List:
		get:
			return ProduceObjects
		set:
			assert value != null and value != []
			_produceObjects = value
			
	def Info():
		return "ArmyEconomy"
	
	def Actions():
		return []
		//return [{"name" : "Buy Troops", "function"  : self.BuyTroops, "requireMouseClick" : 0, "requireSelected" : false}]
	
	def Start():
		super()
		playerScript = _gameState.FindPlayerScript(_currentOwner)
		assert playerScript != null
		_produceObjects = playerScript.AvailableTroops
		assert _produceObjects != []
		
		
		
		
