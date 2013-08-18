import UnityEngine
import testExtension

class SightTroop (MonoBehaviour, IGUI, IGameState, IMove): 
	//_hasPlayedTurn as bool
	_library as LibraryScript
	_gameState as GameState
	_testInfantryData as IData
	_testInfantryTroop as TroopClass
	_teamScript as TeamScript
	_layer as LayerMask = (-1)
	
	
	def Awake ():
		_library = (GameObject.Find('GameRules').GetComponent[of LibraryScript]() as LibraryScript)	
		_gameState = (GameObject.Find('GameRules').GetComponent[of GameState]() as GameState)	
		_testInfantryTroop = gameObject.GetComponent[of TroopClass]()
		assert _testInfantryTroop != null
		_testInfantryData = gameObject.GetComponent("IData")
		assert _testInfantryData != null
		_teamScript = gameObject.GetComponent[of TeamScript]()
		assert _teamScript != null
		_layer = gameObject.layer
		
		//print("gaem staet turn: "+_gameState.WhosTurn.ToString())
		//a = _teamScript.IsOurTurn()
		if _teamScript.IsOurTurn() == false:
			GameObject.RecursiveRendererDisable(gameObject)
		else:
			GameObject.RecursiveRendererEnable(gameObject)
		_testInfantryTroop.Spotted = false
		
	def Start():
		
		CheckSurroundings()
	
	def Actions():
		return []
		
	def Info():
		return ""
		
	def EndTurnActions():
		//gameObject.renderer.enabled = false
		//gameObject.layer = LayerMask.NameToLayer("Ignore Raycast")
		if _teamScript.Player == _gameState.WhosTurn:
			if _testInfantryTroop.Spotted == false:
				GameObject.RecursiveRendererDisable(gameObject)
		else:
			GameObject.RecursiveRendererEnable(gameObject)
		
	def StartTurnActions():
		if _teamScript.Player == _gameState.CurrentPlayer:
			GameObject.RecursiveRendererEnable(gameObject)
		else: 
			GameObject.RecursiveRendererDisable(gameObject)
		//gameObject.renderer.enabled = true
		//gameObject.layer = _layer
		CheckSurroundings()
	
	def Update ():
		pass
		
	def AfterMove(_ as GameObject):
		CheckSurroundingsOptimised()
		
	def calculateCamoValue(objectToCheck as GameObject) as int:
		objectTroopClass = objectToCheck.GetComponent[of TroopClass]()
		assert objectTroopClass != null
		StealthValue as int = objectTroopClass.GroundSignature 
		
		if objectTroopClass.IsMoving == true:
			StealthValue += 1
		else:
			StealthValue -= 1
		
		if StealthValue <= 0:
			//_currentPlayerGUI.PrintToScreen("Error: In SightTroop, StealthValue was under 0!")
			StealthValue = 1	
		return StealthValue
		
	// Formula function that returns an adjusted detection value based on current state 
	def calculateDetectionAbility(objectToCheck as GameObject) as int:
		objectTroopClass = objectToCheck.GetComponent[of TroopClass]()
		assert objectTroopClass != null
		DetectionValue as int = objectTroopClass.DetectionCapabilities
		if objectTroopClass.IsMoving == true:
			DetectionValue -= 1
		else:
			DetectionValue += 1
		if objectTroopClass.MovementType == TroopClass.MovementTypeEnum.walking:
			DetectionValue += 1
			
		if DetectionValue <= 0:
			//_currentPlayerGUI.PrintToScreen("Error: In SightTroop, DetectionValue was under 0!")
			DetectionValue = 1	
		return DetectionValue
		
	def CheckIfDetected(observer as GameObject, target as GameObject) as bool:
		assert observer != null and target != null
		
		
		
		intialDetectionAbility = calculateDetectionAbility(observer)
		
		intialDetectAvoidance = SightAspectScript.SIGHT_AND_STEALTH_UPPER_BOUND-calculateCamoValue(target)
		observerTroopClass = observer.GetComponent[of TroopClass]()
		assert observerTroopClass != null
		
		distance = _library.CalculateGridRange(observer,target)
		if distance > observerTroopClass.Sight:
			return false
		if distance == 0:
			distance = 1
		betterDetectPerRange as int = (observerTroopClass.Sight - distance+1 )
		if betterDetectPerRange < 0:
			betterDetectPerRange = 0
			
		if (intialDetectionAbility+betterDetectPerRange) >= intialDetectAvoidance:
			return true
		else:
			return false
			
	/* Code to check that we are even effected by the movement, if it is in our sight range
	If we are not affected then the funciton returns.
	Otherwise it calls CheckSurroundings
	*/
	def CheckSurroundingsOptimised():
		//playerGameObjects = _gameState.FindPlayersGameObjects()
		playerGameObject as GameObject = _gameState.FindCurrentPlayerGameObject() 
		assert playerGameObject != null 
		// Get the selected object
		teamScript as TeamScript = TeamScript.FindTeamScript(playerGameObject)
		assert teamScript != null
		if teamScript.Player == (TeamScript.FindTeamScript(playerGameObject) as TeamScript).Player:
			guiGameObject = _library.FindCamera()
			selectedObject as GameObject = null
			selectedObject = guiGameObject.GetComponent[of GuiScript]().GetSelected()
			assert selectedObject != null
			// If we are the selected object, continue the function
			if selectedObject.GetInstanceID() == gameObject.GetInstanceID():
				pass
			// Then check if we can at all be effected by the move
			elif _testInfantryTroop.Sight <= _library.CalculateGridRange(gameObject, selectedObject):
				// If so continue the function, otherwise exit and save execution time
					pass
				else:
					return
		CheckSurroundings()
		
	// Function that goes through the enemy units in the terrains in sight range and sets their rendererd and collider according to if they get spotted 
	def CheckSurroundings():
		range as int = _testInfantryTroop.Sight
		ourTeam = _teamScript.Player
		startPoint = _testInfantryTroop.OccupiedTerrain
		assert startPoint != null
		
		enemyTroops = []
		objectIsATroop =  { gameObjectToCheck as GameObject |  return (gameObjectToCheck.GetComponent[of DataScript]().GameObjectType == DataScript.GameObjectTypeEnum.unit) }
		troopNotOurs = { gameObjectToCheck as GameObject |   gameObjectToCheck.GetComponent[of TeamScript]().Player != ourTeam }
		searchFunction as callable = { gameObjectToCheck as GameObject | objectIsATroop(gameObjectToCheck) and troopNotOurs(gameObjectToCheck) == true  }
		searchedTerrain = []
		_testInfantryTroop.OccupiedTerrain.RecursiveTerrainObjectsSearchGrids(startPoint, ourTeam, 0, range, enemyTroops, searchFunction, searchedTerrain )
	
