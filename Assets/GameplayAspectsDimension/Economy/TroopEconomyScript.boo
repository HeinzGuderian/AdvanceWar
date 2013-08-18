import UnityEngine

class TroopEconomyScript (MonoBehaviour): 
	_library as LibraryScript
	_testInfantryTroop as TroopClass
	
	
	def Awake ():
		_library = (GameObject.Find('GameRules').GetComponent[of LibraryScript]() as LibraryScript)	
		_testInfantryTroop = gameObject.GetComponent[of TroopClass]()
		assert _testInfantryTroop != null
		//_testInfantryTroop.ProductionCost = 100
	
	def Update ():
		pass

