import UnityEngine

class MainMenu (MonoBehaviour): 
	ContactsButtonImage as Texture
	ExitGameButtonImage as Texture
	GameListButtonImage as Texture
	GameListItemButtonImage as Texture
	GameListScrollButtonImage as Texture
	HelpButtonImage as Texture
	MessagesButtonImage as Texture
	OptionsButtonImage as Texture
	StoreButtonImage as Texture
	NewGameButtonImage as Texture
	LoadGameButtonImage as Texture
	ScrollDownButtonImage as Texture
	ScrollUppButtonImage as Texture
	UpdateButtonImage as Texture
	
	_postWEBScript as PostWEB
	_gameState as GameState
	_gameList as List = []
	_startItem = 0
	_endItem = 5
	
	static final NotificationsTypes as List = ["Yes/No"]
	
	def Awake():
		pass

	def Start ():
		_gameState = GameObject.Find('GameRules').GetComponent[of GameState]()
		assert _gameState != null
		_postWEBScript = _gameState.gameObject.GetComponent[of PostWEB]()
		ContactsButtonImage = Resources.Load("Textures/tx_button_mainmenu_contacts", Texture)
		ExitGameButtonImage = Resources.Load("Textures/tx_button_mainmenu_exit", Texture)
		//GameListButtonImage = Resources.Load("Textures/tx_button_mainmenu_exitgame", Texture)
		GameListItemButtonImage = Resources.Load("Textures/tx_button_mainmenu_gamelistitem", Texture)
		GameListScrollButtonImage = Resources.Load("Textures/tx_button_mainmenu_gamelistscroll", Texture)
		HelpButtonImage = Resources.Load("Textures/tx_button_mainmenu_help", Texture)
		MessagesButtonImage = Resources.Load("Textures/tx_button_mainmenu_messages", Texture)
		StoreButtonImage = Resources.Load("Textures/tx_button_mainmenu_store", Texture)
		OptionsButtonImage = Resources.Load("Textures/tx_button_mainmenu_options", Texture)
		NewGameButtonImage = Resources.Load("Textures/tx_button_mainmenu_newgame", Texture)
		LoadGameButtonImage = Resources.Load("Textures/tx_button_mainmenu_options", Texture)
		ScrollDownButtonImage = Resources.Load("Textures/Buttons/tx_button_listcontrol2", Texture)
		ScrollUppButtonImage = Resources.Load("Textures/Buttons/tx_button_listcontrol1", Texture)
		UpdateButtonImage = Resources.Load("Textures/Buttons/tx_button_listcontrol3", Texture)
