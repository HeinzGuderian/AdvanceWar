import UnityEngine
	
class BuildingMove(MonoBehaviour, IUseTerrain):
	_library as LibraryScript
	_factoryData as IData
	_factoryScript as BuildingScript
	
	[SerializeField]
	_occupiedTerrainGameObject as GameObject = null
	OccupiedTerrainGameObject as GameObject:
		get:
			return _occupiedTerrainGameObject
		set:
			_occupiedTerrainGameObject = value
	[SerializeField]
	_occupiedTerrain as TerrainScript
	OccupiedTerrain as TerrainScript:
		get:
			return _occupiedTerrain
		set:
			_occupiedTerrain = value
	
	def Awake():
		_library = (GameObject.Find('GameRules').GetComponent[of LibraryScript]() as LibraryScript)	
		
		_factoryScript = gameObject.GetComponent[of BuildingScript]()
		currentTerrainGameObject = _library.FindTerrain(gameObject.transform.position)
		_factoryScript.OccupiedTerrainGameObject = currentTerrainGameObject
		
		_factoryScript.OccupiedTerrain = currentTerrainGameObject.GetComponent("ITerrain")
		
		currentTerrain = _factoryScript.OccupiedTerrain
		currentTerrain.AddUnit(gameObject)
		
	def OnDestroy():
		_factoryScript.OccupiedTerrain.RemoveUnit(gameObject)
		