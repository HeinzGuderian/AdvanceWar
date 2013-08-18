import UnityEngine
	
class ImperialRace (RaceScript):

	def CheckIfVictorious():
		raise "CheckIfVictorious Not implemeted"
	
	def Awake():
		//imperialShips as ImperialShips = gameObject.AddComponent('ImperialShips')
		//_shipList = imperialShips.ShipList
		_troopList = [ {"GUIContent" : GUIContent("lightInfantry"), "value": Resources.Load("MechTroopPreFab"), "cost": MechTroop.ProductionCost}]