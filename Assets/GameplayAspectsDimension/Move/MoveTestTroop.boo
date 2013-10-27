import UnityEngine

class MoveTestTroop (MonoBehaviour, IGUI, IGameState): 
	//_hasPlayedTurn as bool
	_library as LibraryScript
	_testInfantryData as DataScript
	_testInfantryTroop as TroopClass
	_highlightedTerrains as List = []
	_currentPlayerGUI as GuiScript
	
	//_moveImage as Texture //= Resources.Load("Textures/tx_button_move")
	ButtonImage as Texture
	
	final _baseMoveActionCost as int = 25
	private final AREA_OCCUPIED as string = "The area is occupied."
	private final ALREADY_MOVED as string = "This unit has already moved"
	private final TO_FEW_AP_LEFT as string = "This unit has to few actionpoints"
	private final NOT_ENOUGH_PETROL as string = "Not enough petrol."
	private final MOVE_TO_FAR as string = "This unit tried to mvoe to far, only one grid allowed at a time"
	private final CLICK_ON_A_TERRAIN as string = "You must click on an unoccupied terrain"
	private final CLICKED_ON_A_TROOP as string = "You clicked on a troop"
	

	def Actions():
		//actions = [{"name"  : "Move", "object": self as MonoBehaviour, "function"  : self.Move as callable , "requireMouseClick" : 0, "requireSelected" : true }]//, "RunWaitFunction" : true ,"WaitFunction": self.HighlightMovableTerrain,"ShouldRevertWaitFunction":true, "RevertWaitFunction": self.DeHighlightMovableTerrain}]
		actions = [{"name"  : "Move", "image" : ButtonImage, "object": self as MonoBehaviour, "function"  : self.Move as callable , "requireMouseClick" : 0, "requireSelected" : true , "RunWaitFunction" : true ,"WaitFunction": self.HighlightMovableTerrain,"ShouldRevertWaitFunction":true, "RevertWaitFunction": self.DeHighlightMovableTerrain}]
		
		/*
		for action in [army.Actions() for army in gameObject.GetComponentsInChildren[of ArmyMove]() ]:
			actions.Extend(action)
		*/
		return actions
	
	def Info():
		return ""
		
	/*def Start():
		currentTerrainGameObject = _library.FindTerrain(gameObject.transform.position)
		assert currentTerrainGameObject != null
		assert _testInfantryTroop.OccupiedTerrainGameObject != null
		assert _testInfantryTroop.OccupiedTerrain != null
		_testInfantryTroop.OccupiedTerrainGameObject = currentTerrainGameObject
		_testInfantryTroop.OccupiedTerrain = currentTerrainGameObject.GetComponent("ITerrain")
		
		currentTerrain = _testInfantryTroop.OccupiedTerrain
		assert currentTerrain != null
		currentTerrain.AddUnit(gameObject)
		currentTerrain.IsOccupied = true
*/
	def Awake ():
		_library = (GameObject.Find('GameRules').GetComponent[of LibraryScript]() as LibraryScript)	
		
		_testInfantryTroop = gameObject.GetComponent[of TroopClass]()
		assert _testInfantryTroop != null
		
		_testInfantryData = gameObject.GetComponent("IData")
		currentPlayersGameObject = _library.FindCamera()
		_currentPlayerGUI = currentPlayersGameObject.GetComponent[of GuiScript]()
		
		ButtonImage = Resources.Load("Textures/Buttons/tx_button_move", Texture)
		// Start Code -v-
		currentTerrainGameObject = _library.FindTerrain(gameObject.transform.position)
		assert currentTerrainGameObject != null
		_testInfantryTroop.OccupiedTerrainGameObject = currentTerrainGameObject
		assert _testInfantryTroop.OccupiedTerrainGameObject != null
		_testInfantryTroop.OccupiedTerrain = currentTerrainGameObject.GetComponent("ITerrain")
		assert _testInfantryTroop.OccupiedTerrain != null
		
		
		
		currentTerrain = _testInfantryTroop.OccupiedTerrain
		assert currentTerrain != null
		currentTerrain.AddUnit(gameObject)
		currentTerrain.IsOccupied = true
		//a = _moveImage
		//b = 3
		//_hasPlayedTurn = false
	
	def checkInit():
		if _library==null:
			print("MoveTestTroop library is null")
		if _testInfantryData==null:
			print("MoveTestTroop _testInfantryData is null")
		if _testInfantryTroop==null:
			print("MoveTestTroop _testInfantryTroop is null")
		if _testInfantryTroop.OccupiedTerrain==null:
			print("MoveTestTroop _testInfantryTroop.OccupiedTerrain is null")
	
	def Update ():	
		pass
			
	def OnGUI():
		pass
		
	def StartTurnActions():
		return
		
	def EndTurnActions():
		return //_hasPlayedTurn = false
		
	/*
	Orchester function for move.
	checks that the move target appeasrs valid, construts a path and calls the moveOneTerrain on each terrain.
	Also after each move calls AllowedToMove on affected objects. 
	*/	
	def Move(targetTerrain as GameObject) as System.Collections.IEnumerator:
		// if user clicked on a troop, display text, reset flags, break.
		if(targetTerrain.GetComponent("TroopClass") != null):
			_currentPlayerGUI.PrintToScreen(CLICKED_ON_A_TROOP)
			return 
			
		// check that the user clicked on terrain and not a unit
		clickedTerrain as TerrainScript = targetTerrain.GetComponent[of TerrainScript]()
		if(clickedTerrain == null):
			_currentPlayerGUI.PrintToScreen(CLICK_ON_A_TERRAIN)
			return
		else:
			// if user clicked on a terrain, check that it is not occupied.
			if(clickedTerrain.IsOccupied == true):
				_currentPlayerGUI.PrintToScreen(AREA_OCCUPIED)
				return
			
			/*
			print(System.DateTime.Now)
			print(System.DateTime.Now.Millisecond)
			allNodes = MoveAspectClass.FindShortestPath(gameObject ,targetTerrain, false);
			// Get the path list to the target
			print(System.DateTime.Now)
			print(System.DateTime.Now.Millisecond)
			*/
			pathStruct as MoveAspectClass.PathResult = MoveAspectClass.FindShortestPath(gameObject ,targetTerrain)
			pathStruct.pathList.Add(targetTerrain)
			pathStruct.pathList.RemoveAt(0) 
			//pathStruct.pathList.RemoveAt((len(pathStruct.pathList)-1)) 
			if pathStruct.pathList == []:
				_currentPlayerGUI.PrintToScreen("No path.")
				return
			
			// Check if enough AP	
			// Check if enough petrol
			actionPointsCost as int = 0
			petrolCost as int = 0
			cost = 0
			for terrainGrid as GameObject in pathStruct.pathList: //Removed [:-1]
				cost = MoveAspectClass.terrainMoveCost(_testInfantryTroop, terrainGrid.GetComponent[of TerrainScript]().TerrainType)
				petrolCost += cost
				actionPointsCost += cost
				if(petrolCost > _testInfantryTroop.Petrol):
					_currentPlayerGUI.PrintToScreen(NOT_ENOUGH_PETROL)
					return
				if(actionPointsCost > _testInfantryTroop.ActionPoints):
					_currentPlayerGUI.PrintToScreen(TO_FEW_AP_LEFT)
					return
				
			//setSelected as callable = _testInfantryData.SetSelected
				
			currentCost as int
			for terrainGrid as GameObject in pathStruct.pathList:
				currentCost = 0
				currentCost = MoveAspectClass.terrainMoveCost(_testInfantryTroop, terrainGrid.GetComponent[of TerrainScript]().TerrainType)
				
				ChangeFacingTowards(gameObject, terrainGrid)
				//rot = transform.rotation;
				pos = transform.position;
				duration = 0.4
				time = 0.0
				while (time < duration):
					time += Time.deltaTime;
					transform.position = Vector3.Lerp(pos, terrainGrid.transform.position, time / duration);
					//transform.rotation = Quaternion.Slerp(target.rotation, rot, time / originalTime);
					yield;
				
				moveOneTerrain(terrainGrid)
				_testInfantryTroop.ActionPoints -= currentCost
				//setSelected()
				_testInfantryTroop.IsMoving = true
				//yield WaitForSeconds(1)
				// Get all components that need to be updated after a move
				//IMoveComponents as List = _library.GetInterfaceComponents[of IMove](gameObject)  //dont work on webbplayer!
				IMoveComponents as List = []
				for component as MonoBehaviour in gameObject.GetComponents[of MonoBehaviour]():
					if component isa IMove:
						component1 as IMove = component
						IMoveComponents.Add(component1)
					
				if( len(IMoveComponents) == 0):
					continue
				TakeOverBuildings(clickedTerrain)
				
				canContinueMove = true
				// Call the visibility concenr first, it updates the sight values which is used by other concenrs
				for component in IMoveComponents:
					componentIMove as IMove = component
					if componentIMove isa SightTroop:
						canContinueMove = LibraryScript.ReturnBoolVarIfNotAlreadySet(componentIMove.AllowedToMove(terrainGrid, _testInfantryTroop), canContinueMove, false)
						IMoveComponents.Remove(component)
					
				// Call all other concerns
				for moveDependentConcernScript as IMove in IMoveComponents:
					canContinueMove = LibraryScript.ReturnBoolVarIfNotAlreadySet(moveDependentConcernScript.AllowedToMove(terrainGrid, _testInfantryTroop), canContinueMove, false)

				if canContinueMove == false:
					break
			_testInfantryTroop.IsMoving = false
			
			// Check movement point
		
	static def CalulateAngle(from1 as Vector2, to1 as Vector2):
		angle as double = 0
		if(to1.y-4 < from1.y == true and to1.y+4 > from1.y == true ):
			if to1.x-4 > from1.x:
				angle = 180
			else:
				angle = 0
		elif(to1.y-4 > from1.y):
			if to1.x-4 > from1.x:
				angle = 225
			elif to1.x+4 < from1.x:
				angle = 315
			else:
				angle = -90
		elif(to1.y+4 < from1.y):
			if to1.x-4 > from1.x:
				angle = 135
			elif to1.x+4 < from1.x:
				angle = 45
			else:
				angle = 90
		
		return angle
	
	static def ChangeFacingTowards(us as GameObject, target as GameObject) as void:		
		from1 as Vector2 = Vector2(us.transform.position.x, us.transform.position.y)
		to1 as Vector2 = Vector2(target.transform.position.x, target.transform.position.y)
		
		us.transform.rotation.eulerAngles.z = CalulateAngle(from1 , to1)

		return 
	/* Moves one terrain, removes itself from the old terrain and itself to the new.
	 crashes if the targetTerrain is null
	*/ 
	def moveOneTerrain(targetTerrain as GameObject):
		assert targetTerrain != null
		
		//ChangeFacingTowards(gameObject, targetTerrain)
		// move this unit to the correct position
		//transform.position.x = targetTerrain.transform.position.x//-(GameState.TERRAIN_SIDE_DISTANCE/2)
		//transform.position.y = targetTerrain.transform.position.y//-(GameState.TERRAIN_SIDE_DISTANCE/2)
		//transform.position = Vector3.Lerp(gameObject.transform.position, targetTerrain.transform.position, 0.5);
		//Lerp(1.0, targetTerrain)
		
		// remove one self to the occupied terrain list of objects for the current terrain and set it to unoccupied
		currentTerrain = _testInfantryTroop.OccupiedTerrain
		currentTerrain.IsOccupied = false
		currentTerrain.RemoveUnit(gameObject)
		
		
		
		// Set the clicked terrain to the current terrain
		clickedTerrain as ITerrain = targetTerrain.GetComponent("ITerrain")
		assert clickedTerrain != null
		_testInfantryTroop.OccupiedTerrain = clickedTerrain
		_testInfantryTroop.OccupiedTerrainGameObject = targetTerrain				
		
		// set the target terrain to occupied
		_testInfantryTroop.OccupiedTerrain.IsOccupied = true
		
		// add one self to the occupied terrain list of objects
		_testInfantryTroop.OccupiedTerrain.AddUnit(gameObject)
		
