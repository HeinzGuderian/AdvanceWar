import UnityEngine
	
class GuerillaRace (RaceScript, IVictoryCondition):
	
	public VictoryResourcesGoal as int
	
	def CheckIfVictorious() as bool:
		// Get all the oilfields on the map
		oilfieldsGameObject as List = [OilfieldScript.gameObject for OilfieldScript as OilfieldScript in GameObject.FindObjectsOfType(OilfieldScript) ]
		// Check if each one belongs to the team
		playerTeam as TeamScript.PlayerNumberEnum = TeamScript.FindTeamScript(GameState.FindGameState().FindCurrentPlayerGameObject()).Player
		for oilfieldGO as GameObject in oilfieldsGameObject:
			if oilfieldGO.GetComponent[of TeamScript]().Player == playerTeam:
				continue
			else:
				// If one dosent then return false
				return false
		// Else we have total domination and return true
		return true

		// Old Victory Condition
		/* 
		// Get player economy 
		playerEcoScript = PlayerScript.FindPlayerScript(gameObject)
		assert playerEcoScript != null
		// Check if we have enough victory resourese.
		//a = VictoryResourcesGoal
		//b = playerEcoScript.VictoryResources
		if VictoryResourcesGoal <= playerEcoScript.VictoryResources:
			// If so then victory!
			return true
		else:
			return false
			*/
	def CheckIfHasLost() as bool:
		playerEcoScript = PlayerScript.FindPlayerScript(gameObject)
		assert playerEcoScript != null
		for building as GameObject in playerEcoScript.Buildings:
			if building == null:
				continue
			centralWarehouse as CentralWarehouseScript = building.GetComponent[of CentralWarehouseScript]()
			if centralWarehouse != null:
				if centralWarehouse.Health < 1:
					return true
				else:
					return false
		raise "Should not be reached. CheckIfHasLost"
			
	def Awake():
		//imperialShips as ImperialShips = gameObject.AddComponent('ImperialShips')
		//_shipList = imperialShips.ShipList
		_troopList = [ {"GUIContent" : GUIContent(Resources.Load("Textures/Buttons/tx_button_buyMechInf", Texture)), "value": Resources.Load("Troops_land/MechTroopPreFab"), "cost": MechTroop.ProductionCost}  ,
		{"GUIContent" : GUIContent(Resources.Load("Textures/Buttons/tx_button_buyArmored", Texture)), "value": Resources.Load("Troops_land/ArmoredTroopPreFab"), "cost": ArmoredTroop.ProductionCost} ,
		{"GUIContent" : GUIContent(Resources.Load("Textures/Buttons/tx_button_buyAntiAir", Texture)), "value": Resources.Load("Troops_land/AntiairTroopPreFab"), "cost": AntiairTroop.ProductionCost} ,
		{"GUIContent" : GUIContent(Resources.Load("Textures/Buttons/tx_button_buyArtillery", Texture)), "value": Resources.Load("Troops_land/ArtyTroopPreFab"), "cost": ArtyTroop.ProductionCost} ,
		{"GUIContent" : GUIContent(Resources.Load("Textures/Buttons/tx_button_buyMotoInf", Texture)), "value": Resources.Load("Troops_land/MotoTroopPreFab"), "cost": MotoTroop.ProductionCost} ,
		{"GUIContent" : GUIContent(Resources.Load("Textures/Buttons/tx_button_buyEngi", Texture)), "value": Resources.Load("Troops_land/EngineerTroopPreFab"), "cost": EngyTroop.ProductionCost} ,
		{"GUIContent" : GUIContent(Resources.Load("Textures/Buttons/tx_button_buyLogi", Texture)), "value": Resources.Load("Troops_land/LogisticsTroopPreFab"), "cost": LogiTroop.ProductionCost}
		]
		
		
