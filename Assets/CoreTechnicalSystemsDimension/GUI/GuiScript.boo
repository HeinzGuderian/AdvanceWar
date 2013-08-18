import UnityEngine


/**
Class that holds all GUI related for each camera
*/
class GuiScript(MonoBehaviour, IGameState):
	_handleSelect = false
	_selectTarget = false
	_selectedParent as GameObject = null
	_selectedGameObjectChildrenContainers as List = []   // Used to cache for the main gui loop, only store containers!
	_childGameObjectIDATAList as List = []				 // Used to cache IDataList
	_iguis as List = []									 // Contains the gui the selcted gameobject and its children
	waitingFunction as System.Collections.Hashtable = {} // Holds a function untill the user had clicked on something
	needToSelect as bool = false  						 // Refers to if user need to click on a spaceObject
	waitingForMouseClicked as System.Int32				 // Number of mouse clicks required
	//player as PlayerScript								 // The _player that this guiScript serves
	info as string 	= ""							 // The info from the selected  object
	final BUTTON_HEIGHT = 20
	library as LibraryScript
	_gameState as GameState
	selected as GameObject
	oldSelected as GameObject // Used for check if the user has selected a new spaceObject
	_selectedOurUnit as bool// _selectedOurUnit will also be true if we selected a none team object, like terrain
	final _menuName as string = "Unit Actions:"
	_functionList as List = []
	_touchscript as OnTouchDown 
	SelectedGameObjectMenu as BasicMenu = null
	SelectedGameObjectMenuTest as BasicMenu = null
	
	DisableGUI = false
	
	EndTurnButton as Texture
	MenuButton as Texture
	MenuCloseButton as Texture
	ExitButton as Texture
	OkayButton as Texture
	UnitInfoImage as Texture
	GlobalInfoImage as Texture
	OutputBoxImage as Texture
	SurrenderButton as Texture
	GUIUnitInfoCode as callable
	
	_currentPlayerGUI as GuiScript
	_outputString as string = ""
	_inMenu as bool = false
	_currentPlayerScript as PlayerScript
	_marker as GameObject = null
	
	_askConcede = false;
	def Awake():
		//_player = GetComponent[of PlayerScript]()
		SelectedGameObjectMenu = gameObject.AddComponent[of BasicMenu]()
		SelectedGameObjectMenuTest = gameObject.AddComponent[of BasicMenu]()
		waitingForMouseClicked = 0
		selected = null

		_currentPlayerGUI = self
	
	
	def Start ():
		_gameState = GameObject.Find('GameRules').GetComponent[of GameState]()
		library = GameObject.Find('GameRules').GetComponent[of LibraryScript]()
		_touchscript = GameObject.Find('GameRules').GetComponent[of OnTouchDown]()
		_currentPlayerScript = _gameState.FindPlayerScript(_gameState.WhosTurn)
		EndTurnButton = Resources.Load("Textures/Buttons/tx_button_endturn", Texture)
		MenuButton = Resources.Load("Textures/Buttons/tx_buttonMenuMenu", Texture)
		MenuCloseButton = Resources.Load("Textures/Buttons/tx_buttonMenuClose", Texture)
		ExitButton = Resources.Load("Textures/Buttons/tx_buttonMenuExit", Texture)
		OkayButton = Resources.Load("Textures/Buttons/tx_button_OK_large", Texture)
		UnitInfoImage = Resources.Load("Textures/tx_ui_selected_unit_indicator", Texture)
		GlobalInfoImage = Resources.Load("Textures/tx_resourceindicator", Texture)
		OutputBoxImage = Resources.Load("Textures/tx_ui_outputbox", Texture)
		SurrenderButton = Resources.Load("Textures/Buttons/tx_buttonMenuSurrender", Texture)
		
		
		SetupList()
		checkInit()
		
	def checkInit():
		if _gameState==null:
			print("_gameState is null")
		if library==null:
			print("library is null")
		//if _player ==null:
		//	_currentPlayerGUI.PrintToScreen("_player is null")
		if SelectedGameObjectMenu==null:
			print("SelectedGameObjectMenu is null")
			
	def PrintToScreen(textString as string):
		_outputString = textString
		
	def EndTurnActions():
		SetSelected(null)
		
	def StartTurnActions():
		SetSelected(null)
	
	def GetSelected():
		return selected
		
	def UpdateInfo(infoObjects as List) as string:
		returnString = ""
		for component as IGUI in infoObjects:
			if component isa TroopClass:
				returnString += component.Info()
		return returnString
	
	def UpdateFunctionList(newFunctionList as List):
		pass
		
	
	def SetSelected(newSelected as GameObject):
		// C#
		/*
		l as GUILayer = Camera.main.GetComponent(typeof(GUILayer)) as GUILayer;
		ele as GUIElement = l.HitTest(Input.mousePosition);
		ele1 as GUIElement = null;
		if(Input.touchCount > 0):
			ele1 = l.HitTest(Input.GetTouch(0).position);
		
		if(ele != null or ele1 != null):
			return 
		
		else:
			pass
		*/
		_iguis.Clear()
		_selectedGameObjectChildrenContainers.Clear()
		_childGameObjectIDATAList.Clear()
		//_info = ""
		_selectedOurUnit = true
		/*
		if oldSelected != null and oldSelected.GetComponent[of DataScript]() != null:
			oldSelected.GetComponent[of DataScript]().IsSelected = false
		*/	
			
		//oldSelected = selected
		
		if selected != null and selected.GetComponent[of DataScript]() != null:
			selected.GetComponent[of DataScript]().IsSelected = false
		
		selected = newSelected
		if selected != null:
			if newSelected.GetComponent[of DataScript]() != null:
				newSelected.GetComponent[of DataScript]().IsSelected = true
			if _marker != null:
				
				Destroy(_marker)
			//if (selected.GetComponents[of DataScript]() as DataScript).GameObjectType == DataScript.GameObjectTypeEnum.unit:
			_marker = Instantiate(UnityEngine.Resources.Load('Effects/IndicatorSelectedFriendlyPreFab'), selected.transform.position, Quaternion.identity)
		
			// Go through the selected gameobject container children, armys, flets etc etc. Not single units like troops or ships
			for childGameObject as GameObject in [child.gameObject for child as Transform in newSelected.transform]:
				if childGameObject.transform.childCount > 0:
					_selectedGameObjectChildrenContainers.Add(childGameObject)
					// Cache its IData components once. 
					_childGameObjectIDATAList.Add(childGameObject.GetComponent("IData"))
			for component in newSelected.GetComponents[of MonoBehaviour]():
				if component isa IGUI:
					_iguis.Add(component)
			teamScript as TeamScript = TeamScript.FindTeamScript(newSelected)
			if teamScript == null:
				_selectedOurUnit = false
			elif( true == teamScript.CanPlay()  ):
				_selectedOurUnit = true
			else:
				_selectedOurUnit = false
			//_info = UpdateInfo(_iguis)
			
			_functionList.Clear()
			// Gather all functions in all the scripts of the selected object
			for iguiScript in _iguis:
				// Repack to BasicMenu accpeted format
				_functionList.Extend( [BasicMenu.BasicMenuItemStruct( ItemsValue:item ) for item as Boo.Lang.Hash in (iguiScript as IGUI).Actions() ] )
				//_functionList.Extend( (iguiScript as IGUI).Actions() )
			
			BasicMenu.SetupBasicMenu(SelectedGameObjectMenu, _menuName, _functionList, 10, 0, 160, 150, 50, gameObject, self.UICodeForFunctions)
			//BasicMenu.SetupBasicMenu(SelectedGameObjectMenuTest, _menuName, _functionList, 110, 110, 100, 80, 20, gameObject, self.UICodeForFunctions)
			_currentPlayerScript = _gameState.FindPlayerScript(_gameState.WhosTurn)
			assert _currentPlayerScript != null
			/*
			for component as IGUI in _iguis:
				_info += component.Info()
			*/
			if(newSelected.transform.parent != null):
				_selectedParent = newSelected.transform.parent.gameObject
			else:
				_selectedParent = null
				
			if _selectTarget == true:
				_handleSelect = true
				_selectTarget = false
				
			
		
	//listEntry = 0 // The selection made if the seleceted object has a list to display.
	//listStyle as GUIStyle
	
	/// Magic
	def SetupList():
		// Make a GUIStyle that has a solid white hover/onHover background to indicate highlighted items
		listStyle = GUIStyle()
		listStyle.normal.textColor = Color.white
		tex = Texture2D(2, 2)
		colors as System.Array = array(Color, 4)
		
		for color as Color in colors:
			color = Color.white
			
		tex.SetPixels(colors)
		tex.Apply()
		listStyle.hover.background = tex
		listStyle.onHover.background = tex
		listStyle.padding.left = listStyle.padding.right = listStyle.padding.top = listStyle.padding.bottom = 4
		return listStyle
		

	
	def Update():
		newVector as Vector3 // The mouselocation when the user pressed mouse button 1.
		waitingObject as MonoBehaviour // The object that is to execute a waiting fucntion after a mouselcik has been recived
		//tempSelect as GameObject
		// If the user has selected a new object and if we are waiting for a object to select
		if _handleSelect == true:
			_handleSelect = false
			_selectTarget = false
			if Input.GetButtonDown("Fire1") == true and needToSelect == true: // and hasSelectedChange() == true	
				// Get the position where the user clicked and execute the function on the stored object
				//waitingObject = waitingFunction["object"]
				if(waitingFunction.ContainsKey("ShouldRevertWaitFunction") and waitingFunction["ShouldRevertWaitFunction"] == true ):	
					(waitingFunction["RevertWaitFunction"] as callable)(selected)
					//StartCoroutine((waitingFunction["RevertWaitFunction"] as callable)(selected) as System.Collections.IEnumerator)
				StartCoroutine((waitingFunction["function"] as callable)(selected) as System.Collections.IEnumerator)
				//(waitingFunction["function"] as callable)(selected)
				//(waitingFunction["name"] as callable)(selected)
				// Reseting variables
				needToSelect=false
				waitingObject = null
				waitingFunction={}	
				SetNeededMouseClicks(0)	
				_handleSelect = false
				//SetSelected(oldSelected)
				
			// If the user has clicked on a position
			elif (Input.GetButtonDown("Fire1") and GetNeededMouseClicks() != 0):
				// Get the position where the user clicked and execute the function on the stored object
				newVector = Camera.main.ScreenToWorldPoint ( Vector3(Input.mousePosition.x,Input.mousePosition.y, _gameState.Z_SCREEN_POSITION_VALUE))
				//_currentPlayerGUI.PrintToScreen(newVector);		
				waitingObject = waitingFunction["object"]
				//(waitingFunction["object"] as duck).StartCourouting()
				if(waitingFunction.ContainsKey("ShouldRevertWaitFunction") and waitingFunction["ShouldRevertWaitFunction"] == true ):	
					(waitingFunction["RevertWaitFunction"] as callable)(selected)
				StartCoroutine((waitingFunction["function"] as callable)(selected) as System.Collections.IEnumerator)
				//(waitingFunction["name"] as callable)(newVector)
				//waitingObject.SendMessage(waitingFunction["name"] as System.String, newVector)
				// Reseting variables
				waitingObject = null
				waitingFunction={}
				SetNeededMouseClicks(0)
				_handleSelect = false
				//SetSelected(oldSelected)
				//SetSelected(selected)
			
	
	
	def SetNeededMouseClicks(newValue):
		waitingForMouseClicked= newValue

	def GetNeededMouseClicks():
		return waitingForMouseClicked
		
	
	def hasSelectedChange():
		if oldSelected != selected:
			return true
		else:
			return false