//	var target : Transform;
	def Lerp (time as double, target as GameObject):
		pos = transform.position;
		//rot = transform.rotation;
		originalTime = time;
		while (time > 0.0):
			time -= Time.deltaTime;
			transform.position = Vector3.Lerp(target.transform.position, pos, time / originalTime);
			//transform.rotation = Quaternion.Slerp(target.rotation, rot, time / originalTime);
			yield;

		
		
	def TakeOverBuildings(target as TerrainScript):
		for unit as GameObject in target.ContainedObjects:
			if unit.GetComponent[of DataScript]().GameObjectType == DataScript.GameObjectTypeEnum.building:
				teamScript = unit.GetComponent[of TeamScript]()
				teamScript.SetTeam( gameObject.GetComponent[of TeamScript]().Player)
		
	def HighlightMovableTerrain():
		// Highlight terrain that you can build on.
		startTerrain as TerrainScript = TerrainScript.FindTerrainScript(_testInfantryTroop.OccupiedTerrainGameObject)
		ourTeam as TeamScript.PlayerNumberEnum = TeamScript.FindTeamScript(gameObject).Player
		//count as int = 0
		//range as int = 1
		_highlightedTerrains = []
		
		passedData1 as List = [0,0]
		// + {goal as GameObject |return MoveAspectClass.FindShortestPath(gameObject, goal)}(neighbor).totalCost
		//endCondition as callable = def(passedData as int, neighbor as TerrainScript):
		endCondition as callable = def(passedData as List, neighbor as TerrainScript, closeSet as List):	
			//if neighbor.gameObject.GetInstanceID() == _testInfantryTroop.OccupiedTerrainGameObject.GetInstanceID():
			//	return false
				
			if neighbor.IsOccupied == true or neighbor.TerrainType == TerrainScript.TerrainTypeEnum.water:
				//a = TerrainScript.FindTerrainScript(neighbor)
				return true
				
			instanceId as int = neighbor.GetInstanceID()
			nodeInCloseSet as List = closeSet.Find({item as List | return (item[0] as TerrainScript).GetInstanceID() == instanceId})
			if nodeInCloseSet != null:
				if passedData[0] cast int > (nodeInCloseSet[1] as List)[0] cast int and passedData[1] cast int > (nodeInCloseSet[1] as List)[1] cast int:
					return true 
			//MoveAspectClass.FindShortestPath(gameObject, neighbor).totalCost
			/*
			if passedData[1] cast int < _testInfantryTroop.Petrol:
				print("Passeddata")
				print(passedData[1])
				print("Petrol")
				print(_testInfantryTroop.Petrol)
				*/
			return passedData[0] cast int > _testInfantryTroop.ActionPoints or passedData[1] cast int  > _testInfantryTroop.Petrol  //+MoveAspectClass.terrainMoveCost(_testInfantryTroop, TerrainScript.FindTerrainScript(neighbor).TerrainType ) cast int
		
		//continueCode as callable = {passedData as int, neighbor as TerrainScript | return passedData + MoveAspectClass.terrainMoveCost(_testInfantryTroop, neighbor.TerrainType ) cast int}
		continueCode as callable = {passedData as List, neighbor as TerrainScript | return [passedData[0] cast int  + MoveAspectClass.terrainMoveCost(_testInfantryTroop, neighbor.TerrainType ) cast int,passedData[1]  cast int + MoveAspectClass.terrainMoveCost(_testInfantryTroop, neighbor.TerrainType ) cast int]}
		searchfunction = {terrain as TerrainScript | return terrain.IsOccupied == false and terrain.TerrainType != TerrainScript.TerrainTypeEnum.water}
		//searchfunction = {terrain as GameObject | return true}
		//terrainMoveCost(troopObject as UnityEngine.Object, terrain as TerrainScript.TerrainTypeEnum) as int:
		searchedTerrain = []
		print(System.DateTime.Now)
		print(System.DateTime.Now.Millisecond)
		TerrainScript.RecursiveTerrainSearchScript(startTerrain, ourTeam, endCondition, continueCode, passedData1, _highlightedTerrains, searchfunction, searchedTerrain)
		print(System.DateTime.Now)
		print(System.DateTime.Now.Millisecond)
