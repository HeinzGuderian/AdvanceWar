import UnityEngine
import System.Math

class LibraryScript(MonoBehaviour): 
	gameState as GameState
	//_mainCamera as GameObject

	def Start():
		gameState = GameObject.Find('GameRules').GetComponent[of GameState]()
		//_mainCamera = GameObject.FindGameObjectWithTag('MainCamera')
		checkInit()
		
	def checkInit():
		if gameState==null:
			print("gameState is null")
		//if _mainCamera==null:
		//	_currentPlayerGUI.PrintToScreen("_mainCamera is null")
	
	def Update ():
		pass
		
	static def ExtendHash(orgHash as Boo.Lang.Hash, newHash as Boo.Lang.Hash):
		return orgHash if newHash == {} or newHash == null
		return {} if orgHash == null
		for pair in newHash as Boo.Lang.Hash:
			orgHash[pair.Key] = pair.Value
		
	static def parseIntToBool(intToBool as int):
		if intToBool == 0:
			return false
		elif intToBool == 1:
			return true
		else:
			raise "int to bool parse error, the int was not 0 or 1"
		
	static def CalculateGridRange(firstObject as GameObject, secondObject as GameObject) as int:
		//print((Vector3.Distance(firstObject.transform.position, secondObject.transform.position)%GameState.TERRAIN_SIDE_DISTANCE))
		////print((Vector3.Distance(firstObject.transform.position, secondObject.transform.position)cast double/GameState.TERRAIN_SIDE_DISTANCE cast double)cast double)
		//print("!")
		a =  (Vector3.Distance(firstObject.transform.position, secondObject.transform.position) cast double /GameState.TERRAIN_SIDE_DISTANCE cast double ) 
		if (Vector3.Distance(firstObject.transform.position, secondObject.transform.position)%GameState.TERRAIN_SIDE_DISTANCE) > 5:
			return Ceiling(a) cast int 
		return a
		 
	static def GetInterfaceComponents[of T](sourceObject as GameObject) as List:
		interfaceList as List = []
		for component as MonoBehaviour in sourceObject.GetComponents[of MonoBehaviour]():
			if component isa T:
				interfaceList.Add(component as T)
		return interfaceList
		
	static def GetInterfaceComponent[of T](sourceObject as GameObject) as MonoBehaviour:
		for component in sourceObject.GetComponents[of MonoBehaviour]():
			if component isa T:
				return component
		return null
		
	static def ReturnBoolVarIfNotAlreadySet(variable as bool, oldValue as bool, targetSet as bool) as bool:
		if oldValue == targetSet:
			return targetSet
		else:
			return variable

	def FindTerrain(newPosition as Vector3) as GameObject:
		
		CollidList = Physics.OverlapSphere(newPosition, gameState.TERRAIN_SPHERE_RADIUS)
		terrain as Collider 
		for ColliderObject in CollidList:
			if ColliderObject.tag == "Terrain":
				 terrain = ColliderObject	 
				 break
		if terrain != null:
			return terrain.gameObject
		else: 
			return null
			
	def FindObject(newPosition as Vector3):
		colliderList = Physics.OverlapSphere(newPosition, 20)	
		resultObject as UnityEngine.Collider = null
		resultObject = colliderList[0]
		if resultObject != null:
			return resultObject.gameObject
		else: 
			return null
			
			
	def FindObjectWithTag(newPosition as Vector3, tag as string, objectRadius as double):
		shipColliderList = Physics.OverlapSphere(newPosition, objectRadius)	
		planet as UnityEngine.Collider = null
		for SpaceObject in shipColliderList:
			if SpaceObject.tag == tag:
				 planet = SpaceObject
		if planet != null:
			return planet.gameObject
		else: 
			return null
			
	def FindObjectsWithTag(newPosition as Vector3, tag as string, objectRadius as double):
		shipColliderList = Physics.OverlapSphere(newPosition, objectRadius)	
		planetList as List = []
		planet as UnityEngine.Collider = null
		for SpaceObject in shipColliderList:
			if SpaceObject.tag == tag:
				 planet = SpaceObject
				 planetList.Add(planet.gameObject)
		if planetList.Count > 0:
			return planetList
		else: 
			return []
			
	def FindObjectsWithTagSearch(firstObject as GameObject, tag as string, objectRadius as double):
		curryedGetGridRange = { secondObject as GameObject | CalculateGridRange(firstObject , secondObject ) }
		shipColliderList = GameObject.FindGameObjectsWithTag(tag)
		planetList as List = []
		for SpaceObject as GameObject in shipColliderList:
			if curryedGetGridRange(SpaceObject) < objectRadius:
				 planetList.Add(SpaceObject)
		if planetList.Count > 0:
			return planetList
		else: 
			return []
			
			/*
	def FindPlayers():
		return GameObject.FindGameObjectsWithTag("Player")
*/

	/*	
	def RunFunctionForObjects(objects as List, function as string, team as PlayerScript.playerNumber):		
		for object1 as MonoBehaviour in objects:
			if (object1 as IData):
				if (object1 as IData).Player==team:
					object1.StartCoroutine(function as string,null)
				*/
	def RunFunctionForObjects(objects as object, function as string):		
		for object1 as MonoBehaviour in objects:
			object1.StartCoroutine(function as string,null)
	/*
	def SendMessageToGameObjects(objects as List, function as string, team as string, argument as object):		
		for object1 as GameObject in objects:
			object1Team as ITeam = object1.GetComponent("ITeam")
			if object1Team.PlayerName==team:
				object1.SendMessage(function as string, argument)
				
	def SendMessageToGameObjects(objects as List, function as string, team as string):		
		for object1 as GameObject in objects:
			object1Team as ITeam = object1.GetComponent("ITeam")
			if object1Team.PlayerName==team:
				object1.SendMessage(function as string,null)
				*/
				
	def SendMessageToGameObjects(objects as List, function as string):		
		for object1 as GameObject in objects:
			object1.SendMessage(function as string,null)	
			
			/*
	def SendMessageToGameObjects(objects as (UnityEngine.GameObject), function as string, team as string, argument as object):		
		for object1 as GameObject in objects:
			object1Team as ITeam = object1.GetComponent("ITeam")
			if object1Team.PlayerName==team:
				object1.SendMessage(function as string, argument)
				
	def SendMessageToGameObjects(objects as (UnityEngine.GameObject), function as string, team as string):		
		for object1 as GameObject in objects:
			object1Team as ITeam = object1.GetComponent("ITeam")
			if object1Team.PlayerName==team:
				object1.SendMessage(function as string,null)
				*/
	def SendMessageToGameObjects(objects as (UnityEngine.GameObject), function as string):		
		for object1 as GameObject in objects:
			object1.SendMessage(function as string,null)	
							
	def RemoveGameObjectInList(object1 as object, ref loopList as List):	
		for loopObject in loopList:
			if loopObject is object1:
				//Destroy(loopList[loopList.IndexOf(loopObject)] as GameObject)
				loopList.RemoveAt(loopList.IndexOf(loopObject))
				return true
		return false
		
	def GetIndexOfGameObjectInList(object1 as object, ref loopList as List):	
		index = 0
		for loopObject in loopList:
			if loopObject is object1:
				//Destroy(loopList[loopList.IndexOf(loopObject)] as GameObject)
				loopList.RemoveAt(loopList.IndexOf(loopObject))
				return index
			index +=1
		return null
		
	def RemoveObjectInListWithMap(unpack as List):	
		loopObject1 = unpack[0]
		loopList as List = unpack[1]
		for loopObject in loopList:
			if loopObject1 is loopObject:
				Destroy(loopList[loopList.IndexOf(loopObject)] as GameObject)
				loopList.RemoveAt(loopList.IndexOf(loopObject))
				return true
		return false
		
	// Returns a menu hash
	def ConvertToSelectMenuformat(name as string, thing as object):
		return {"GUIContent": GUIContent(name), "value": thing}
		
	static def FindCamera() as GameObject:
		return GameObject.FindGameObjectWithTag("MainCamera");
		
	def checkInit(*checkList) as void:
		for checkObject as object in checkList:
			assert checkObject != null
		
		