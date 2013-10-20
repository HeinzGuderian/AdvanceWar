import UnityEngine

abstract class TerrainScript(MonoBehaviour, IHighlight, ITerrain): 
	_containedObjects as List = []
	_isOccupied as bool = false
	_library as LibraryScript
	public materials as (Material)
	_neighbours as Boo.Lang.Hash
	_neighboursScript as Boo.Lang.Hash
	static CoordinatedGameScriptTable as Boo.Lang.Hash
	[SerializeField] _terrainType as TerrainTypeEnum
	/*
	final _terrainNeighbours as Boo.Lang.Hash =  {MoveAspectClass.TerrainNeighbours.North: null, MoveAspectClass.TerrainNeighbours.East: null,
	MoveAspectClass.TerrainNeighbours.West: null, MoveAspectClass.TerrainNeighbours.South: null, MoveAspectClass.TerrainNeighbours.SouthEast: null,
	MoveAspectClass.TerrainNeighbours.NorthWest: null, MoveAspectClass.TerrainNeighbours.NorthEast: null, MoveAspectClass.TerrainNeighbours.SouthWest: null 
	}
	*/
	TerrainNeighbors as Boo.Lang.Hash:
		get:
			return _neighbours 

	TerrainNeighborsScript as Boo.Lang.Hash:
		get:
			return _neighboursScript
	
	TerrainType as TerrainScript.TerrainTypeEnum:
		get:
			return _terrainType
		set:
			_terrainType = value
	[SerializeField]	
	public HighLightedMaterial as Material
	
	public enum TerrainTypeEnum:
		plain
		hill
		forrest
		lowDensityBuildings
		highDensityBuildings
		water
		
	def Highlight():
		renderer.material = materials[1]
		
	def DeHighlight():
		renderer.material = materials[0]
		
		/*
	def OnMouseDown():
		currentPlayersGameObject = _library.FindCamera() // GameObject.Find("Player1")
		//currentPlayer = currentPlayersGameObject.GetComponent[of PlayerScript]()
		currentPlayerGUI = currentPlayersGameObject.GetComponent[of GuiScript]()
		currentPlayerGUI.SetSelected(gameObject)	
	*/
	IsOccupied as bool:
		get:
			//_isOccupied = CheckIfIsOccupied()
			return  _isOccupied
		set:
			_isOccupied = value				
		
	def CheckIfIsOccupied() as bool:
		return (_containedObjects.Count != 0)
		
	ContainedObjects as List:
		get:
			return _containedObjects
		set:
			_containedObjects = value

	def AddUnit(newGameObject as GameObject):
		ContainedObjects.Add(newGameObject)
		//IsOccupied = true
		
	def RemoveUnit(newGameObject as GameObject):
		ContainedObjects.Remove(newGameObject)
		//IsOccupied = false
		
	virtual def Awake():
		_library = (GameObject.Find('GameRules').GetComponent[of LibraryScript]() as LibraryScript)
		assert _library != null
		IsOccupied = false
		_neighbours = getNeigbours(gameObject)
		_neighboursScript = getNeigboursScript(gameObject)

		
