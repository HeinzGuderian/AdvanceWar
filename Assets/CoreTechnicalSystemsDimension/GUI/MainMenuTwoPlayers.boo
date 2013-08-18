import UnityEngine

class MainMenuTwoPlayers (MonoBehaviour): 
	ExitGameButtonImage as Texture
	NewGameButtonImage as Texture
	LoadGameButtonImage as Texture
	
	_gameState as GameState
	
	def Awake():
		pass

	def Start ():
		_gameState = GameObject.Find('GameRules').GetComponent[of GameState]()
		assert _gameState != null
		ExitGameButtonImage = Resources.Load("Textures/tx_button_mainmenu_exitgame", Texture)
		NewGameButtonImage = Resources.Load("Textures/tx_button_mainmenu_newgame", Texture)
		LoadGameButtonImage = Resources.Load("Textures/tx_button_mainmenu_options", Texture)
//		tx_mainmenu_exitgame
	
	def Update ():
		pass

	def OnGUI():
		
		if GUI.Button(Rect(0,0,200,200),ExitGameButtonImage,""):
			Application.Quit()
		if GUI.Button(Rect(200,0,200,200),NewGameButtonImage,""):
			_gameState = GameObject.Find('GameRules').GetComponent[of GameState]()
			_gameState.CurrentPlayer = TeamScript.PlayerNumberEnum.player1
			_gameState.GameID = 1
			Application.LoadLevel(1)
		if GUI.Button(Rect(200,200,200,200),NewGameButtonImage,""):
			_gameState = GameObject.Find('GameRules').GetComponent[of GameState]()
			_gameState.CurrentPlayer = TeamScript.PlayerNumberEnum.player2
			_gameState.GameID = 1
			Application.LoadLevel(1)
		//GUI.Button(Rect(0,0,Screen.width,Screen.height),BackGroundImage,"")
		//GUI.Button(Rect(0,0,Screen.width,Screen.height),BackGroundImage,"")
		
		