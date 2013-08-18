import UnityEngine
	
class BasicMenu(MonoBehaviour):
	
	ObjectList as List:
		set:
			_objectList = value
			
			NumberOfRows = CalculateNumberRows(ObjectRowWidth cast double, (len(_objectList) cast double)+1.0, MaxMenuWidth )
			SelectMenuHeight  = CalculateMenuHeight(NumberOfRows, RowHeight, BoxNameHeight)
			MenuRect = Rect(MenuX, MenuY, MaxMenuWidth, SelectMenuHeight)
			
			
	public ShowMenu as bool = true
	public MenuName as string = ""
	public RowHeight as double = 0
	public BoxNameHeight as double = 0
	public ObjectRowWidth as double  = 0
	public MaxMenuWidth as double  = 0
	public MenuRect as Rect
	public MenuX as double  = 0
	public MenuY as double  = 0
	public NumberOfRows as int = 0
	public SelectMenuHeight as int = 0
	public MenuItemCode as MenuItemCallable 
	public ClickedObjects as List = []
	_library as LibraryScript
	
	public callable MenuItemCallable(ref currentHash as object ,ref returnValues as List)
	
	_menuRect as Rect
	_objectList as List = []
	_selectObjectList as List = []
	_selectMenuHeight as double = 0
	
	def Awake():
		_library = (GameObject.Find('GameRules').GetComponent[of LibraryScript]() as LibraryScript)
	
	static def SetupBasicMenu(ref basicMenu as BasicMenu, MenuName as string, objectList as List, x as int, y as int, maxMenuWidth as int, callingObject as GameObject, itemCodeBlock as MenuItemCallable):
		//BuyMenu as BuyMenu = gameObject.GetComponent[of BuyMenu]()
		basicMenu.MenuName = MenuName
		basicMenu.MenuX = x
		basicMenu.MenuY = y
		basicMenu.MaxMenuWidth = maxMenuWidth 
		basicMenu.RowHeight = 30.0
		basicMenu.BoxNameHeight = 30.0
		basicMenu.ObjectRowWidth = 80.0
		basicMenu.MenuItemCode = itemCodeBlock

		basicMenu.ObjectList = objectList // First Object must be set last, it resets MaxMenuwidht
		return void
		
	static def SetupBasicMenu(ref basicMenu as BasicMenu, MenuName as string, objectList as List, x as int, y as int, maxMenuWidth as int, 	objectRowWidth as int, rowHeight as int, callingObject as GameObject, itemCodeBlock as MenuItemCallable):
		//BuyMenu as BuyMenu = gameObject.GetComponent[of BuyMenu]()
		basicMenu.MenuName = MenuName
		basicMenu.MenuX = x
		basicMenu.MenuY = y
		basicMenu.MaxMenuWidth = maxMenuWidth 
		basicMenu.RowHeight = rowHeight
		basicMenu.BoxNameHeight = 30.0
		basicMenu.MenuItemCode = itemCodeBlock
		basicMenu.ObjectRowWidth = objectRowWidth
		basicMenu.ObjectList = objectList // First Object must be set last, it resets MaxMenuwidht
		return void
			
			
	def CalculateNumberRows(objectRowWidth as double, listLength as double, maxMenuWidth as double):
		numberOfRows as int = ((objectRowWidth) * listLength) / maxMenuWidth cast int
		numberOfRows += 1
		return numberOfRows
		
	def CalculateMenuHeight(numberOfRows as double, rowHeight as double, boxNameHeight as double):
		return (((numberOfRows * rowHeight) cast int) + boxNameHeight)
	
	
	struct BasicMenuItemStruct:
		GUIDisplay as GUIContent
		ItemsValue as object
	
	/**
	Is meant to run in a def OnGUI and it renders two selection menus and once user
	presses the 'done' button the function returns what was clicked on in the respective
	menues. It desroys itself after the user has pressed done. 
	*/
	def RunMenu():
		if ShowMenu == false:
			return null
			
		NumberOfRows = CalculateNumberRows (ObjectRowWidth cast double, (len(_objectList) cast double)+1.0, MaxMenuWidth)
		
		
		SelectMenuHeight = CalculateMenuHeight(NumberOfRows, RowHeight, BoxNameHeight)
		GUI.BeginGroup(Rect (MenuX, MenuY,MaxMenuWidth,SelectMenuHeight))
		//GUI.Box(Rect (0, 0,MaxMenuWidth,basicMenuHeight),"")
		
		objectsOnRow = [objectHash for objectHash in (_objectList as List) ]
		objectsPerRowInt = MaxMenuWidth/ObjectRowWidth

		objectY = 0
		
		// Loop through all rows
		for row in range(NumberOfRows): 
			objectX = 0
			// Loops through each slot in the row
			//if len(objectsPerRow) < 3:
			//	objectsPerRow = objectsPerRow[:(len(objectsPerRow))]
			for objectHash as BasicMenuItemStruct in objectsOnRow[:objectsPerRowInt]: 
				
				/*
				currentHash as Boo.Lang.Hash
				// Get the hash of the current slot for copy
				for hashToCopy as Boo.Lang.Hash in _objectList:
					if hashToCopy == objectHash:
						currentHash = hashToCopy
				*/
				// If you click the button you add one object from that type
				itemRect as Rect = Rect(objectX, objectY, ObjectRowWidth, RowHeight ) 
				GUI.BeginGroup(itemRect)
				MenuItemCode( objectHash.ItemsValue , ClickedObjects)
				GUI.EndGroup()
				objectX = objectX + ObjectRowWidth
			objectY = objectY + RowHeight
			objectsOnRow = objectsOnRow[objectsPerRowInt:]
		
		GUI.EndGroup()
		return ClickedObjects
		/*
		if clickedObjects == null:
			return null
		else:
			return clickedObjects
			*/
		/*
	virtual def MenuItemBody(ref currentHash as Boo.Lang.Hash ,ref returnValues as List):
		if(GUI.Button (Rect (objectX, objectY, ObjectRowWidth, RowHeight-5), objectHash["GUIContent"] as GUIContent ) ):
			returnValues.Add( currentHash.Clone() )
			*/