import UnityEngine

class SupplyTroopScript (MonoBehaviour, IMove, IGUI): 
	_library as LibraryScript
	_testInfantryTroop as TroopClass
	
	virtual def Actions():
		return []
		
	virtual def Info():
		return "Available Petrol: " + _testInfantryTroop.Petrol
	
	def Awake ():
		_library = (GameObject.Find('GameRules').GetComponent[of LibraryScript]() as LibraryScript)	
		_testInfantryTroop = gameObject.GetComponent[of TroopClass]()
		assert _testInfantryTroop != null
		// Set supply values
		//_testInfantryTroop.Ammo = 100
		//_testInfantryTroop.Petrol = 100
	 
	// targetTerrain is assumed validated	
	def AfterMove(targetTerrain as GameObject):
		cost = SupplyAspectClass.CalculateSupplyCost(_testInfantryTroop,targetTerrain)
		_testInfantryTroop.Petrol -= cost
