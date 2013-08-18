import UnityEngine

partial class DataScript (MonoBehaviour, IData): 
	
	_position as Vector3
	[SerializeField] _name as string
	[SerializeField] _type as GameObjectTypeEnum
	_guiScript as GuiScript
	_ourID as int

	enum GameObjectTypeEnum:
		terrain
		building
		unit

	GameObjectType as GameObjectTypeEnum:
		get:
			return _type
		set:	
			_type = value

	Name as string:
		get:
			return _name
		set:
			_name = value

	Position as Vector3:
		get:
			return gameObject.transform.position
		set:
			gameObject.transform.position = value	

	def Start():
		_ourID = gameObject.GetInstanceID()
		_guiScript = LibraryScript.FindCamera().GetComponent[of GuiScript]()
		
	def Update():
		selected as GameObject= _guiScript.GetSelected()
		if selected == null or selected.GetInstanceID() != _ourID:
			IsSelected = false

	static def FindDataScript(gameObjectToSearch as GameObject) as DataScript:
		dataScript as DataScript = gameObjectToSearch.GetComponent[of DataScript]()
		return dataScript
