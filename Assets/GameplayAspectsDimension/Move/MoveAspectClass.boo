import UnityEngine

static class MoveAspectClass(MonoBehaviour): 

	enum TerrainNeighbours:
		North
		NorthWest
		NorthEast
		East
		West
		South
		SouthEast
		SouthWest
	
	struct PathResult:
		pathList as List
		totalCost as int
		
	def MoveAspectClass():
		pass
		
	public final MovementTypeTerrainTable = {
		MechTroop as System.Type: {TerrainScript.TerrainTypeEnum.plain: 10, TerrainScript.TerrainTypeEnum.forrest: 12, TerrainScript.TerrainTypeEnum.hill: 18, TerrainScript.TerrainTypeEnum.water: 101, TerrainScript.TerrainTypeEnum.lowDensityBuildings: 13, TerrainScript.TerrainTypeEnum.highDensityBuildings: 16 } ,
		ArmoredTroop as System.Type: {TerrainScript.TerrainTypeEnum.plain: 10, TerrainScript.TerrainTypeEnum.forrest: 12, TerrainScript.TerrainTypeEnum.hill: 18, TerrainScript.TerrainTypeEnum.water: 101, TerrainScript.TerrainTypeEnum.lowDensityBuildings: 13, TerrainScript.TerrainTypeEnum.highDensityBuildings: 16 } ,
		ArtyTroop as System.Type: {TerrainScript.TerrainTypeEnum.plain: 10, TerrainScript.TerrainTypeEnum.forrest: 12, TerrainScript.TerrainTypeEnum.hill: 18, TerrainScript.TerrainTypeEnum.water: 101, TerrainScript.TerrainTypeEnum.lowDensityBuildings: 13, TerrainScript.TerrainTypeEnum.highDensityBuildings: 16 } ,
		EngyTroop as System.Type: {TerrainScript.TerrainTypeEnum.plain: 10, TerrainScript.TerrainTypeEnum.forrest: 12, TerrainScript.TerrainTypeEnum.hill: 18, TerrainScript.TerrainTypeEnum.water: 101, TerrainScript.TerrainTypeEnum.lowDensityBuildings: 13, TerrainScript.TerrainTypeEnum.highDensityBuildings: 16 } ,
		AntiairTroop as System.Type: {TerrainScript.TerrainTypeEnum.plain: 10, TerrainScript.TerrainTypeEnum.forrest: 12, TerrainScript.TerrainTypeEnum.hill: 18, TerrainScript.TerrainTypeEnum.water: 101, TerrainScript.TerrainTypeEnum.lowDensityBuildings: 13, TerrainScript.TerrainTypeEnum.highDensityBuildings: 16 } ,
		MotoTroop as System.Type: {TerrainScript.TerrainTypeEnum.plain: 8, TerrainScript.TerrainTypeEnum.forrest: 23, TerrainScript.TerrainTypeEnum.hill: 22, TerrainScript.TerrainTypeEnum.water: 101, TerrainScript.TerrainTypeEnum.lowDensityBuildings: 13, TerrainScript.TerrainTypeEnum.highDensityBuildings: 16 } ,
		LogiTroop as System.Type: {TerrainScript.TerrainTypeEnum.plain: 8, TerrainScript.TerrainTypeEnum.forrest: 23, TerrainScript.TerrainTypeEnum.hill: 22, TerrainScript.TerrainTypeEnum.water: 101, TerrainScript.TerrainTypeEnum.lowDensityBuildings: 13, TerrainScript.TerrainTypeEnum.highDensityBuildings: 16 } ,
		CommTroop as System.Type: {TerrainScript.TerrainTypeEnum.plain: 8, TerrainScript.TerrainTypeEnum.forrest: 23, TerrainScript.TerrainTypeEnum.hill: 22, TerrainScript.TerrainTypeEnum.water: 101, TerrainScript.TerrainTypeEnum.lowDensityBuildings: 13, TerrainScript.TerrainTypeEnum.highDensityBuildings: 16 }
	}
	
	def terrainMoveCost(troopObject as UnityEngine.Object, terrain as TerrainScript.TerrainTypeEnum) as int:
		cost as int = (MovementTypeTerrainTable[troopObject.GetType()] as Boo.Lang.Hash)[terrain]
		return cost
		
	def shortestTerrainMoveCost(troopObject as  UnityEngine.Object, range as int) as int:
		return terrainMoveCost(troopObject, TerrainScript.TerrainTypeEnum.plain)*range
 	
 
	def reconstruct_path(came_from as List, current_node as GameObject, searchFunction as callable, end as GameObject) as List:
		if current_node.GetInstanceID() == end.GetInstanceID():
			return [current_node]
		if searchFunction(current_node ,came_from) is not null:
			p as List = reconstruct_path(came_from,  searchFunction(current_node, came_from) as GameObject, searchFunction, end)
			return (p.Add(current_node))
		else:
			return [current_node]
		

	def calcRangeInGrid(start as GameObject, goal as GameObject) as int:
			//buffer as int = GameState.TERRAIN_SIDE_DISTANCE 
			//marginal = 1
			xDistance as double = calcXDistance(start,goal)
			yDistance as double = calcYDistance(start,goal)        //+(buffer+(buffer/2)-marginal)))  
			distance =  System.Math.Sqrt( ((xDistance) cast int)**2 + ((yDistance) cast int)**2)
			return (System.Math.Floor((distance / GameState.TERRAIN_SIDE_DISTANCE)))
			
						
	def calcYDistance(start as GameObject, targetTerrain as GameObject) as double:
		if( start.transform.position.y < targetTerrain.transform.position.y):
			//Pythagoaros for calc distance
			yDistance = (targetTerrain.transform.position.y  - start.transform.position.y)        //+(buffer+(buffer/2)-marginal)))  
			return yDistance
		elif(  start.transform.position.y > targetTerrain.transform.position.y ):
			//if(not (targetTerrain.transform.position.y > (currentTerrainGameObject.transform.position.y-(buffer+(buffer/2)+marginal)))  ):
			//Pythagoaros for calc distance
			yDistance = (start.transform.position.y - targetTerrain.transform.position.y)  // -(buffer+(buffer/2)-marginal)
			return yDistance    
			
	def calcXDistance(start as GameObject, targetTerrain as GameObject) as double:
		if( start.transform.position.x < targetTerrain.transform.position.x):
			xDistance = (targetTerrain.transform.position.x - start.transform.position.x) //+(buffer+(buffer/2)-marginal
			return xDistance
		elif(  start.transform.position.x > targetTerrain.transform.position.x ):
			xDistance = (start.transform.position.x - targetTerrain.transform.position.x) //-(buffer+(buffer/2)-marginal
			return xDistance
			
	// A* algoritm
	def FindShortestPath(start as GameObject, goal as GameObject) as PathResult:
		assert start != null
		assert goal != null
		//function A*(start,goal)
		startTroop = start.GetComponent[of TroopClass]()
		startTerrainGameObject as GameObject = start.GetComponent[of TroopClass]().OccupiedTerrainGameObject
		closedset = []
		openset = [startTerrainGameObject]
		came_from as List = []
		//heuristic_cost_estimate = {startTerrain as GameObject, goal as GameObject | shortestTerrainMoveCost(startTroop, LibraryScript.CalculateGridRange(startTerrain, goal))}
		heuristic_cost_estimate = { _,_1 | return 0}
		
		getIndexOfKey = def(key as GameObject, list as List) as int:
							assert key != null
							assert len(list) != 0
							index as int = 0
							for pair  as List in list:
								if (pair[0] as GameObject).GetInstanceID() == key.GetInstanceID()://pair[0] == key:
									return index
								index++
							return 0
		getValueFromKeyInList =  {key as GameObject, list as List | (list[getIndexOfKey(key, list)] as List)[1]}//{key as GameObject, list as List | (list[(list.IndexOf([pair[0] for pair as List in list].Find({item as GameObject | return item.GetInstanceID() == key.GetInstanceID()}) ))] as List)[1] } 
							 
		
							 
		newPair = {key, newValue | return [key, newValue]}
		
		g_score = [[startTerrainGameObject, 0]]
		h_score = [[startTerrainGameObject, heuristic_cost_estimate(startTroop.OccupiedTerrainGameObject, goal)] ] //heuristic_cost_estimate(start, goal)
		f_score = [[startTerrainGameObject,  getValueFromKeyInList(startTerrainGameObject, g_score) cast int + getValueFromKeyInList(startTerrainGameObject, h_score) cast int]]

		while len(openset) != 0:
	     	//the node in openset having the lowest f_score[] value
			lowestValue = 9999
			lowestKey as GameObject = (f_score[0] as List)[0]
			lowestPairs as List = []
			for pair as List in f_score:
				if pair[0] not in openset:
					continue
				if pair[1] cast int == lowestValue:
					lowestPairs.Add(pair)
				elif pair[1] cast int < lowestValue:
					lowestKey = pair[0]
					lowestValue = pair[1]
				else:
					pass	
					/*
			if len(lowestPairs)!= 0:
				for pair as List in lowestPairs:
					if pair[0] cast TerrainNeighbours == TerrainNeighbours.North:
						lowestKey = pair[0]
						lowestValue = pair[1]
					if pair[0] cast TerrainNeighbours == TerrainNeighbours.East:
						lowestKey = pair[0]
						lowestValue = pair[1]
					if pair[0] cast TerrainNeighbours == TerrainNeighbours.West:
						lowestKey = pair[0]
						lowestValue = pair[1]
					if pair[0] cast TerrainNeighbours == TerrainNeighbours.South:
						lowestKey = pair[0]
						lowestValue = pair[1]
			*/
			current as GameObject = lowestKey
			
			if current is goal:
				/*
				getIndexOfValue = def(value1 as GameObject, list as List) as int:
							index as int = 0
							for pair as List in list:
								if (pair[1] as GameObject).GetInstanceID() == value1.GetInstanceID()://pair[0] == key:
									return index
								index++
							return -1
				*/
				/*
				getKeyFromValueInList =  def(key as GameObject, list as List):
							if getIndexOfValue(key, list) != -1: 
								return (list[getIndexOfKey(key, list)] as List)[0] 
							else: 
								return null//{key as GameObject, list as List | (list[(list.IndexOf([pair[0] for pair as List in list].Find({item as GameObject | return item.GetInstanceID() == key.GetInstanceID()}) ))] as List)[1] } 
				*/
				return PathResult(pathList: reconstruct_path(came_from, getValueFromKeyInList(goal, came_from), getValueFromKeyInList, startTerrainGameObject) , totalCost: lowestValue) 
			openset.Remove(current)
			closedset.Add(current)
			
			
			// this is all needed becouse the algortim apperntly otherwise likes to take a diagonal road to a straight line goal.... :/
			currentITerrain as ITerrain = (current.GetComponent("ITerrain") as ITerrain)
			neighborsLoopList = [currentITerrain.TerrainNeighbors[TerrainNeighbours.North], currentITerrain.TerrainNeighbors[TerrainNeighbours.South], currentITerrain.TerrainNeighbors[TerrainNeighbours.West], 
			currentITerrain.TerrainNeighbors[TerrainNeighbours.East], currentITerrain.TerrainNeighbors[TerrainNeighbours.NorthEast], currentITerrain.TerrainNeighbors[TerrainNeighbours.NorthWest],
			currentITerrain.TerrainNeighbors[TerrainNeighbours.SouthEast], currentITerrain.TerrainNeighbors[TerrainNeighbours.SouthWest]]
			

				
			
			for neighbor in neighborsLoopList:		
				neighborValue = neighbor	
				if neighborValue in closedset:
					continue
				if neighborValue == null:
					continue
				if ((neighborValue as GameObject).GetComponent("ITerrain") as ITerrain).IsOccupied == true:
					continue
				tentative_g_score = getValueFromKeyInList(current, g_score) cast int + terrainMoveCost( startTroop, ((neighborValue as GameObject).GetComponent[of TerrainScript]() as TerrainScript).TerrainType) //dist_between(current,neighbor)
				if neighborValue not in openset:
					//add neighbor to openset
					openset.Add(neighborValue)
					//_currentPlayerGUI.PrintToScreen(heuristic_cost_estimate(neighborValue, goal))
					//_currentPlayerGUI.PrintToScreen(getIndexOfKey(neighborValue, h_score))
					//_currentPlayerGUI.PrintToScreen((h_score[getIndexOfKey(neighborValue, h_score)] as List))
					//_currentPlayerGUI.PrintToScreen(heuristic_cost_estimate(neighborValue, goal))
					//_currentPlayerGUI.PrintToScreen((h_score[getIndexOfKey(neighborValue, h_score)] as List)[1])
					//(h_score[getIndexOfKey(neighborValue, h_score)] as List)[1] = heuristic_cost_estimate(neighborValue, goal)
					h_score.Add( newPair(neighborValue, heuristic_cost_estimate(neighborValue, goal)) )
					tentative_is_better = true
				elif tentative_g_score < getValueFromKeyInList(neighborValue, g_score) cast int:
					tentative_is_better = true
				else:
					tentative_is_better = false
				
				if tentative_is_better == true:  
					came_from.Add( newPair(neighborValue, current) )
					g_score.Add( newPair(neighborValue, tentative_g_score) )
					//_currentPlayerGUI.PrintToScreen(neighborValue)
					//_currentPlayerGUI.PrintToScreen(getValueFromKeyInList(neighborValue as GameObject, g_score))
					//_currentPlayerGUI.PrintToScreen(getValueFromKeyInList(neighborValue, h_score))
					f_score.Add(newPair(neighborValue, getValueFromKeyInList(neighborValue, g_score) cast int + getValueFromKeyInList(neighborValue, h_score) cast int))
					//g_score[neighbor] := tentative_g_score
                    //f_score[neighbor] := g_score[neighbor] + h_score[neighbor]
					//(g_score[getIndexOfKey(neighborValue, h_score)] as List)[1] = tentative_g_score
					//(f_score[getIndexOfKey(neighborValue, h_score)] as List)[1] = getValueFromKeyInList(neighborValue, g_score) cast int + getValueFromKeyInList(neighborValue, h_score) cast int
		return PathResult(pathList: [], totalCost: 0)
  
