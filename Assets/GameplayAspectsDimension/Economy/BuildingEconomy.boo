import UnityEngine

class BuildingEconomy (MonoBehaviour, IAfterTeamSwitch): 
	_playerNumber as TeamScript.PlayerNumberEnum
	_library as LibraryScript
	_gameState as GameState
	_buildingScript as BuildingScript
	_playerEconomy as PlayerEconomy
	_playerScript as PlayerScript
	_currentPlayerGUI as GuiScript
	_playerObject as GameObject
	
	def OnTeamSwitch():
		UpdatePlayer()
	
	def UpdatePlayer():
		_playerNumber = TeamScript.FindTeamScript(gameObject).Player //( newbuyingObject.GetComponent("ITeam") as ITeam ).PlayerName
		unless _playerNumber == TeamScript.PlayerNumberEnum.none:
			_playerObject = _gameState.FindPlayerGameObject(_playerNumber)
			assert _playerObject != null
			
			_playerScript = _playerObject.GetComponent[of PlayerScript]()
			assert _playerScript != null
			
			_playerEconomy = PlayerEconomy.FindPlayerEconomy(_playerObject)
			assert _playerEconomy != null
			
	virtual def Start():
		_playerNumber = TeamScript.FindTeamScript(gameObject).Player //( newbuyingObject.GetComponent("ITeam") as ITeam ).PlayerName
		_playerObject  = _gameState.FindPlayerGameObject(_playerNumber)
		assert _playerObject != null
		_playerScript = _playerObject.GetComponent[of PlayerScript]()
		assert _playerScript != null
		_playerEconomy = PlayerEconomy.FindPlayerEconomy(_playerObject)
		assert _playerEconomy != null
	
	virtual def Awake():
		_library = GameObject.Find('GameRules').GetComponent[of LibraryScript]()
		_gameState = GameObject.Find('GameRules').GetComponent[of GameState]()
		assert _gameState != null
		
		
		currentPlayersGameObject = _library.FindCamera()
		_currentPlayerGUI = currentPlayersGameObject.GetComponent[of GuiScript]()
		
		

		
		
		