//		tx_mainmenu_exitgame
	

		
	def HandleRefreshResponse(JSONstring as string):
		// Get Response
		responseList as List = (PostWEB.ReadJSON(JSONstring) as List)
		hashesToRemove = []
		for hash as Boo.Lang.Hash in responseList:
			
			//for pair in hash as Boo.Lang.Hash:
			//	print("Pair: Key:"+pair.Key+" ValueType:"+pair.Value.GetType()+" Value:"+ pair.Value+"\n")
				
			hash["enemy_player_has_conceded"] = false
			if hash["Player1"] == _gameState.AccountName:
				if (hash["Player1HaveConceded"]) == 1:
					hash["Player1HaveConceded"] = true
					hash["Player2HaveConceded"] = false
					hashesToRemove.Add(hash)
				if hash["Player2HaveConceded"] == 1:
					hash["Player1HaveConceded"] = false
					hash["Player2HaveConceded"] = true
					hash["enemy_player_has_conceded"] = true
				
				if hash["WhosTurn"] == 1:
					hash["our_turn"] = false
				else:
					hash["our_turn"] = true
				hash["our_player"] = TeamScript.PlayerNumberEnum.player1
				hash["enemy_player"] = TeamScript.PlayerNumberEnum.player2
				hash["enemy_player_name"] = hash["Player2"]
				//hash.Remove("Player1")
				//hash.Remove("Player2")
			elif hash["Player2"] == _gameState.AccountName:
				if hash["Player2HaveConceded"] == 1:
					hash["Player1HaveConceded"] = false
					hash["Player2HaveConceded"] = true
					hashesToRemove.Add(hash)
				if hash["Player1HaveConceded"] == 1:
					hash["Player1HaveConceded"] = true
					hash["Player2HaveConceded"] = false
					hash["enemy_player_has_conceded"] = true
					
				if hash["WhosTurn"] == 0:
					hash["our_turn"] = false
				else:
					hash["our_turn"] = true
				hash["our_player"] = TeamScript.PlayerNumberEnum.player2
				hash["enemy_player"] = TeamScript.PlayerNumberEnum.player1
				hash["enemy_player_name"] = hash["Player1"]
				//hash.Remove("Player1")
				//hash.Remove("Player2")
				
		// Remove conceded games
		for hash as Boo.Lang.Hash in hashesToRemove: 
			responseList.Remove(hash)
		_gameList = responseList
		
	def HandleNotificationsResponse(JSONstring as string):
		// Get Response
		print(JSONstring)
		responseList as List = (PostWEB.ReadJSON(JSONstring) as List)
		return if responseList.Count == 0
		//hashesToRemove = []
		for type as Boo.Lang.Hash in responseList:
			if type["type"] == "Yes/No":
				pass
				/*
				if( (type as Boo.Lang.Hash )["FoundFriend"] == true):
					_showResponse = true
					_showResponseText = (responseList[0] as Boo.Lang.Hash )["FoundFriend"]
					*/
			
	def OnGUI(): 
		topPadding = 20
		
		
		// Left Buttons
		leftXPadding = 21
		yHegiht = 45
		arrayYItemPadding = yHegiht
		arrayXItemPadding = 5
		
		listControlY = 408
		listControlWidth = 70
		listControlHeight = 72
		
		
		if GUI.Button(Rect(46,listControlY,listControlWidth,listControlHeight),ScrollUppButtonImage):
			pass
		if GUI.Button(Rect(116,listControlY,listControlWidth,listControlHeight),ScrollDownButtonImage,""):
			pass
		if GUI.Button(Rect(180,listControlY,listControlWidth,listControlHeight), "", ""): // Refresh
			_postWEBScript.SendDataStandard("GetGames",0,{"AccountName":_gameState.AccountName}, HandleRefreshResponse)
		if GUI.Button(Rect(180,listControlY,listControlWidth,listControlHeight),UpdateButtonImage,""):
			pass
		
		count = 0
		for index as int in range(_startItem, _endItem):
			ourTurn = ""
			
			if index == len(_gameList):
				break
			if (_gameList[index] as Boo.Lang.Hash)["our_turn"] == true:
				ourTurn = "(!)"
			if GUI.Button(Rect(leftXPadding+arrayXItemPadding, topPadding+arrayYItemPadding*count, 222, 45),  ourTurn+(_gameList[index] as Boo.Lang.Hash)["enemy_player_name"] as string):
				_gameState = GameObject.Find('GameRules').GetComponent[of GameState]()
				_gameState.CurrentPlayer = (_gameList[index] as Boo.Lang.Hash)["our_player"] // as TeamScript.PlayerNumberEnum
				_gameState.GameID = (_gameList[index] as Boo.Lang.Hash)["games_id"] 
				_gameState.MapID = (_gameList[index] as Boo.Lang.Hash)["MapID"] 
				_gameState.Player1AccountName = (_gameList[index] as Boo.Lang.Hash)["Player1"] 
				_gameState.Player2AccountName = (_gameList[index] as Boo.Lang.Hash)["Player2"] 
				
				_gameState.Player1HaveWon = LibraryScript.parseIntToBool((_gameList[index] as Boo.Lang.Hash)["Player1HaveWon"]) 
				_gameState.Player2HaveWon = LibraryScript.parseIntToBool((_gameList[index] as Boo.Lang.Hash)["Player2HaveWon"])
				_gameState.Player1HaveConcede = (_gameList[index] as Boo.Lang.Hash)["Player1HaveConceded"] 
				_gameState.Player2HaveConcede = (_gameList[index] as Boo.Lang.Hash)["Player2HaveConceded"] 
				
				_gameState.EnemyHaveConceded = (_gameList[index] as Boo.Lang.Hash)["enemy_player_has_conceded"]
				_gameState.LoadLevel("level0"+(_gameState.MapID+1).ToString())
			count += 1
			
		
		/// Middle buttons
		buttonHeightPadding = 20
		smallButtonWidth = 128
		smallButtonHeight = 128
		middleRowButtonsStartX = 332
		if GUI.Button(Rect(middleRowButtonsStartX,topPadding,smallButtonWidth,smallButtonHeight),NewGameButtonImage,""):
			Application.LoadLevel("newgameMenu")
			/*
			_gameState = GameObject.Find('GameRules').GetComponent[of GameState]()
			_gameState.CurrentPlayer = TeamScript.PlayerNumberEnum.player1
			_gameState.GameID = 1
			Application.LoadLevel(1)
			*/
		if GUI.Button(Rect(middleRowButtonsStartX,topPadding+smallButtonHeight+buttonHeightPadding,smallButtonWidth,smallButtonHeight),HelpButtonImage,""):
			pass
			/*
			_gameState = GameObject.Find('GameRules').GetComponent[of GameState]()
			_gameState.CurrentPlayer = TeamScript.PlayerNumberEnum.player1
			_gameState.GameID = 3
			_gameState.MapID = 0
			_gameState.LoadLevel("level01")
			*/
			//Application.LoadLevel("level01")
			//_gameState.StartCoroutine("WaitForLoad")
		if GUI.Button(Rect(middleRowButtonsStartX,topPadding+smallButtonHeight*2+buttonHeightPadding*2,smallButtonWidth,smallButtonHeight),MessagesButtonImage,""):
			pass
			
		
		/// Right buttons
		bigButtonWidth = 256
		//rightPadding = 20
		rightRowButtonsStartX = 523
		bigButtonHeight = 128
		if GUI.Button(Rect(rightRowButtonsStartX,topPadding,bigButtonWidth,bigButtonHeight),StoreButtonImage,""):
			pass	
		if GUI.Button(Rect(rightRowButtonsStartX,topPadding+bigButtonHeight+buttonHeightPadding,bigButtonWidth,bigButtonHeight),ContactsButtonImage,""):
			Application.LoadLevel("contacs")
		if GUI.Button(Rect(rightRowButtonsStartX,topPadding+bigButtonHeight*2+buttonHeightPadding*2,smallButtonWidth,bigButtonHeight),OptionsButtonImage,""):
			pass
		if GUI.Button(Rect(rightRowButtonsStartX+smallButtonWidth+5,topPadding+bigButtonHeight*2+buttonHeightPadding*2,smallButtonWidth,bigButtonHeight),ExitGameButtonImage,""):
			Application.Quit()
		if GUI.Button(Rect(rightRowButtonsStartX+smallButtonWidth+5,topPadding+bigButtonHeight*3+buttonHeightPadding*2,smallButtonWidth,bigButtonHeight),"TestGame"):
			Application.LoadLevel("testingScene")
		
		//if GUI.Button(Rect(0,0,smallButtonWidth,bigButtonHeight),ExitGameButtonImage,""):
		//	Application.Quit()
		//GUI.Button(Rect(0,0,Screen.width,Screen.height),BackGroundImage,"")
		//GUI.Button(Rect(0,0,Screen.width,Screen.height),BackGroundImage,"")
		
		