import UnityEngine
import testExtension

class CombatTroop (MonoBehaviour, IGUI, IGameState): 
	//_hasPlayedTurn as bool
	_library as LibraryScript
	_testInfantryData as DataScript
	_testInfantryTroop as TroopClass
	_CombatResult as int
	_highlightedTerrains as List = []
	_searchFunction as callable
	_searchCentralWarehouse as callable
	_currentPlayerGUI as GuiScript
	_attackMarkers = []
	
	_resultScreen as Texture
	_resultRect = Rect(100, 100, 512, 256)
	_leftRowBoxRects as (Rect) = (Rect(15,162,200,20),Rect(15,182,200,20),Rect(15,202,200,20),Rect(15,222,200,20))
	_leftRowBoxTexts as (string) = array(string,4)
	_displayResult as bool = false
	_enemyCombatResultInitiative = 0
	_finalSelfTarget = 0
	_finalTargetDamage = 0
	_targetTroop as TroopClass
	
	guiState as combatGuiState = combatGuiState.noCombat
	
	final _attackCost as int = 40
	
	//GUI.Button(Rect(0, 0, 100, 20), GUIContent('Click me', icon))
	
		
	resultScreens as (Texture) = array(Texture,3)
	public ButtonImage as Texture
	
	final SAME_TEAM as string = "A unit won't attack a friendly."
	final CLICKED_ON_SELF as string = "A unit won't attack itself."
	final TO_LOW_AP as string = "The unit has to few actionpoints."
	final CLICKED_NONE_UNIT as string = "Clicked object was not a unit." 
	final UNIT_TO_FAR_AWAY as string = "The target is to far away." 
	
	enum CombatResult:
			Victory = 0
			Draw = 1
			Defeat = 2
			
	enum combatGuiState:
		noCombat
		showingScreen
		screenDone
	
	// Table for assigning terrain modfyers for different terrain types 
	public final MovementTypeTerrainTable = {
		MechTroop as System.Type: {TerrainScript.TerrainTypeEnum.plain: 1.0, TerrainScript.TerrainTypeEnum.forrest: 1.2, TerrainScript.TerrainTypeEnum.hill: 12, TerrainScript.TerrainTypeEnum.water: 0, TerrainScript.TerrainTypeEnum.lowDensityBuildings: 1.3, TerrainScript.TerrainTypeEnum.highDensityBuildings: 1.6 } ,
		ArmoredTroop as System.Type: {TerrainScript.TerrainTypeEnum.plain: 1.0, TerrainScript.TerrainTypeEnum.forrest: 1.2, TerrainScript.TerrainTypeEnum.hill: 12, TerrainScript.TerrainTypeEnum.water: 0, TerrainScript.TerrainTypeEnum.lowDensityBuildings: 1.3, TerrainScript.TerrainTypeEnum.highDensityBuildings: 1.6 } ,
		ArtyTroop as System.Type: {TerrainScript.TerrainTypeEnum.plain: 1.0, TerrainScript.TerrainTypeEnum.forrest: 1.2, TerrainScript.TerrainTypeEnum.hill: 12, TerrainScript.TerrainTypeEnum.water: 0, TerrainScript.TerrainTypeEnum.lowDensityBuildings: 1.3, TerrainScript.TerrainTypeEnum.highDensityBuildings: 1.6 } ,
		EngyTroop as System.Type: {TerrainScript.TerrainTypeEnum.plain: 1.0, TerrainScript.TerrainTypeEnum.forrest: 1.2, TerrainScript.TerrainTypeEnum.hill: 12, TerrainScript.TerrainTypeEnum.water: 0, TerrainScript.TerrainTypeEnum.lowDensityBuildings: 1.3, TerrainScript.TerrainTypeEnum.highDensityBuildings: 1.6 } ,
		AntiairTroop as System.Type: {TerrainScript.TerrainTypeEnum.plain: 1.0, TerrainScript.TerrainTypeEnum.forrest: 1.2, TerrainScript.TerrainTypeEnum.hill: 12, TerrainScript.TerrainTypeEnum.water: 0, TerrainScript.TerrainTypeEnum.lowDensityBuildings: 1.3, TerrainScript.TerrainTypeEnum.highDensityBuildings: 1.6 } ,
		MotoTroop as System.Type: {TerrainScript.TerrainTypeEnum.plain: 1.0, TerrainScript.TerrainTypeEnum.forrest: 1.2, TerrainScript.TerrainTypeEnum.hill: 12, TerrainScript.TerrainTypeEnum.water: 0, TerrainScript.TerrainTypeEnum.lowDensityBuildings: 1.3, TerrainScript.TerrainTypeEnum.highDensityBuildings: 1.6 } ,
		LogiTroop as System.Type: {TerrainScript.TerrainTypeEnum.plain: 1.0, TerrainScript.TerrainTypeEnum.forrest: 1.2, TerrainScript.TerrainTypeEnum.hill: 12, TerrainScript.TerrainTypeEnum.water: 0, TerrainScript.TerrainTypeEnum.lowDensityBuildings: 1.3, TerrainScript.TerrainTypeEnum.highDensityBuildings: 1.6 } ,
		CommTroop as System.Type: {TerrainScript.TerrainTypeEnum.plain: 1.0, TerrainScript.TerrainTypeEnum.forrest: 1.2, TerrainScript.TerrainTypeEnum.hill: 12, TerrainScript.TerrainTypeEnum.water: 0, TerrainScript.TerrainTypeEnum.lowDensityBuildings: 1.3, TerrainScript.TerrainTypeEnum.highDensityBuildings: 1.6 }
	}
	
	/*{
		MechTroop as System.Type: {TerrainScript.TerrainTypeEnum.plain: 1.0, TerrainScript.TerrainTypeEnum.forrest: 1.2} ,
		LogiTroop as System.Type: {TerrainScript.TerrainTypeEnum.plain: 1.0, TerrainScript.TerrainTypeEnum.forrest: 1.2}
	}*/
	
		 
	
	def Start ():
		_searchFunction = {ourTeam as TeamScript.PlayerNumberEnum  |  return { x as GameObject | return  DataScript.FindDataScript(x).GameObjectType == DataScript.GameObjectTypeEnum.unit and ourTeam != TeamScript.FindTeamScript(x).Player and TroopClass.FindTroopScript(x).Spotted}}
		_searchCentralWarehouse = {ourTeam as TeamScript.PlayerNumberEnum  |  return { x as GameObject | return (DataScript.FindDataScript(x).GameObjectType == DataScript.GameObjectTypeEnum.building and ourTeam != TeamScript.FindTeamScript(x).Player and x.GetComponent[of CentralWarehouseScript]() != null)}}
		//_searchFunction = {ourTeam as TeamScript.PlayerNumberEnum  |  return { _ | return  false}}
		//_searchFunction = { return  true}
		_library = (GameObject.Find('GameRules').GetComponent[of LibraryScript]() as LibraryScript)	
		_testInfantryTroop = gameObject.GetComponent[of TroopClass]()
		assert _testInfantryTroop != null
		_testInfantryData = gameObject.GetComponent[of DataScript]()
		assert _testInfantryData != null 
		currentPlayersGameObject = _library.FindCamera()
		_currentPlayerGUI = currentPlayersGameObject.GetComponent[of GuiScript]()
		ButtonImage = Resources.Load("Textures/Buttons/tx_button_combat", Texture)
		resultScreens[0] = Resources.Load("Textures/tx_event_victory", Texture)
		resultScreens[1] = Resources.Load("Textures/tx_event_draw", Texture)
		resultScreens[2] = Resources.Load("Textures/tx_event_defeat", Texture)
		checkInit()

	
	def checkInit():
		if _library == null:
			print("Error: CombatTroop _library is null.")
		if _testInfantryTroop == null:
			print("Error: CombatTroop _testInfantryTroop is null.")
		if _testInfantryData == null:
			print("Error: CombatTroop _testInfantryData is null.")
	
	def StartTurnActions():
		return
	
	def EndTurnActions():
		return
	
	def Info():
		return ""
		
	def Actions():
		actions = [{"name"  : "Combat", "image":ButtonImage, "object": self as MonoBehaviour, "function"  : self.InitiateCombat as callable , "requireMouseClick" : 0, "requireSelected" : true, "RunWaitFunction" : true ,"WaitFunction": self.HighlightCombatUnits,"ShouldRevertWaitFunction":true, "RevertWaitFunction": self.DeHighlightCombatUnits}]
		//{"name"  : "Overwhatch", "image":ButtonImage, "object": self as MonoBehaviour, "function"  : self.OverWhatch as callable , "requireMouseClick" : 0, "requireSelected" : false, "RunWaitFunction" : false ,"WaitFunction": null,"ShouldRevertWaitFunction":false, "RevertWaitFunction": null}]
		return actions
	
	def Update ():
		pass
		
	def OnGUI():
		if _displayResult == true:
			guiState = combatGuiState.showingScreen
			
			GUI.BeginGroup(_resultRect)
			if GUI.Button(Rect(430,210,512-435 ,256-215),GUIContent(ButtonImage)):
				_displayResult = false
				guiState = combatGuiState.screenDone
				applyAndHandleDamage()
				guiState = combatGuiState.noCombat
				
				
			GUI.EndGroup()
			GUI.Button(_resultRect,GUIContent(_resultScreen))
			GUI.BeginGroup(_resultRect)
			for index in range(len(_leftRowBoxRects)):
				GUI.Label(_leftRowBoxRects[index],_leftRowBoxTexts[index])
			GUI.EndGroup()
		
	/**
	Uses the remaining ap for 
	*/
	def OverWhatch():
		remainingAP = _testInfantryTroop.ActionPoints
		ifdef UNITY_EDITOR:
			assert remainingAP > -1
		_testInfantryTroop.ActionPoints = 0
		_testInfantryTroop.OverWhatchNumber = remainingAP
		return
		
	def AllowedToMove(targetTerrain as GameObject, movingTroopClass as TroopClass):
		// Do we have OverwhatchAP left?
		if _testInfantryTroop.OverWhatchNumber >= 0:
			// If not exit with positive value.
			return true  
		// Check if enemy.
		if TeamScript.IsSameTeam( TeamScript.FindTeamScript(movingTroopClass.gameObject), TeamScript.FindTeamScript(gameObject)):
			// If enemy exit with positive value
			return true  
		// Is in range?
		if LibraryScript.CalculateGridRange(targetTerrain.gameObject, gameObject):
			// If not exit with positive value 
		  	return true
		// Attack with intiative bonus if we are not spotted
		if _testInfantryTroop.Spotted == true:
			_testInfantryTroop.CombatInitiative += 1
		InitiateCombat(movingTroopClass.gameObject)
		return false
		
					
	def attackCentralWarehouse(targetGO as CentralWarehouseScript) as bool :
		distanceBetweenCombatants = _library.CalculateGridRange(gameObject, targetGO.gameObject)
		softDamageResult = 0
		hardDamageResult = 0
		for weaponSystem as TroopClass.WeaponSystem in _testInfantryTroop.WeaponList:
			if distanceBetweenCombatants <= weaponSystem.Range:
				// Check that the damage after defence value consideration is not below minimum damage
				softDamage = (weaponSystem.SoftDamage*(_testInfantryTroop.Health/_testInfantryTroop.MaxHealth))
				if softDamage < weaponSystem.SoftMinimumDamage:
					softDamage = weaponSystem.SoftMinimumDamage
				softDamageResult += softDamage
				
				// Check that the damage after defence value consideration is not below minimum damage
				hardDamage = (weaponSystem.HardDamage*(_testInfantryTroop.Health/_testInfantryTroop.MaxHealth))
				if hardDamage < weaponSystem.HardMinimumDamage:
					hardDamage = weaponSystem.HardMinimumDamage
				hardDamageResult += hardDamage
				
		
		//_currentPlayerGUI.PrintToScreen()
		totalDamage = softDamageResult+hardDamageResult
		targetGO.Health -=totalDamage
		
		return targetGO.Health < 1
			
	/* Orchester function to handle combat.
	Will calculate damage between the combatans and will handle modifiers.
	Will set new health and possibly remove objects.
	
	*/
	def InitiateCombat(targetGO as GameObject) as System.Collections.IEnumerator:
		// Need to select ourself, seance we cicked on the target and then the target became selected
		_testInfantryData.SetSelected()
		
		// Check variables
		assert targetGO != null
		if targetGO.GetInstanceID() == gameObject.GetInstanceID():
			_currentPlayerGUI.PrintToScreen(CLICKED_ON_SELF)
			return
			
		_targetCentralWarehouse = targetGO.GetComponent[of CentralWarehouseScript]()
		if( _targetCentralWarehouse != null ):
			//isDestroyed as bool = attackCentralWarehouse(_targetCentralWarehouse)
			return
		else:	
			_targetTroop = targetGO.GetComponent[of TroopClass]()
			if(not _targetTroop isa TroopClass  ):
				_currentPlayerGUI.PrintToScreen(CLICKED_NONE_UNIT)
				return
		ourTeam as TeamScript = TeamScript.FindTeamScript(gameObject)
		assert ourTeam != null
		enemyTeam as TeamScript = TeamScript.FindTeamScript(targetGO)
		assert enemyTeam != null
		if (TeamScript.IsSameTeam(ourTeam,enemyTeam) ):
			_currentPlayerGUI.PrintToScreen(SAME_TEAM)
			return
		if _testInfantryTroop.ActionPoints < _attackCost:
			return
		weaponRanges = [weaponStruct.Range for weaponStruct as TroopClass.WeaponSystem in _testInfantryTroop.WeaponList].Sort()
		maxWeaponRange as int = weaponRanges.ToArray()[-1]
		if maxWeaponRange < LibraryScript.CalculateGridRange(targetGO, gameObject):
			_currentPlayerGUI.PrintToScreen(UNIT_TO_FAR_AWAY)
			return

		MoveTestTroop.ChangeFacingTowards(gameObject, targetGO)
		MoveTestTroop.ChangeFacingTowards(targetGO, gameObject)
		SetAnimation(gameObject,"attack")
		SetAnimation(targetGO,"attack")
		yield WaitForSeconds(2)
		
		guiState = combatGuiState.showingScreen
		//SetAnimation(gameObject,"attack");
		/*
		print(gameObject.GetComponentsInChildren[of Animation]())
		a = gameObject.GetComponentsInChildren[of Animation]()
		for currentAnimation as Animation in gameObject.GetComponentsInChildren[of Animation]():
			c = currentAnimation
			for animationState as AnimationState in currentAnimation as Animation:
				b = animationState
				if animationState.name == "attack" :
					print("111")
					currentAnimation.Play ("attack",PlayMode.StopAll);
					*/
					
		/// Calculate damage
		damagedMadeToTarget = attackDamage(_testInfantryTroop, _targetTroop)
		//player1DamagedString = "Player 1 inflicted "+damagedMadeToTarget+" damage."
		damagedMadeToSelf  = attackDamage(_targetTroop, _testInfantryTroop )
		//player2DamagedString = "\nPlayer 2 inflicted "+damagedMadeToTarget+" damage."
		//_currentPlayerGUI.PrintToScreen(player1DamagedString+player2DamagedString)
		
		/// Compeare intiative
		// Lower intiative unit will suffer a negative attack hit modifier, representing lower ability to bring firepower towards the enemy
		

		firendlyInitiative = _testInfantryTroop.BaseInitiative
		firendlyInitiative += _testInfantryTroop.CombatInitiative
		
		enemyInitiative = _targetTroop.BaseInitiative
		enemyInitiative += _targetTroop.CombatInitiative
		
		thisUnitHitModifier as double = 1
		targetUnitHitModifier as double = 1
		
		lowerInititaiveValue = { magnitude as double | 1 - 0.1*magnitude}
		if firendlyInitiative > enemyInitiative:
			thisUnitHitModifier = lowerInititaiveValue(firendlyInitiative-enemyInitiative)
		elif firendlyInitiative < enemyInitiative:
			targetUnitHitModifier = lowerInititaiveValue(enemyInitiative-firendlyInitiative)
		else:
			pass
		
		/// calculate modifiers
		// add modifier toghter to a joint damage modify value
		random as System.Random = System.Random(System.DateTime.Now.Millisecond)
		randNumber1 as double = random.Next(7,12 ) * 0.1
		_finalTargetDamage = damagedMadeToTarget * attackerModifier(_testInfantryTroop) * thisUnitHitModifier * randNumber1
		randNumber2 as double = random.Next(7,12 ) * 0.1
		_finalSelfTarget = damagedMadeToSelf * defenderModifier(_targetTroop) * targetUnitHitModifier * randNumber2
		

		/// Set new health
		_testInfantryTroop.Health -= _finalSelfTarget
		_targetTroop.Health -= _finalTargetDamage
		
		/// Calculate result and show result screen
		// calculate damage difference
		damageDifference as int =  _finalTargetDamage - _finalSelfTarget
		bigDifference = 10
		
			
			
		resultFlag as CombatResult
		// If we have made much more damage
		if damageDifference > 0 and damageDifference >= bigDifference:
			// Flag victory
			resultFlag = CombatResult.Victory
		// Else if the difference was not great
		elif (damageDifference >= 0 and damageDifference <= bigDifference) or (damageDifference <= 0 and damageDifference >= -bigDifference):
			// Flag draw
			resultFlag = CombatResult.Draw
		// Else if the enemy made more damage
		elif damageDifference <= 0 and damageDifference <= -bigDifference:
			// Flag defeat
			resultFlag = CombatResult.Defeat
		// There should be no else case.	
		else:
			raise "Damage was wrong: "+damageDifference.ToString()
			// Raise error
		
		
		
		// Decleare result screen
		// Check the result flag
			// Calculate and save initiative for the units according to the result flag
			// Set result screen according to result flag
			
		// Set displayResult
		
		initiativeDiffFriendly as int = 0
		initiativeDiffEnemy as int = 0
		if resultFlag == CombatResult.Victory:
			initiativeDiffFriendly +=1
			initiativeDiffEnemy -= 1
			_resultScreen = resultScreens[0]
			
		elif resultFlag == CombatResult.Draw:
			initiativeDiffFriendly =0
			initiativeDiffEnemy = 0
			_resultScreen = resultScreens[1]
		elif resultFlag == CombatResult.Defeat:		
			initiativeDiffFriendly -=1
			initiativeDiffEnemy += 1
			_resultScreen = resultScreens[2]
			
		// Set text
		_leftRowBoxTexts[0] = "Enemy Initiative Bonus       : "+initiativeDiffFriendly.ToString()
		_leftRowBoxTexts[1] = "Friendly Initiative Bonus      : "+initiativeDiffEnemy.ToString()
		_leftRowBoxTexts[2] = "Damaged done by us         : "+_finalTargetDamage.ToString()
		_leftRowBoxTexts[3] = "Damaged done by enemy   : "+_finalSelfTarget.ToString()

		_testInfantryTroop.CombatInitiative = initiativeDiffFriendly
		_targetTroop.CombatInitiative = initiativeDiffEnemy
		_enemyCombatResultInitiative = initiativeDiffEnemy
		
		_displayResult = true
		// Display result screen
		// Display Text
		SetAnimation(gameObject,"idle")
		SetAnimation(targetGO,"idle")
		
		_testInfantryTroop.ActionPoints -= _attackCost
		yield
			
	def applyAndHandleDamage():
		// Set and handle new health for the two units
		if(_targetTroop.Health-_finalTargetDamage <= 0):
			Destroy(_targetTroop.gameObject)
			
		if(_testInfantryTroop.Health-_finalSelfTarget <= 0):
			Destroy(gameObject)
		
	/**  Calculate the amount of damage done to the target.
	Pure function, does not alter values in the defending object
	*/
	def attackDamage(attacking as TroopClass, defending as TroopClass) as int:
		softDamageResult as int = 0
		hardDamageResult as int = 0
		distanceBetweenCombatants = _library.CalculateGridRange(attacking.gameObject, defending.gameObject)
		print("Distance: "+ distanceBetweenCombatants.ToString())
		for weaponSystem as TroopClass.WeaponSystem in attacking.WeaponList:
			// Check target in range for the weapon system
			
			if distanceBetweenCombatants <= weaponSystem.Range:
				// Check that the damage after defence value consideration is not below minimum damage
				softDamage = (weaponSystem.SoftDamage*(attacking.Health/attacking.MaxHealth) - defending.SoftDefence)
				if softDamage < weaponSystem.SoftMinimumDamage:
					softDamage = weaponSystem.SoftMinimumDamage
				softDamageResult += softDamage
				
				// Check that the damage after defence value consideration is not below minimum damage
				hardDamage = (weaponSystem.HardDamage*(attacking.Health/attacking.MaxHealth) - defending.HardDefence)
				if hardDamage < weaponSystem.HardMinimumDamage:
					hardDamage = weaponSystem.HardMinimumDamage
				hardDamageResult += hardDamage
				
		
		//_currentPlayerGUI.PrintToScreen()
		totalDamage = softDamageResult+hardDamageResult
		
		return totalDamage
		
		//return 1
		
	def attackerModifier(attacker as TroopClass) as double:
		return terrainCombatModifier(attacker, TerrainScript.TerrainTypeEnum.plain)
		
	def defenderModifier(defender as TroopClass) as double:
		return terrainCombatModifier(defender, TerrainScript.TerrainTypeEnum.plain)

	// TODO Not finsihed not used yet
	def hitCalculation(attacker as TroopClass, defender as TroopClass) as double:
		raise "Not implemented hitCalculation"
		//return -1
		//attackerStrength = (attacker.Health/attacker.MaxHealth)
		
	def terrainCombatModifier(troopObject as  UnityEngine.Object, terrain as TerrainScript.TerrainTypeEnum) as double:
		assert troopObject != null
		//a = troopObject.GetType()
		assert MovementTypeTerrainTable[troopObject.GetType()] != null
		modifier as double = (MovementTypeTerrainTable[troopObject.GetType()] as Boo.Lang.Hash)[terrain]
		return modifier
	
	def FarthestWeaponRange() as int:
		longestRange as int = 0
		for weaponSystem as TroopClass.WeaponSystem in _testInfantryTroop.WeaponList:
			if weaponSystem.Range > longestRange:
				longestRange = weaponSystem.Range
		return longestRange
				
	def HighlightCombatUnits():
		if _testInfantryTroop.ActionPoints < _attackCost:
			_currentPlayerGUI.PrintToScreen(TO_LOW_AP)
			return
		// Highlight terrain that you can build on.
		startTerrain as TerrainScript = TerrainScript.FindTerrainScript(_testInfantryTroop.OccupiedTerrainGameObject)
		ourTeam as TeamScript.PlayerNumberEnum = TeamScript.FindTeamScript(gameObject).Player
		count as int = 0
		
		range as int = FarthestWeaponRange()
		_highlightedTerrains = []
		searchedTerrain = []
		
		print(System.DateTime.Now)
		print(System.DateTime.Now.Millisecond)
		startTerrain.RecursiveTerrainObjectsSearchGrids(startTerrain, ourTeam, count , range , _highlightedTerrains, _searchFunction(ourTeam), searchedTerrain)
		print(System.DateTime.Now)
		print(System.DateTime.Now.Millisecond)
		
		print(System.DateTime.Now)
		print(System.DateTime.Now.Millisecond)
		startTerrain.RecursiveTerrainObjectsSearchGrids(startTerrain, ourTeam, count , range , _highlightedTerrains, _searchCentralWarehouse(ourTeam), searchedTerrain)
		print(System.DateTime.Now)
		print(System.DateTime.Now.Millisecond)
		//startTerrain.RecursiveTerrainObjectsSearchGrids(startTerrain, ourTeam, count , range , _highlightedTerrains, _searchFunction(ourTeam), searchedTerrain)
		 
			
		for go as TroopClass in [(TroopClass.FindTroopScript(go) as TroopClass) for go as GameObject in _highlightedTerrains ]:
			_attackMarkers.Add(Instantiate(UnityEngine.Resources.Load('Effects/IndicatorTargetEnemies'), go.gameObject.transform.position, Quaternion.identity))
			//(go as IHighlight).Highlight()
			
	def DeHighlightCombatUnits():
		for marker in _attackMarkers:
			Destroy(marker)
		_attackMarkers = []