/*
	def Start ():
		//renderer.material = materials[1]
		_library = (GameObject.Find('GameRules').GetComponent[of LibraryScript]() as LibraryScript)
		assert _library != null
		*/
	static def FindTerrainScript(gameObjectToSearch as GameObject) as TerrainScript:
		terrainScript as TerrainScript = gameObjectToSearch.GetComponent[of TerrainScript]()
		return terrainScript

		

	def getNeigbours(this as GameObject) as Boo.Lang.Hash:
		assert this != null
		currentGameObject = this
		terrainSideLength = GameState.TERRAIN_SIDE_DISTANCE
		
		hashReturn as Boo.Lang.Hash={MoveAspectClass.TerrainNeighbours.North: null, MoveAspectClass.TerrainNeighbours.East: null,
		MoveAspectClass.TerrainNeighbours.West: null, MoveAspectClass.TerrainNeighbours.South: null, MoveAspectClass.TerrainNeighbours.SouthEast: null,
		MoveAspectClass.TerrainNeighbours.NorthWest: null, MoveAspectClass.TerrainNeighbours.NorthEast: null, MoveAspectClass.TerrainNeighbours.SouthWest: null  }
		
		north as Vector3 = currentGameObject.transform.position
		north.y += terrainSideLength
		hashReturn[MoveAspectClass.TerrainNeighbours.North] = _library.FindTerrain(north)
		
		east as Vector3 = currentGameObject.transform.position
		east.x += terrainSideLength
		hashReturn[MoveAspectClass.TerrainNeighbours.East] = _library.FindTerrain(east)
		
		west as Vector3 = currentGameObject.transform.position
		west.x -= terrainSideLength
		hashReturn[MoveAspectClass.TerrainNeighbours.West] = _library.FindTerrain(west)
		
		south as Vector3 = currentGameObject.transform.position
		south.y -= terrainSideLength
		hashReturn[MoveAspectClass.TerrainNeighbours.South] = _library.FindTerrain(south)
		
		northWest as Vector3 = currentGameObject.transform.position
		northWest.y += terrainSideLength
		northWest.x -= terrainSideLength
		//TerrainNeighbors.NorthWest as TerrainScript = FindTerrain(northWest)
		hashReturn[MoveAspectClass.TerrainNeighbours.NorthWest] = _library.FindTerrain(northWest)
		
		northEast as Vector3 = currentGameObject.transform.position
		northEast.y += terrainSideLength
		northEast.x += terrainSideLength
		hashReturn[MoveAspectClass.TerrainNeighbours.NorthEast] = _library.FindTerrain(northEast)
		
		southEast as Vector3 = currentGameObject.transform.position
		southEast.y -= terrainSideLength
		southEast.x -= terrainSideLength
		hashReturn[MoveAspectClass.TerrainNeighbours.SouthEast] = _library.FindTerrain(southEast)
		
		southWest as Vector3 = currentGameObject.transform.position
		southWest.y -= terrainSideLength
		southWest.x += terrainSideLength
		hashReturn[MoveAspectClass.TerrainNeighbours.SouthWest] = _library.FindTerrain(southWest)
		
		return hashReturn
		
	def getNeigboursScript(this as GameObject) as Boo.Lang.Hash:
		assert this != null
		currentGameObject = this
		terrainSideLength = GameState.TERRAIN_SIDE_DISTANCE
		
		hashReturn as Boo.Lang.Hash={MoveAspectClass.TerrainNeighbours.North: null, MoveAspectClass.TerrainNeighbours.East: null,
		MoveAspectClass.TerrainNeighbours.West: null, MoveAspectClass.TerrainNeighbours.South: null, MoveAspectClass.TerrainNeighbours.SouthEast: null,
		MoveAspectClass.TerrainNeighbours.NorthWest: null, MoveAspectClass.TerrainNeighbours.NorthEast: null, MoveAspectClass.TerrainNeighbours.SouthWest: null  }
		
		north as Vector3 = currentGameObject.transform.position
		north.y += terrainSideLength
		northGO = _library.FindTerrain(north)
		if northGO != null:
			hashReturn[MoveAspectClass.TerrainNeighbours.North] = FindTerrainScript(northGO)
		else:
			hashReturn[MoveAspectClass.TerrainNeighbours.North] = null
			
		east as Vector3 = currentGameObject.transform.position
		east.x += terrainSideLength
		eastGO = _library.FindTerrain(east)
		if eastGO != null:
			hashReturn[MoveAspectClass.TerrainNeighbours.East] = FindTerrainScript(eastGO)
		else:
			hashReturn[MoveAspectClass.TerrainNeighbours.East] = null
		
		west as Vector3 = currentGameObject.transform.position
		west.x -= terrainSideLength
		westGO = _library.FindTerrain(west)
		if westGO != null:
			hashReturn[MoveAspectClass.TerrainNeighbours.West] = FindTerrainScript(westGO)
		else:
			hashReturn[MoveAspectClass.TerrainNeighbours.West] = null
		
		south as Vector3 = currentGameObject.transform.position
		south.y -= terrainSideLength
		southGO = _library.FindTerrain(south)
		if southGO != null:
			hashReturn[MoveAspectClass.TerrainNeighbours.South] = FindTerrainScript(southGO)
		else:
			hashReturn[MoveAspectClass.TerrainNeighbours.South] = null
		
		northWest as Vector3 = currentGameObject.transform.position
		northWest.y += terrainSideLength
		northWest.x -= terrainSideLength
		//TerrainNeighbors.NorthWest as TerrainScript = FindTerrain(northWest)
		northWestGO = _library.FindTerrain(northWest)
		if northWestGO != null:
			hashReturn[MoveAspectClass.TerrainNeighbours.NorthWest] = FindTerrainScript(northWestGO)
		else:
			hashReturn[MoveAspectClass.TerrainNeighbours.NorthWest] = null
		
		northEast as Vector3 = currentGameObject.transform.position
		northEast.y += terrainSideLength
		northEast.x += terrainSideLength
		northEastGO = _library.FindTerrain(northEast)
		if northEastGO != null:
			hashReturn[MoveAspectClass.TerrainNeighbours.NorthEast] = FindTerrainScript(northEastGO)
		else:
			hashReturn[MoveAspectClass.TerrainNeighbours.NorthEast] = null
		
		southEast as Vector3 = currentGameObject.transform.position
		southEast.y -= terrainSideLength
		southEast.x -= terrainSideLength
		southEastGO = _library.FindTerrain(southEast)
		if southEastGO != null:
			hashReturn[MoveAspectClass.TerrainNeighbours.SouthEast] = FindTerrainScript(southEastGO)
		else:
			hashReturn[MoveAspectClass.TerrainNeighbours.SouthEast] = null
		
		southWest as Vector3 = currentGameObject.transform.position
		southWest.y -= terrainSideLength
		southWest.x += terrainSideLength
		southWestGO = _library.FindTerrain(southWest)
		if southWestGO != null:
			hashReturn[MoveAspectClass.TerrainNeighbours.SouthWest] = FindTerrainScript(southWestGO)
		else:
			hashReturn[MoveAspectClass.TerrainNeighbours.SouthWest] = null
		
		return hashReturn
		
	// Note that the list searchMatchedList needs to be provided and will be manipulated as a side effect.
	// Count on the first time should be intislised to 0
	/* 
		startTerrain as TerrainScript = TerrainScript.FindTerrainScript(go)
		ourTeam as TeamScript.PlayerNumberEnum = TeamScript.FindTeamScript(gameObject).Player
		count as int = 0
		range as int = 3
		searchMatchedList as List = []
		searchFunction = {x as GameObject | ourTeam == TeamScript.FindTeamScript(x).Player}
		Example: RecursiveTerrainSearchGrids(startTerrain, ourTeam as TeamScript.PlayerNumberEnum, count as int, range as int, ref searchMatchedList as List, searchFunction as callable ) as void:
	
	*/
	static def RecursiveTerrainSearchGrids(startPoint as TerrainScript, ourTeam as TeamScript.PlayerNumberEnum, count as int, range as int, ref searchMatchedList as List, searchFunction as callable,ref searchedSet as List  ) as void:
		RecursiveTerrainSearch(startPoint, ourTeam, {data as List, goal as GameObject | return LibraryScript.CalculateGridRange(startPoint.gameObject,goal) > range }, {data as List, _ | return [data[0] cast int+1,data[1]]}, [count, range], searchMatchedList, searchFunction, searchedSet)
		
	static def RecursiveTerrainObjectsSearchGrids(startPoint as TerrainScript, ourTeam as TeamScript.PlayerNumberEnum, count as int, range as int, ref searchMatchedList as List, searchFunction as callable,ref searchedSet as List  ) as void:
		RecursiveTerrainObjectsSearch(startPoint, ourTeam, {data as List, goal as GameObject | data[0] cast int > data[1] cast int }, {data as List, _ | return [data[0] cast int+1,data[1]]}, [count, range], searchMatchedList, searchFunction, searchedSet)
		
		
	static def RecursiveTerrainObjectsSearch(startPoint as TerrainScript, ourTeam as TeamScript.PlayerNumberEnum, endCondition as callable, continueCode as callable, passedData as object, ref searchMatchedList as List, searchFunction as callable,ref searchedSet as List  ) as void:
		wrapperSearchFunction = def(TerrainGameObject as GameObject): 
			neighborTerrainScript as ITerrain =  LibraryScript.GetInterfaceComponent[of ITerrain](TerrainGameObject)
			for neighborContainedObject as GameObject in neighborTerrainScript.ContainedObjects: 
				if(searchFunction(neighborContainedObject) == true):
					searchMatchedList.AddUnique(neighborContainedObject)
				else:
					continue
			return false 
		RecursiveTerrainSearch(startPoint, ourTeam, endCondition, continueCode, passedData, searchMatchedList, wrapperSearchFunction, searchedSet )
		
		
	// BASELINED! DO NOT CHANGE WITHOUT CONSULTING EVERYONE
	// TRICKY ALGORITHM THAT EASILY BREAK. DO NOT CHANGE.
	static def RecursiveTerrainSearch(startPoint as TerrainScript, ourTeam as TeamScript.PlayerNumberEnum, endCondition as callable, continueCode as callable, passedData as object, ref searchMatchedList as List, searchFunction1 as callable,searchedSet as List ) as void:
		searchedSet.AddUnique(startPoint.GetInstanceID())
		searchedObjectStack as List = [[startPoint,passedData]]
		first as bool = true
		goFor as bool = true
		count = 0
		while len(searchedObjectStack) > 0:
			goFor = true
			searchedNode as List = searchedObjectStack[0]
			searchedObjectStack.RemoveAt(0)
			//if (searchedNode[0] as TerrainScript).GetInstanceID() in searchedSet:
			//	goFor = false
			searchedSet.AddUnique((searchedNode[0]  as TerrainScript).GetInstanceID())
			
			if endCondition(searchedNode[1], (searchedNode[0]  as TerrainScript).gameObject) == true and first == false:
				goFor = false	
			if(  first == false and goFor == true and searchFunction1((searchedNode[0]  as TerrainScript).gameObject) == true ):
				count += 1
				searchMatchedList.Add((searchedNode[0]  as TerrainScript).gameObject)	
			first = false
			if goFor == true:
				index = 0
				for neighborDict in (searchedNode[0]  as TerrainScript).TerrainNeighborsScript: 
					neighbor as TerrainScript = neighborDict.Value
					if neighbor == null:
						continue
					if neighbor.GetInstanceID() in searchedSet:
						continue
					else:
						pass
						
					if startPoint.gameObject.GetInstanceID() == neighbor.GetInstanceID():
						//searchedSet.AddUnique(neighbor.GetInstanceID())
						continue
					else:
						pass
					
					//searchedSet.AddUnique(neighbor.GetInstanceID())
					searchedObjectStack.Add([neighbor,continueCode(searchedNode[1], neighbor)])
				index += 1
