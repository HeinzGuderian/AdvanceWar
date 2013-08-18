import UnityEngine

class SupplyOilfieldScript (MonoBehaviour, IGameState): 
	_library as LibraryScript
	_oilfieldScript as OilfieldScript
	
	def Awake ():
		_library = (GameObject.Find('GameRules').GetComponent[of LibraryScript]() as LibraryScript)	
		_oilfieldScript = gameObject.GetComponent[of OilfieldScript]()
		assert _oilfieldScript != null
		// Set supply values
		//_testInfantryTroop.Ammo = 100
		//_testInfantryTroop.Petrol = 100

	def StartTurnActions():
		return
		
	def EndTurnActions():
		newStorageVAlue = _oilfieldScript.CurrentVRHold + _oilfieldScript.ProducedVRPerTurn
		_oilfieldScript.CurrentVRHold = newStorageVAlue unless newStorageVAlue > _oilfieldScript.MaxVRHold