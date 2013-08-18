import UnityEngine
	
class BuyMenu(MonoBehaviour):
	
	ShowMenu as bool:
		set:
			value = _ShowMenu
		get:
			return _ShowMenu
			
	BuyObjects as List:
		set:
			value = _BuyObjects
		get:
			return _BuyObjects
			
	ObjectList as List:
		set:
			objectList = List(value)
			/*
			for shipAndNumber as duck in shipAndNumberForNewFleet:
				_currentPlayerGUI.PrintToScreen(shipAndNumber[1])
				for times in range(shipAndNumber[1]):
					finalShipList.Add(shipAndNumber[0]) 
			objectTypes = []
			objectTypesNumber = [] 
			for objectType in [objectType1["value"] for objectType1 as Boo.Lang.Hash in objectList]:
				if objectType not in objectTypes:
					objectTypes.Add(objectType)
				objectTypesNumber.Add(0)
			_objectTypesAndNumber = [object1 for object1 in zip(objectTypes, objectTypesNumber)]
			*/
			
			
	//_objectTypesAndNumber as IEnumerable
	_boughtShipList as List = []
	_BuyObjects as List = []
	_ShowMenu as bool = true
	public rowHeight as double = 0
	public boxNameHeight as double = 0
	public objectRowWidth as double  = 0
	public maxMenuWidth as double  = 0
	public menuX as double  = 0
	public menuY as double  = 0
	objectList as List = []
	numberOfRows as int = 0
	selectMenuHeight as double = 0
			
	def calculateNumberRows(ObjectRowWidth as double, listLength as double, maxMenuWidth as double):
		numberOfRows as int = ((ObjectRowWidth) * listLength) / maxMenuWidth cast int
		numberOfRows += 1
		return numberOfRows
		
	def calculateMenuHeight(numberOfRows as double, rowHeight as double, boxNameHeight as double, plusAndMinusAndIndexCountHeight as double):
		return (((numberOfRows * rowHeight) cast int) + boxNameHeight + plusAndMinusAndIndexCountHeight)
	
	def Awake():
		_ShowMenu = true
		
	def RunMenu():
		if ShowMenu == false:
			return null
		
		numberOfRows as int = calculateNumberRows (objectRowWidth cast double, (len(objectList) cast double)+1.0, maxMenuWidth)
		plusAndMinusAndIndexCountHeight = 20.0
		plusAndMinusAndIndexCountWidth = objectRowWidth/3
		selectMenuHeight as double = calculateMenuHeight(numberOfRows, rowHeight, boxNameHeight, plusAndMinusAndIndexCountHeight)
		GUI.BeginGroup(Rect (menuX, menuY,maxMenuWidth,selectMenuHeight), "BuyMenu")
		GUI.Box(Rect (0, 0,maxMenuWidth,selectMenuHeight), "BuyMenu")
		objectsPerRow = [objectHash for objectHash in (objectList as List) ]
		
		objectX = menuX
		objectY = menuY
		for row in range(numberOfRows):
			objectX = 0
			for objectHash as Boo.Lang.Hash in objectsPerRow[:3]: // Collum
				currentHash as Boo.Lang.Hash
				for hashToCopy as Boo.Lang.Hash in objectList:
					if hashToCopy == objectHash:
						currentHash = hashToCopy
				// Add Plus button
				if(GUI.Button (Rect (objectX, objectY-plusAndMinusAndIndexCountHeight, plusAndMinusAndIndexCountWidth, plusAndMinusAndIndexCountHeight), GUIContent(" + ") ) ): 
					_boughtShipList.Add( currentHash.Clone() )
				// Create Minus button 
				if(GUI.Button (Rect (objectX+plusAndMinusAndIndexCountWidth, objectY-plusAndMinusAndIndexCountHeight, plusAndMinusAndIndexCountWidth, plusAndMinusAndIndexCountHeight), GUIContent(" - ") ) ): 
					_boughtShipList.Remove(currentHash)
				// Create label to view how many of the object you have bought
				GUI.Label(Rect (objectX+plusAndMinusAndIndexCountWidth*2, objectY-plusAndMinusAndIndexCountHeight, plusAndMinusAndIndexCountWidth, plusAndMinusAndIndexCountHeight), (len([item for item in _boughtShipList if item==currentHash]).ToString())  )   
				// If you click the button you add one object from that type
				if(GUI.Button (Rect (objectX, objectY, objectRowWidth, rowHeight-5), objectHash["GUIContent"] as GUIContent ) ):
					_boughtShipList.Add( currentHash.Clone() )
				objectX = objectX + objectRowWidth
			objectY = objectY + rowHeight
			objectsPerRow = objectsPerRow[3:]
		if(GUI.Button (Rect (maxMenuWidth-objectRowWidth-1, selectMenuHeight-rowHeight-10, objectRowWidth, rowHeight-5), GUIContent("Buy") ) ):
			GUI.EndGroup()
			if _boughtShipList != []:
				Destroy(self)
				return _boughtShipList
			else:
				return null
		GUI.EndGroup()
		return null
		
	