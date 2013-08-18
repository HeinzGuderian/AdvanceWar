import UnityEngine
	
abstract class RaceScript (MonoBehaviour, IVictoryCondition):
	
	private _shipList as List = []
	protected _troopList as List = []
	
		
	ShipList as List:
		get:
			return _shipList
		set:
			_shipList = value
			
	TroopList as List:
		get:
			return _troopList
		set:
			_troopList = value

	static def FindRaceScript(gameObjectToSearch as GameObject):
		raceScript as RaceScript = gameObjectToSearch.GetComponent[of RaceScript]()
		return raceScript

