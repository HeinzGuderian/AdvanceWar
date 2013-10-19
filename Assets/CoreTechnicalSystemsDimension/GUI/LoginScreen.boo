import UnityEngine

partial class LoginScreen (MonoBehaviour): 

	ExitGameButtonImage as Texture
	NewGameButtonImage as Texture
	LoadGameButtonImage as Texture
	_gameState as GameState
	_postWEBScript as PostWEB
	_outputText as string = ""
	_encryption as Encryption
	
	_accountName as string = "AccountName"
	_accountNameSecure = ""
	_passwordPlainText as string = "password"
	_passwordCrypted as string = ""
	_LoginSaveLoad as SaveLoadGameSerialisable 
	
	_autoLogin = false
	_a = 1
	
	Name as string:
		get:
			return _accountNameSecure
		set:
			_accountNameSecure = value
			
	Password as string:
		get:
			return _passwordCrypted
		set:
			_passwordCrypted = value
	
	
	def Awake():
		ifdef not UNITY_WEBPLAYER:
			InitialiseSerialize()

	def Start ():
		a = BuildingScript
		print(a)
		_LoginSaveLoad = SaveLoadGameSerialisable("")
		_gameState = GameObject.Find('GameRules').GetComponent[of GameState]()
		assert _gameState != null
		_postWEBScript = _gameState.gameObject.GetComponent[of PostWEB]()
		_encryption = _gameState.gameObject.GetComponent[of Encryption]()
		ExitGameButtonImage = Resources.Load("Textures/Buttons/tx_button_mainmenu_exit", Texture)
		NewGameButtonImage = Resources.Load("Textures/tx_button_mainmenu_newgame", Texture)
		LoadGameButtonImage = Resources.Load("Textures/tx_button_mainmenu_options", Texture)
		print(Application.persistentDataPath)
		/*
		ifdef not UNITY_WEBPLAYER:
			try:
				_LoginSaveLoad.LoadLogin();
				TestLogin()
			except e as NotFoundException:
				pass
			*/
//		tx_mainmenu_exitgame

	def HandleLoginResponse(JSONstring as string):
		// Get Response
		responseHash as Boo.Lang.Hash = (PostWEB.ReadJSON(JSONstring) as List)[0]
		// Checks for error
		error = CheckForErrors(responseHash)
		if error:
			// Display error and return
			SetOutputText(responseHash["ErrorMessage"])
			return	
		// Set Player
		_gameState.AccountName = _accountNameSecure
		// Load main menu
		_gameState.LoadLevel("mainMenu")
		_outputText = responseHash.ToString()
		//Application.LoadLevel("mainMenu")
		
	def HandleCreateAccountResponse(JSONstring as string):
		// Get Response
		responseHash as Boo.Lang.Hash = (PostWEB.ReadJSON(JSONstring) as List)[0]
		// Checks for error
		error = CheckForErrors(responseHash)
		if error:
			// Display error and return
			SetOutputText(responseHash["ErrorMessage"])
			return
		// Else display success
		SetOutputText("Account was successfully created!")
		
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
		if GUI.Button(Rect(500,300,200,200),ExitGameButtonImage,""):
			Application.Quit()
		_accountName = GUI.TextField(Rect(200,200,200,50),_accountName)
		_passwordPlainText = GUI.PasswordField(Rect(200,250,200,50),_passwordPlainText,'*'[0], 100)
		
		_autoLogin = GUI.Toggle(Rect(300,500,200,100), _autoLogin, "Auto Login?")
		
		//_encryption.Encrypt(PasswordPlainText,Key)
		ifdef not UNITY_WEBPLAYER:
			if GUI.Button(Rect(100,300,200,200),"Login"):
				_accountNameSecure = _accountName
				_gameState.AccountName = _accountNameSecure
				if true == _autoLogin:
					_passwordCrypted = _encryption.Encrypt(_passwordPlainText,_gameState.Key)
					_LoginSaveLoad.SaveLogin()
				if _accountNameSecure == "test":
					_gameState.LocalGame = true
					_gameState.LoadLevel("mainMenu")
					
				else:
					_postWEBScript.SendDataStandard("Login",0,{"AccountName" : _accountName,"Password" : _encryption.Encrypt(_passwordPlainText,_gameState.Key)}, HandleLoginResponse)
				//Send login and password to server with callback
				
		if GUI.Button(Rect(300,300,200,200),"Create Account"):
			_postWEBScript.SendDataStandard("CreateAccount",0,{"AccountName" : _accountName,"Password" : _encryption.Encrypt(_passwordPlainText,_gameState.Key)}, HandleCreateAccountResponse)
		
		GUI.Label(Rect(200,100,200,100),_outputText,"")
		//GUI.Button(Rect(0,0,Screen.width,Screen.height),BackGroundImage,"")
		//GUI.Button(Rect(0,0,Screen.width,Screen.height),BackGroundImage,"")

	def TestLogin() as void:
		_postWEBScript.SendDataStandard("Login",0,{"AccountName" : _accountName,"Password" : _encryption.Encrypt(_passwordPlainText,_gameState.Key)}, HandleLoginResponse)