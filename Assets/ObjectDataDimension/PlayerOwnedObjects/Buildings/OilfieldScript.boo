import UnityEngine

partial class OilfieldScript (BuildingScript, IVRProducing):
	
	/*
	def Awake():
		InitialiseSerialize(self)
	*/
	override def SetUpImagesProcedure():
		UnitInfoImage = Resources.Load("Textures/tx_ui_refinery_info", Texture)	
		
		
	override def OnGUI():
		if OurDataScript.IsSelected == true:
			GUI.Label(Rect (170,0,128,64), UnitInfoImage,"")
			GUI.Label(Rect (170+5,0+36,128,128), InfoGUI())
		
	def InfoGUI() as string:
		returnString = ""+MaxVRHold+" / "+CurrentVRHold+" (+"+ProducedVRPerTurn+")"
		//return "" 
		return returnString	

	[SerializeField]
	_producedVRPerTurn as int
	ProducedVRPerTurn as int:
		get:
			return _producedVRPerTurn
		set:
			if(value<0):
				print("Error: New ProducedVRPerTurn value is under zero!")
				_producedVRPerTurn = 0
			else:
				_producedVRPerTurn = value
	[SerializeField]
	_currentVRHold as int
	CurrentVRHold as int:
		get:
			return _currentVRHold
		set:
			if(value<0):
				print("Error: New CurrentVRHold value is under zero!")
				_currentVRHold = 0
			elif value > MaxVRHold:
				print("Error: New CurrentVRHold breached MaxVRHold, reducing to max limit!")
				_currentVRHold = MaxVRHold
			else:
				_currentVRHold = value
	[SerializeField]
	_maxVRHold as int
	MaxVRHold as int:
		get:
			return _maxVRHold
		set:
			if(value<0):
				print("Error: New MaxVRHold value is under zero!")
				_maxVRHold = 0
			else:
				_maxVRHold = value
	
	def Actions():
		//return [{"name" : "Buy Troops", "function"  : self.BuyTroops, "requireMouseClick" : 0, "requireSelected" : false}]
		return []
	
	
		
		
		
		
		
