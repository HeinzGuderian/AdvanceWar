import UnityEngine

class testsceneMenu (MonoBehaviour): 
	_gameState as GameState
	def Start ():
		_gameState = GameObject.Find('GameRules').GetComponent[of GameState]()
	
	def Update ():
		pass
		
	def OnGUI(): 
		if GUI.Button(Rect(100,80,80,80),"Play 01"):
			SetupGameState(-1,0)
			_gameState.LoadLevel("level01")
			
		if GUI.Button(Rect(200,80,80,80),"Play 03"):
			SetupGameState(-3,2)
			_gameState.LoadLevel("level03")
			
		if GUI.Button(Rect(300,80,80,80),"Reset 01"):
			SetupGameState(-1,0)
			_gameState.ResetGame = true
			_gameState.LoadLevel("level01")
			
		if GUI.Button(Rect(400,80,80,80),"Reset 03"):
			SetupGameState(-3,2)
			_gameState.ResetGame = true
			_gameState.LoadLevel("level03")

	def SetupGameState(GameID as int, MapID as int):
		
		_gameState.CurrentPlayer = TeamScript.PlayerNumberEnum.player1 // as TeamScript.PlayerNumberEnum
		_gameState.GameID = GameID 
		_gameState.MapID = MapID
		_gameState.Player1AccountName = "test1"
		_gameState.Player2AccountName = "test2"
		
		_gameState.Player1HaveWon = false 
		_gameState.Player2HaveWon = false 
		_gameState.Player1HaveConcede = false 
		_gameState.Player2HaveConcede = false 
		
		_gameState.EnemyHaveConceded = false
		_gameState.LocalGame = true