/* Not needed in this game
	def CreateHandleDropDownList(functionHash as Boo.Lang.Hash, rec as Rect, showDropDown as bool ):
		listArray as System.Array = array(GUIContent, ([listItem["GUIContent"] for listItem as Boo.Lang.Hash in ((functionHash as Boo.Lang.Hash)["list"] as List)] as System.Collections.IEnumerable ))
		picked = false
		listStyle = SetupList()
		listEntry as int = 0
		if(Popup.List (rec, showDropDown, listEntry, GUIContent(functionHash["name"] as System.String), listArray, listStyle)):
			//_currentPlayerGUI.PrintToScreen("g")
			picked = true
			//choice as string = (listArray[listEntry] as GUIContent).text
			choice = ((functionHash["list"] as List)[listEntry] as Boo.Lang.Hash)["value"]
			selected.SendMessage(functionHash["function"],choice)
		return showDropDown;
*/
	

	def UICodeForFunctions(ref currentHash as Boo.Lang.Hash ,ref returnValues as List) as void:
		if(GUI.Button (Rect (0,0,152,52), GUIContent(currentHash["image"] as Texture ), "")):// (currentHash as Boo.Lang.Hash)["name"] as System.String ) ):	
			needToHandleMouse = false
			needToHandleMouse = CheckIfMouseInputIsNeeded(currentHash)
			//needToHandleMouse = HandleMouseIfNeeded(functions[index]) // Stores function if mouse need to be handled	
			if needToHandleMouse == false:
				((currentHash as Boo.Lang.Hash)["function"] as callable)()
				//selected.SendMessage(functions[index]["function"],null)	
			else:
				HandleMouseInput(currentHash)
					
	def CheckIfMouseInputIsNeeded(functionHash as Boo.Lang.Hash):
		// Check if the function need mouse click input
		if(functionHash.ContainsKey("requireMouseClick") and functionHash["requireMouseClick"] != 0 ):
			// Return that we needed to wait for mouse input
			return true
		// Check if the function need a object selectes as argument
		elif (functionHash.ContainsKey("requireSelected") and functionHash["requireSelected"] == true):
			// Return that we needed to wait for mouse input
			return true
		// else return false, indicating we don't need to wait for mouse input	
		else:
			return false
			
	def HandleMouseInput(functionHash as Boo.Lang.Hash):
		
		// Check if the function need mouse click input
		if(functionHash.ContainsKey("requireMouseClick") and functionHash["requireMouseClick"] != 0 ):
			// If so mark this and store the function
			SetNeededMouseClicks(functionHash["requireMouseClick"])
			waitingFunction["name"] = functionHash["name"] as callable
			waitingFunction["function"] = functionHash["function"] as callable
			waitingFunction["object"]= functionHash["object"]
		// Check if the function need a object selectes as argument
		elif (functionHash.ContainsKey("requireSelected") and functionHash["requireSelected"] == true):
			// If so mark this and store the function
			needToSelect = true			
			waitingFunction["name"] = functionHash["name"] 
			waitingFunction["function"] = functionHash["function"] as callable 
			waitingFunction["object"]=functionHash["object"]	
		else:
			return
		_selectTarget = true
		if(functionHash.ContainsKey("RunWaitFunction") and functionHash["RunWaitFunction"] == true ):	
			waitingFunction["RunnedWaitFunction"] = true
			(functionHash["WaitFunction"] as callable)()
			if(functionHash.ContainsKey("ShouldRevertWaitFunction") and functionHash["ShouldRevertWaitFunction"] == true ):
				waitingFunction["ShouldRevertWaitFunction"] = true
				waitingFunction["RevertWaitFunction"]=functionHash["RevertWaitFunction"]
	
	struct Box:
		def constructor(rec as Rect, name as string):
			_rec = rec
			_name = name
		_rec as Rect
		_name as string
		  
	//"Rect": Rect (30,30,maxMenuWidth,selectMenuHeight), "name": "SelectMenu"
    	
	
	showListArray as (bool) 
	showDerp as bool = true
	showList as List = []
	oldFunctions as List = []
	functions as List
	lastShowList as (bool) = array(bool, 1) // need initatilation value so that show list and lastShowList is not equal on first iteration
	//showSelectMenu as (bool)
	//lastShowSelectMenu as (bool) = array(bool, 1)
	//showList = false
	showSelectMenu as List = []

		
	
	def OnGUI(): 	
		// Make a background box
		//GUI.Box (Rect (10,10,100,90), "Box")	
		// Display info about _player 
		//GUI.Label(Rect (250,200,80,20), _player.Info())	
		// Display whos turn
		//GUI.Label(Rect (250,220,100,50), _gameState.WhosTurn + " Turn")
		
		if _gameState.EnemyHaveConceded == true:
			DisableGUI = true
			GUI.Label(Rect(Screen.width/2, Screen.height-200, 200, 60), "Enemy has conceded the game!")
			if GUI.Button(Rect(Screen.width/2, Screen.height-140, 200, 140), "Back to menu", ""):
				_gameState.gameObject.GetComponent[of PostWEB]().SendDataStandard("RemoveGame", _gameState.GameID, {}, null)
				DisableGUI = false
				_gameState.LoadLevel("mainMenu")
		_touchscript.RayCasts(Rect(SelectedGameObjectMenu.MenuX, SelectedGameObjectMenu.MenuY, SelectedGameObjectMenu.MaxMenuWidth , SelectedGameObjectMenu.SelectMenuHeight))
		if DisableGUI != true:
			
			// End turn button
			if (GUI.Button (Rect (Screen.width-150,0,150,50),GUIContent(EndTurnButton), "")):
				_gameState.StartCoroutine("CheckAndEndTurn",null)  
				_currentPlayerScript = _gameState.FindPlayerScript(_gameState.WhosTurn)
			// Player info
			//GlobalInfoString as string = ""
			//GlobalInfoString += "Current Player turn: " + _gameState.WhosTurn.ToString() + " Turn: " + _gameState.TurnNumber.ToString() + "\n"
			//GlobalInfoString += "Victory Resources: " + _currentPlayerScript.VictoryResources + " Universal Resources: " +  _currentPlayerScript.UniversalResources
			//GUIUnitInfoCode()
			GUI.Label(Rect (170+128,0,128,64), GlobalInfoImage)
			xOffset1 = 60
			currentUR = _currentPlayerScript.UniversalResources
			currentVR = _currentPlayerScript.VictoryResources
			GUI.Label(Rect (170+128+xOffset1,0+6,100,25),  _gameState.WhosTurn.ToString() + "/"+ _gameState.TurnNumber.ToString() )
			GUI.Label(Rect (170+128+xOffset1,0+22,50,25),  currentUR.ToString()) 
			GUI.Label(Rect (170+128+xOffset1,0+35,50,20),  currentVR.ToString() )
			// If the user has selected a gameobject is selected, display all actions and info for it
			if selected != null and _inMenu == false:
				// Display info about selected object	
				//Screen.height		
				/* FActored out, is now handled by TroopClass to aviod ardcoding gui in this file
				//_info = UpdateInfo(_iguis)
				//sizeOfLabel as Vector2 = GUIStyle.CalcSize(GUIContent(_info));
				
				if _info != "":
					pass
					
				else:
				  	GUI.Label(Rect (20,40,80,20), "No info available")
				*/
				// loop through all actions of the selected object
				if(_functionList != null and SelectedGameObjectMenu != null):
					if( true == _selectedOurUnit ): // _selectedOurUnit will also be true if we selected a none team object, like terrain
						SelectedGameObjectMenu.RunMenu()
						//SelectedGameObjectMenuTest.RunMenu()
				if _outputString != "":
					if (GUI.Button (Rect(100+434, 100+202, 70, 50),"", "" )):
						_outputString = ""
						
					GUI.Button(Rect(100, 100, 512, 256),GUIContent(OutputBoxImage),"")
					GUI.Label(Rect(150, 150, 400, 400), _outputString)
					
				if _outputString != "":
					GUI.Label(Rect(200, Screen.height-200, 100, 100), _outputString, "")
					if (GUI.Button (Rect(100+434, 100+202, 70, 50),GUIContent(OkayButton), "" )):
						_outputString = ""	
						
			/*if GUI.Button(Rect(600, 20, 100, 70), "Menu"):
				_inMenu = true
			if _inMenu == true:
				if GUI.Button(Rect(400, 200, 100, 70), "Exit Game."):
					Application.Quit()
				if GUI.Button(Rect(400, 270, 100, 70), "Close Menu"):
					_inMenu = false
			*/
			
			if GUI.Button(Rect(Screen.width - 100, Screen.height-70, 100, 70), GUIContent(MenuButton), ""):
				_inMenu = true
			if _inMenu == true:
				if GUI.Button(Rect(Screen.width - 100, Screen.height-70*2, 100, 70), GUIContent(ExitButton), ""):
					//_gameState.DeleteGameHook()
					_gameState.LoadLevel("mainMenu")
					
				if GUI.Button(Rect(Screen.width - 100, Screen.height-70*3, 100, 70), SurrenderButton, ""):
					_askConcede = true
				if true == _askConcede: 
					GUI.Label(Rect(200, 200, 200, 60), "Really concede game?")
					if GUI.Button(Rect(200, 260, 100, 60), "Yes"):
							
						if TeamScript.PlayerNumberEnum.player1 == _gameState.WhosTurn: 	
							_gameState._player2HaveWon = true
							_gameState._player1HaveConcede = true
						
						elif TeamScript.PlayerNumberEnum.player2 == _gameState.WhosTurn: 
							_gameState._player1HaveWon = true
							_gameState._player2HaveConcede = true
			
						_gameState.HaveWon = false
						_gameState.HaveConceded = true
						_gameState.EndTurn()
					if GUI.Button(Rect(300, 260, 100, 60), "No"):
						_askConcede = false
								
				if GUI.Button(Rect(Screen.width - 100, Screen.height-70*4, 100, 70), GUIContent(MenuCloseButton), ""):
					_inMenu = false			
		_touchscript.RayCasts(Rect(SelectedGameObjectMenu.MenuX, SelectedGameObjectMenu.MenuY, SelectedGameObjectMenu.MaxMenuWidth , SelectedGameObjectMenu.SelectMenuHeight))
			