//		RecursiveTerrainSearch(startTerrain, ourTeam, endCondition as callable, continueCode as callable, passedData as object, ref searchMatchedList as List, searchFunction as callable ):
		//startTerrain.RecursiveTerrainSearch(startTerrain, ourTeam, count , range , _highlightedTerrains, _searchFunction(ourTeam))
		_highlightedTerrains.Add(_testInfantryTroop.OccupiedTerrain)
		//OccupiedTerrain
		for go as TerrainScript in  _highlightedTerrains:
			if go == null:
				continue
			(go as IHighlight).Highlight()
		/*
		
	def HighlightMovableTerrain():
		// Highlight terrain that you can build on.
		startTerrain as TerrainScript = TerrainScript.FindTerrainScript(_testInfantryTroop.OccupiedTerrainGameObject)
		ourTeam as TeamScript.PlayerNumberEnum = TeamScript.FindTeamScript(gameObject).Player
		//count as int = 0
		//range as int = 1
		_highlightedTerrains = []
		
		passedData1 as int = 0
		// + {goal as GameObject |return MoveAspectClass.FindShortestPath(gameObject, goal)}(neighbor).totalCost
		endCondition as callable = def(passedData as int, neighbor as GameObject):
			if neighbor.GetInstanceID() == _testInfantryTroop.OccupiedTerrainGameObject.GetInstanceID():
				return true
				
			if TerrainScript.FindTerrainScript(neighbor).IsOccupied == true:
				//a = TerrainScript.FindTerrainScript(neighbor)
				return true
			//MoveAspectClass.FindShortestPath(gameObject, neighbor).totalCost
			return MoveAspectClass.FindShortestPath(gameObject, neighbor).totalCost > _testInfantryTroop.ActionPoints  //+MoveAspectClass.terrainMoveCost(_testInfantryTroop, TerrainScript.FindTerrainScript(neighbor).TerrainType ) cast int
		
		continueCode as callable = {passedData as int, neighbor as GameObject | return passedData + MoveAspectClass.terrainMoveCost(_testInfantryTroop, TerrainScript.FindTerrainScript(neighbor).TerrainType ) cast int}
		searchfunction = {terrain as GameObject | return TerrainScript.FindTerrainScript(terrain).IsOccupied == false}
		//searchfunction = {terrain as GameObject | return true}
		//terrainMoveCost(troopObject as UnityEngine.Object, terrain as TerrainScript.TerrainTypeEnum) as int:
		searchedTerrain = []
		print(DateTime.Now)
		print(DateTime.Now.Millisecond)
		TerrainScript.RecursiveTerrainSearch(startTerrain, ourTeam, endCondition, continueCode, passedData1, _highlightedTerrains, searchfunction, searchedTerrain)
		print(DateTime.Now)
		print(DateTime.Now.Millisecond)
//		RecursiveTerrainSearch(startTerrain, ourTeam, endCondition as callable, continueCode as callable, passedData as object, ref searchMatchedList as List, searchFunction as callable ):
		//startTerrain.RecursiveTerrainSearch(startTerrain, ourTeam, count , range , _highlightedTerrains, _searchFunction(ourTeam))
		_highlightedTerrains.Add(_testInfantryTroop.OccupiedTerrainGameObject)
		//OccupiedTerrain
		for go as TerrainScript in [(TerrainScript.FindTerrainScript(go) as TerrainScript) for go as GameObject in _highlightedTerrains ]:
			if go == null:
				continue
			(go as IHighlight).Highlight()
		*/
	def DeHighlightMovableTerrain():
		for go as TerrainScript in _highlightedTerrains:
			(go as IHighlight).DeHighlight()
			
	def OnDestroy():
		if _testInfantryTroop != null and _testInfantryTroop.OccupiedTerrain != null:
			_testInfantryTroop.OccupiedTerrain.RemoveUnit(gameObject)
		/*
	def DeHighlightMovableTerrain():
		for go as TerrainScript in [(TerrainScript.FindTerrainScript(go) as TerrainScript) for go as GameObject in _highlightedTerrains ]:
			(go as IHighlight).DeHighlight()
			*/
			
		