//		spootedByAnyone = false
		for enemy as GameObject in enemyTroops:
			enemyTroopClass = enemy.GetComponent[of TroopClass]() as TroopClass
			assert enemyTroopClass != null
			
			if enemyTroopClass.Spotted == false:
				// Check if we see the enemy
				if CheckIfDetected(gameObject ,enemy):
					// then set him to visual
					GameObject.RecursiveRendererEnable(enemy)
					enemyTroopClass.Spotted = true
				else:	
					// Otherwise check if not on the current players team
					if _teamScript.IsOurTurn():
						//then  disable renderer
						GameObject.RecursiveRendererDisable(enemy)
						enemyTroopClass.Spotted = false
			
			// Check if we are already spotted
			if _testInfantryTroop.Spotted == true:
				GameObject.RecursiveRendererEnable(gameObject)
				// Then continue
				continue 
				
			// Check if the current enemy sees us
			if CheckIfDetected(enemy ,gameObject) == true:
				// Then set us to spotted
				_testInfantryTroop.Spotted = true	
				// Enable visual
				GameObject.RecursiveRendererEnable(gameObject)
			// If we are not spotted
			else:
				_testInfantryTroop.Spotted = false	
				// Check if we are not on the current players team
				if not _teamScript.IsOurTurn():
					// Then disable render
					GameObject.RecursiveRendererDisable(gameObject)
				
				
				/*
				
				
			if  enemyTroopClass.Spotted == true:
				enemyTroopClass.Spotted = true
				GameObject.RecursiveRendererEnable(gameObject)
				continue
			if CheckIfDetected(gameObject ,enemy) == true:
				// We should not alter renders if its the other players turn
				if _teamScript.IsOurTurn() == false:
					continue
				else:
					enemyTroopClass.Spotted = true
					GameObject.RecursiveRendererEnable(gameObject)
			else: 
				if _teamScript.IsOurTurn() == false:
					continue
				else:
					enemyTroopClass.Spotted = false
					GameObject.RecursiveRendererDisable(gameObject)
		if _teamScript.IsOurTurn() == false:
			pass
		else:
			if spootedByAnyone == true:
				_testInfantryTroop.Spotted = true
			else:
				_testInfantryTroop.Spotted = false
				*/
