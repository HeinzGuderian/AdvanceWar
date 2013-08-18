import UnityEngine

class NewGameMenu (MonoBehaviour): 

	//ExitGameButtonImage as Texture
	//NewGameButtonImage as Texture
	//LoadGameButtonImage as Texture
	
	BackToMainButtonImage as Texture
	InviteFriendButtonImage as Texture
	NextArmyButtonImage as Texture
	PrevArmyButtonImage as Texture
	RandomArmyButtonImage as Texture
		
	_gameState as GameState
	_postWEBScript as PostWEB
	_outputText as string = ""
	_encryption as Encryption
	
	_accountName as string = "AccountName"
	_accountNameSecure = ""
	_passwordPlainText as string = "password"
	
	_gotResponse = false
	
	def Awake():
		pass

	def Start ():
		_gameState = GameObject.Find('GameRules').GetComponent[of GameState]()
		assert _gameState != null
		_postWEBScript = _gameState.gameObject.GetComponent[of PostWEB]()
		assert _postWEBScript != null
		_encryption = _gameState.gameObject.GetComponent[of Encryption]()
		assert _encryption != null
		//ExitGameButtonImage = Resources.Load("Textures/tx_button_mainmenu_exitgame", Texture)
		//NewGameButtonImage = Resources.Load("Textures/tx_button_mainmenu_newgame", Texture)
		//LoadGameButtonImage = Resources.Load("Textures/tx_button_mainmenu_options", Texture)
		BackToMainButtonImage = Resources.Load("Textures/Buttons/tx_button_newgame_backtomain", Texture)
		InviteFriendButtonImage = Resources.Load("Textures/Buttons/tx_button_newgame_invitefriend", Texture)
		NextArmyButtonImage = Resources.Load("Textures/Buttons/tx_button_newgame_nextarmy", Texture)
		PrevArmyButtonImage = Resources.Load("Textures/Buttons/tx_button_newgame_prevarmy", Texture)
		RandomArmyButtonImage = Resources.Load("Textures/Buttons/tx_button_newgame_random", Texture)
		
		//assert ExitGameButtonImage != null
		//assert NewGameButtonImage != null
		//assert LoadGameButtonImage != null
		assert BackToMainButtonImage != null
		assert InviteFriendButtonImage != null
		assert NextArmyButtonImage != null
		assert PrevArmyButtonImage != null
		assert RandomArmyButtonImage != null
//		tx_mainmenu_exitgame

	def HandleNewGameResponse(JSONstring as string):
		// Get Response
		responseHash as Boo.Lang.Hash = (PostWEB.ReadJSON(JSONstring) as List)[0]
		/*
		// Checks for error
		error = CheckForErrors(responseHash)
		if error:
			// Display error and return
			SetOutputText(responseHash["ErrorMessage"])
			return	
			*/
		// Set Player
		//_gameState.AccountName = _accountNameSecure
		_outputText = responseHash["Message"]
		_gotResponse = true
		// Load main menu
		//Application.LoadLevel("mainMenu")
		
	def SetOutputText(outputString as string):
		_outputText = outputString
		
	// Checks for errors, returns error string if error, otherwise return an empty string
	def CheckForErrors(responseHash as Boo.Lang.Hash) as bool:
		// Check if userName is faulty
		if responseHash["UserError"] == "true":
			return true
		// Check if password is faulty
		if responseHash["PasswordError"] == "true":
			return true
		return false	
	
	def OnGUI():
		leftPadding = 27
		bigButtonWidth = 316
		bigButtonHeight = 123
		randomYPadding = 200
		if _gotResponse == false:
			/*
			BackToMainButtonImage as Texture
			InviteFriendButtonImage as Texture
			NextArmyButtonImage as Texture
			PrevArmyButtonImage as Texture
			RandomArmyButtonImage as Texture
			*/
			if GUI.Button(Rect(leftPadding, 334, bigButtonWidth, bigButtonHeight), BackToMainButtonImage, ""):
				_gameState.LoadLevel("mainMenu")
				
				
			if GUI.Button(Rect(455, randomYPadding, bigButtonWidth, bigButtonHeight), InviteFriendButtonImage, ""):
				pass
			if GUI.Button(Rect(189, 200, 154, 123), NextArmyButtonImage, ""):
				pass
			if GUI.Button(Rect(leftPadding, 200, 154, 123), PrevArmyButtonImage, ""):
				pass
			if GUI.Button(Rect(455, 334, bigButtonWidth, bigButtonHeight), RandomArmyButtonImage,""):
				_postWEBScript.SendDataStandard("FindGames",0,{"AccountName": _gameState.AccountName ,"MapID": 0}, HandleNewGameResponse)
			
		else:
			GUI.Label(Rect(200,100,200,200),_outputText,"")
			if GUI.Button(Rect(200, 300, 200, 100), "Okay, Back to menu"):
				_gameState.LoadLevel("mainMenu")
			