/*
buffer = GameState.TERRAIN_SIDE_DISTANCE * range
			targetTerrain = goal
			currentTerrainGameObject = start
			marginal = 1
			if( transform.position.x < targetTerrain.transform.position.x):
				if(not (targetTerrain.transform.position.x < (currentTerrainGameObject.transform.position.x+(buffer+(buffer/2)-marginal)))  ):
					return 
					_currentPlayerGUI.PrintToScreen(MOVE_TO_FAR)
					return
			elif(  transform.position.x > targetTerrain.transform.position.x ):
				if(not (targetTerrain.transform.position.x > (currentTerrainGameObject.transform.position.x-(buffer+(buffer/2)+marginal)))  ):
					_currentPlayerGUI.PrintToScreen(MOVE_TO_FAR)
					return
					
			if( transform.position.y < targetTerrain.transform.position.y):
				if(not (targetTerrain.transform.position.y < (currentTerrainGameObject.transform.position.y+(buffer+(buffer/2)-marginal)))  ):
					_currentPlayerGUI.PrintToScreen(MOVE_TO_FAR)
					return
			elif(  transform.position.y > targetTerrain.transform.position.y ):
				if(not (targetTerrain.transform.position.y > (currentTerrainGameObject.transform.position.y-(buffer+(buffer/2)+marginal)))  ):
					_currentPlayerGUI.PrintToScreen(MOVE_TO_FAR)
					return
*/