//		print(count)
		return 
	
	static def RecursiveTerrainSearchGridsScript(startPoint as TerrainScript, ourTeam as TeamScript.PlayerNumberEnum, count as int, range as int, ref searchMatchedList as List, searchFunction as callable,ref searchedSet as List  ) as void:
		RecursiveTerrainSearchScript(startPoint, ourTeam, {data as List, _ | data[0] cast int > data[1] cast int }, {data as List, _ | return [data[0] cast int+1,data[1]]}, [count, range], searchMatchedList, searchFunction, searchedSet)
		
	static def RecursiveTerrainObjectsSearchGridsScript(startPoint as TerrainScript, ourTeam as TeamScript.PlayerNumberEnum, count as int, range as int, ref searchMatchedList as List, searchFunction as callable,ref searchedSet as List  ) as void:
		RecursiveTerrainObjectsSearchScript(startPoint, ourTeam, {data as List, goal as TerrainScript | return LibraryScript.CalculateGridRange(startPoint.gameObject,goal.gameObject) > range }, {data as List, _ | return [data[0] cast int+1,data[1]]}, [count, range], searchMatchedList, searchFunction, searchedSet)
		
	
	static def RecursiveTerrainObjectsSearchScript(startPoint as TerrainScript, ourTeam as TeamScript.PlayerNumberEnum, endCondition as callable, continueCode as callable, passedData as object, ref searchMatchedList as List, searchFunction as callable,ref searchedSet as List  ) as void:
		wrapperSearchFunction = def(suppliedTerrainScript as TerrainScript): 
			//neighborTerrainScript as ITerrain =  LibraryScript.GetInterfaceComponent[of ITerrain](TerrainGameObject)
			for neighborContainedObject as GameObject in suppliedTerrainScript.ContainedObjects: 
				if(searchFunction(neighborContainedObject) == true):
					searchMatchedList.AddUnique(neighborContainedObject)
				else:
					continue
			return false
			
		RecursiveTerrainSearchScript(startPoint, ourTeam, endCondition, continueCode, passedData, searchMatchedList, wrapperSearchFunction, searchedSet )
		
		/*
		1.Enqueue the root node
		2.Dequeue a node and examine it 
		If the element sought is found in this node, quit the search and return a result.
		Otherwise enqueue any successors (the direct child nodes) that have not yet been discovered.
		3.If the queue is empty, every node on the graph has been examined – quit the search and return "not found".
		4.If the queue is not empty, repeat from Step 2.
		*/			
	static def RecursiveTerrainSearchScript(startPoint as TerrainScript, ourTeam as TeamScript.PlayerNumberEnum, endCondition as callable, continueCode as callable, passedData as object, ref searchMatchedList as List, searchFunction1 as callable,searchedSet as List ) as void:
		searchedSet.AddUnique(startPoint.GetInstanceID())
		searchedObjectStack as List = [[startPoint,passedData]]
		searchedNode as List;
		closSet as List = [[startPoint,[999999,999999]]]
		first as bool = true
		goFor as bool = true
		while len(searchedObjectStack) > 0:
			goFor = true
			searchedNode = searchedObjectStack[0]
			searchedObjectStack.RemoveAt(0)
			if first == false:
				alreadyInNode as List = closSet.Find({item as List | return (item[0] as TerrainScript).GetInstanceID() == (searchedNode[0] as TerrainScript).GetInstanceID()})
				if alreadyInNode is null:
					closSet.Add(searchedNode)
			//if first == false and (searchedNode[0] as TerrainScript).GetInstanceID() in searchedSet:
			//	goFor = false
			searchedSet.AddUnique((searchedNode[0] as TerrainScript).GetInstanceID())
			
			if endCondition(searchedNode[1], searchedNode[0], closSet) == true and first == false:
				//a = endCondition(searchedNode[1], searchedNode[0])
				goFor = false	
			if( first == false and goFor == true and searchFunction1(searchedNode[0]) == true ):
				searchMatchedList.Add(searchedNode[0])	
			first = false
			if goFor == true:
			
				for neighborDict in (searchedNode[0] as TerrainScript).TerrainNeighborsScript: 
					neighbor as TerrainScript = neighborDict.Value
					if neighbor == null:
						continue
					if neighbor.GetInstanceID() in searchedSet:
						continue
					else:
						pass
						
					if startPoint.GetInstanceID() == neighbor.GetInstanceID():
						//searchedSet.AddUnique(neighbor.GetInstanceID())
						continue
					else:
						pass
					
					//searchedSet.AddUnique(neighbor.GetInstanceID())
					searchedObjectStack.Add([neighbor,continueCode(searchedNode[1], neighbor)])
				//if endCondition(passedData, neighbor) == true: //count == range:
					//searchedSet.AddUnique(neighbor.GetInstanceID())
					//continue 	
		
				//if(searchFunction(neighbor) == true):
				//	searchMatchedList.AddUnique(neighbor)
					//neighbor.GetComponent[of TerrainScript]().Highlight()
					
				//neighboursToGoThrough.Add(neighbor)
				//newPassedData = continueCode(passedData, neighbor)//newCount = count + 1 
				//searchedSet.AddUnique(neighbor.GetInstanceID())
				//RecursiveTerrainSearchScript(neighbor, ourTeam, endCondition, continueCode, newPassedData, searchMatchedList, searchFunction, searchedSet) 
		//for neighbour as GameObject in neighboursToGoThrough:
			//RecursiveTerrainSearch(TerrainScript.FindTerrainScript(neighbor), ourTeam, endCondition, continueCode, newPassedData, searchMatchedList, searchFunction, searchedSet) 
		return 
	def HightLightImplementation2(startPoint as TerrainScript, troopScript as TroopClass) as List:
		pass
		// Get the radius distance in optimal path from the unit
		// Get a list of coordinates on the edge terrains.byte
		// Check for coordinated of the grid
		  // In that case get the closest aviable and replace in list
		// Get the scripts from a global list and put in a list
		// Get all the scripts within the grid.
		// 
		
		
		/*
	static def RecursiveTerrainSearch(startPoint as TerrainScript, ourTeam as TeamScript.PlayerNumberEnum, endCondition as callable, continueCode as callable, passedData as object, ref searchMatchedList as List, searchFunction as callable,searchedSet as List ) as void:
		searchedSet.AddUnique(startPoint.gameObject.GetInstanceID())
		totalList = []
		currentNode = totalList[-1]
		for neighborDict in startPoint.TerrainNeighbors:
			neighbor as GameObject = neighborDict.Value
			if neighbor == null:
				continue
			if neighbor.GetInstanceID() in searchedSet:
				continue
			else:
				pass
			if startPoint.gameObject.GetInstanceID() == neighbor.GetInstanceID():
				//searchedSet.AddUnique(neighbor.GetInstanceID())
				continue
			else:
				pass
			
			//searchedSet.AddUnique(neighbor.GetInstanceID())
			if endCondition(passedData, neighbor.gameObject) == true: //count == range:
				continue 	

			if(searchFunction(neighbor) == true):
				searchMatchedList.AddUnique(neighbor)
				//neighbor.GetComponent[of TerrainScript]().Highlight()
				
			//neighboursToGoThrough.Add(neighbor)
			newPassedData = continueCode(passedData, neighbor)//newCount = count + 1 
			//searchedSet.AddUnique(neighbor.GetInstanceID())
			RecursiveTerrainSearch(TerrainScript.FindTerrainScript(neighbor), ourTeam, endCondition, continueCode, newPassedData, searchMatchedList, searchFunction, searchedSet) 
		//for neighbour as GameObject in neighboursToGoThrough:
			//RecursiveTerrainSearch(TerrainScript.FindTerrainScript(neighbor), ourTeam, endCondition, continueCode, newPassedData, searchMatchedList, searchFunction, searchedSet) 
		return 
		*/
		
		/*
		
		static def RecursiveTerrainSearch(startPoint as TerrainScript, ourTeam as TeamScript.PlayerNumberEnum, endCondition as callable, continueCode as callable, passedData as object, ref searchMatchedList as List, searchFunction as callable,searchedSet as List ) as void:
		searchedSet.AddUnique(startPoint.gameObject.GetInstanceID())
		
		for neighborDict in startPoint.TerrainNeighbors:
			neighbor as GameObject = neighborDict.Value
			if neighbor == null:
				continue
			if neighbor.GetInstanceID() in searchedSet:
				continue
			else:
				pass
			if startPoint.gameObject.GetInstanceID() == neighbor.GetInstanceID():
				//searchedSet.AddUnique(neighbor.GetInstanceID())
				continue
			else:
				pass
			
			//searchedSet.AddUnique(neighbor.GetInstanceID())
			if endCondition(passedData, neighbor) == true: //count == range:
				searchedSet.AddUnique(neighbor.GetInstanceID())
				continue 	

			if(searchFunction(neighbor) == true):
				searchMatchedList.AddUnique(neighbor)
				//neighbor.GetComponent[of TerrainScript]().Highlight()
				
			//neighboursToGoThrough.Add(neighbor)
			newPassedData = continueCode(passedData, neighbor)//newCount = count + 1 
			//searchedSet.AddUnique(neighbor.GetInstanceID())
			RecursiveTerrainSearch(TerrainScript.FindTerrainScript(neighbor), ourTeam, endCondition, continueCode, newPassedData, searchMatchedList, searchFunction, searchedSet) 
		//for neighbour as GameObject in neighboursToGoThrough:
			//RecursiveTerrainSearch(TerrainScript.FindTerrainScript(neighbor), ourTeam, endCondition, continueCode, newPassedData, searchMatchedList, searchFunction, searchedSet) 
		return 
		
		*/
		