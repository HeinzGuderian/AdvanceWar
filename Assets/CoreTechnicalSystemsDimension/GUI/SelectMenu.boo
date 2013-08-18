import UnityEngine
	
class SelectMenu(MonoBehaviour):
	
	ShowMenu as bool:
		set:
			value = _ShowMenu
		get:
			return _ShowMenu
			
	FirstObjectList as List:
		set:
			_firstObjectList = value
			FirstNumberOfRows = CalculateNumberRows(ObjectRowWidth cast double, (len(_firstObjectList) cast double)+1.0, (MaxMenuWidth/_numberOfMenus) )
			FirstSelectMenuHeight  = CalculateMenuHeight(FirstNumberOfRows, RowHeight, BoxNameHeight)
			
	SecondObjectList as List:
		set:
			_secondObjectList = value
			/*
			for shipAndNumber as duck in shipAndNumberForNewFleet:
				_currentPlayerGUI.PrintToScreen(shipAndNumber[1])
				for times in range(shipAndNumber[1]):
					finalShipList.Add(shipAndNumber[0]) 
			objectTypes = []
			objectTypesNumber = [] 
			for objectType in [objectType1["value"] for objectType1 as Boo.Lang.Hash in _firstObjectList]:
				if objectType not in objectTypes:
					objectTypes.Add(objectType)
				objectTypesNumber.Add(0)
			_objectTypesAndNumber = [object1 for object1 in zip(objectTypes, objectTypesNumber)]
			*/
			
			
	//_objectTypesAndNumber as IEnumerable
	_BuyObjects as List = []
	_ShowMenu as bool = true
	public RowHeight as double = 0
	public BoxNameHeight as double = 0
	public ObjectRowWidth as double  = 0
	public MaxMenuWidth as double  = 0
	public MenuX as double  = 0
	public MenuY as double  = 0
	public FirstNumberOfRows as int = 0
	public FirstSelectMenuHeight as int = 0
	_firstObjectList as List = []
	_secondObjectList as List = []
	_firstSelectObjectList as List = []
	_secondSelectObjectList as List = []
	
	_selectMenuHeight as double = 0
	_numberOfMenus as int = 2
			
	def CalculateNumberRows(objectRowWidth as double, listLength as double, maxMenuWidth as double):
		numberOfRows as int = ((objectRowWidth) * listLength) / maxMenuWidth cast int
		numberOfRows += 1
		return numberOfRows
		
	def CalculateMenuHeight(numberOfRows as double, rowHeight as double, boxNameHeight as double):
		return (((numberOfRows * rowHeight) cast int) + boxNameHeight)
	
	def Awake():
		_ShowMenu = true
		
	/**
	Is meant to run in a def OnGUI and it renders two selection menus and once user
	presses the 'done' button the function returns what was clicked on in the respective
	menues. It desroys itself after the user has pressed done. 
	*/
	public def RunMenu():
		if ShowMenu == false:
			return null
			
		_numberOfMenus = 2

		// Set up first select menu and store any result from the menu
		if _firstObjectList != []:
			firstNumberOfRows as int = CalculateNumberRows(ObjectRowWidth cast double, (len(_firstObjectList) cast double)+1.0, (MaxMenuWidth/_numberOfMenus) )
			firstSelectMenuHeight as double = CalculateMenuHeight(firstNumberOfRows, RowHeight, BoxNameHeight)
			firstRect as Rect = Rect(MenuX, MenuY, (MaxMenuWidth/_numberOfMenus),firstSelectMenuHeight)
			firstMenuResult as List = SelectMenu(_firstObjectList , firstNumberOfRows, firstRect)
			if firstMenuResult != null:
				for item as Boo.Lang.Hash in firstMenuResult:
					if( item not in _firstSelectObjectList):
						_firstSelectObjectList.Add(item)
		
		// Set up second select menu and store any result from the menu
		/*
		if _secondObjectList != []:
			secondNumberOfRows as int = CalculateNumberRows(ObjectRowWidth cast double, (len(_firstObjectList) cast double)+1.0, (MaxMenuWidth/_numberOfMenus) )
			secondSelectMenuHeight as double = CalculateMenuHeight(secondNumberOfRows, RowHeight, BoxNameHeight)
			secondRect as Rect = Rect(MenuX+(MaxMenuWidth/_numberOfMenus)+10, MenuY, (MaxMenuWidth/_numberOfMenus),secondSelectMenuHeight)
			secondMenuResult = SelectMenu(_secondObjectList, secondNumberOfRows, secondRect)
			if secondMenuResult != null:
				for item as Boo.Lang.Hash in secondMenuResult:
					if( item not in _secondSelectObjectList):
						_secondSelectObjectList.Add(item)
		*/
		//GUI.EndGroup()
		if(GUI.Button (Rect (MenuX+ObjectRowWidth-1, firstSelectMenuHeight-RowHeight-10, ObjectRowWidth, RowHeight-5), GUIContent("done") ) ):
			Destroy(self)
			return _firstSelectObjectList		
		return null
	
	def SelectMenu(objectList as List, numberOfRows as int,  rect as Rect) as Boo.Lang.List:
		// Set up box
		GUI.BeginGroup(rect, "SelectMenu")
		GUI.Box(Rect (0, 0, rect.width, rect.height ), "SelectMenu")
		objectsPerRow = [objectHash for objectHash in (objectList as List) ]
		
		clickedObjects as List = []
		objectX = rect.x
		objectY = rect.y
		// Loop through all rows
		for row in range(numberOfRows): 
			objectX = 0
			// Loops through each slot in the row
			
			if len(objectsPerRow) < 3:
				objectsPerRow = objectsPerRow[:(len(objectsPerRow))]
			for objectHash as Boo.Lang.Hash in objectsPerRow[:3]: 
				currentHash as Boo.Lang.Hash
				// Get the hash of the current slot for copy
				for hashToCopy as Boo.Lang.Hash in objectList:
					if hashToCopy == objectHash:
						currentHash = hashToCopy
				// If you click the button you add one object from that type
				if(GUI.Button (Rect (objectX, objectY, ObjectRowWidth, RowHeight-5), objectHash["GUIContent"] as GUIContent ) ):
					clickedObjects.Add( currentHash.Clone() )
				objectX = objectX + ObjectRowWidth
			objectY = objectY + RowHeight
			objectsPerRow = objectsPerRow[3:]
		
		GUI.EndGroup()
		if clickedObjects == null:
			return null
		else:
			return clickedObjects
		
	
