import UnityEngine

class ContactsScript (MonoBehaviour): 
	GameListButtonImage as Texture
	GameListItemButtonImage as Texture
	GameListScrollButtonImage as Texture
	ScrollDownButtonImage as Texture
	ScrollUppButtonImage as Texture
	UpdateButtonImage as Texture
	
	AddFriendImage as Texture
	BlockUserImage as Texture
	BackToMainMenuImage as Texture
	
	_accountName as string = "FriendsName"
	_postWEBScript as PostWEB
	_gameState as GameState
	_gameList as List = []
	_friendList as List = []
	_startItem = 0
	_endItem = 5
	
	_showResponse as bool = false
	_showResponseText as string = ""
	
	def Awake():
		pass

	def Start ():
		_gameState = GameObject.Find('GameRules').GetComponent[of GameState]()
		assert _gameState != null
		_postWEBScript = _gameState.gameObject.GetComponent[of PostWEB]()
		//GameListButtonImage = Resources.Load("Textures/tx_button_mainmenu_exitgame", Texture)
		GameListItemButtonImage = Resources.Load("Textures/tx_button_mainmenu_gamelistitem", Texture )
		GameListScrollButtonImage = Resources.Load("Textures/tx_button_mainmenu_gamelistscroll", Texture)
		
		ScrollDownButtonImage = Resources.Load("Textures/Buttons/tx_button_listcontrol2", Texture)
		ScrollUppButtonImage = Resources.Load("Textures/Buttons/tx_button_listcontrol1", Texture)
		UpdateButtonImage = Resources.Load("Textures/Buttons/tx_button_listcontrol3", Texture)
		
		AddFriendImage = Resources.Load("Textures/Buttons/tx_button_contacts_addfriend", Texture)
		BlockUserImage = Resources.Load("Textures/Buttons/tx_button_contacts_blockuser", Texture)
		BackToMainMenuImage = Resources.Load("Textures/Buttons/tx_button_contacts_backtomain", Texture)
//		tx_mainmenu_exitgame
	

		
	def HandleRefreshResponse(JSONstring as string):
		// Get Response
		responseList as List = (PostWEB.ReadJSON(JSONstring) as List)
		//hashesToRemove = []
		friendList = []
		for hash as Boo.Lang.Hash in responseList:
			
			for pair in hash as Boo.Lang.Hash:
				print("Pair: Key:"+pair.Key+" ValueType:"+pair.Value.GetType()+" Value:"+ pair.Value+"\n")
				
			friend = ""
			if( hash["AccountName1"] == _gameState.AccountName):
				friend = hash["AccountName2"]
			elif( hash["AccountName2"] == _gameState.AccountName ):
				friend = hash["AccountName1"]
			friendList.Add(friend)
				//hash.Remove("Player1")
				//hash.Remove("Player2")
				
		// Remove conceded games
		_friendList = friendList
		
	def HandleAddFriendResponse(JSONstring as string):
		// Get Response
		print(JSONstring)
		responseList as List = (PostWEB.ReadJSON(JSONstring) as List)
		return if responseList.Count == 0
		//hashesToRemove = []
		if( (responseList[0] as Boo.Lang.Hash )["FoundFriend"] == true):
			_showResponse = true
			_showResponseText = (responseList[0] as Boo.Lang.Hash )["FoundFriend"]
			
	def HandleBlockUserResponse(JSONstring as string):
		// Get Response
		print(JSONstring)
		responseList as List = (PostWEB.ReadJSON(JSONstring) as List)
		//return if responseList.Count == 0
		//hashesToRemove = []
		//if( (responseList[0] as Boo.Lang.Hash )["BlockedUser"] == true):
		_showResponse = true
		_showResponseText = (responseList[0] as Boo.Lang.Hash )["Message"]		
			
			//HandleBlockUserResponse
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
		
		if _showResponse == true:
			if GUI.Button(Rect(100,100,400,400),_showResponseText,""):
				_showResponse = false
		
		if GUI.Button(Rect(46,listControlY,listControlWidth,listControlHeight),ScrollUppButtonImage,""):
			pass
		if GUI.Button(Rect(116,listControlY,listControlWidth,listControlHeight),ScrollDownButtonImage,""):
			pass
		if GUI.Button(Rect(180,listControlY,listControlWidth,listControlHeight), "", ""): // Refresh
			_postWEBScript.SendDataStandard("GetFriends",0,{"AccountName1":_gameState.AccountName}, HandleRefreshResponse)
		if GUI.Button(Rect(180,listControlY,listControlWidth,listControlHeight),UpdateButtonImage,""):
			pass
	

		count = 0
		for index as int in range(_startItem, _endItem):
			if index == len(_friendList):
				break
			if GUI.Button(Rect(leftXPadding+arrayXItemPadding, topPadding+arrayYItemPadding*count, 222, 45), _friendList[index] as string):
				pass
				//_postWEBScript.SendDataStandard("AddFriend",0,{"RequestAccountName": _gameState.AccountName, "NewFriendAccountName": _friendList[index] as string }, HandleRefreshResponse)
		
				//_gameState = GameObject.Find('GameRules').GetComponent[of GameState]()
				//_gameState.CurrentPlayer = (_friendList[index] as Boo.Lang.Hash)["our_player"] // as TeamScript.PlayerNumberEnum
			count += 1
			
			
		/// Middle buttons
		buttonHeightPadding = 20
		smallButtonWidth = 128
		smallButtonHeight = 128
		middleRowButtonsStartX = 332
		middleTopPadding = 60
		_accountName = GUI.TextField(Rect(middleRowButtonsStartX,0,smallButtonWidth,smallButtonHeight),_accountName)
		
		if GUI.Button(Rect(middleRowButtonsStartX,middleTopPadding,smallButtonWidth,smallButtonHeight),AddFriendImage,""):
			_postWEBScript.SendDataStandard("RequestFriend",0,{"RequestAccountName": _gameState.AccountName, "NewFriendAccountName": _accountName as string }, HandleAddFriendResponse)
			/*
			_gameState = GameObject.Find('GameRules').GetComponent[of GameState]()
			_gameState.CurrentPlayer = TeamScript.PlayerNumberEnum.player1
			_gameState.GameID = 1
			Application.LoadLevel(1)
			*/
		if GUI.Button(Rect(middleRowButtonsStartX,topPadding+smallButtonHeight+buttonHeightPadding,smallButtonWidth,smallButtonHeight),BlockUserImage,""):
			print _gameState.AccountName
			_postWEBScript.SendDataStandard("BlockAccount",0,{"RequestBlockName": _gameState.AccountName, "ToBlockAccountName": _accountName as string }, HandleBlockUserResponse)
			/*
			_gameState = GameObject.Find('GameRules').GetComponent[of GameState]()
			_gameState.CurrentPlayer = TeamScript.PlayerNumberEnum.player1
			_gameState.GameID = 3
			_gameState.MapID = 0
			_gameState.LoadLevel("level01")
			*/
			//Application.LoadLevel("level01")
			//_gameState.StartCoroutine("WaitForLoad")
		if GUI.Button(Rect(middleRowButtonsStartX,topPadding+smallButtonHeight*2+buttonHeightPadding*2,smallButtonWidth,smallButtonHeight),BackToMainMenuImage,""):
			Application.LoadLevel("mainMenu")
			/*
		
		/// Right buttons
		bigButtonWidth = 256
		rightPadding = 20
		rightRowButtonsStartX = 523
		bigButtonHeight = 128
		if GUI.Button(Rect(rightRowButtonsStartX,topPadding,bigButtonWidth,bigButtonHeight),StoreButtonImage,""):
			pass	
		if GUI.Button(Rect(rightRowButtonsStartX,topPadding+bigButtonHeight+buttonHeightPadding,bigButtonWidth,bigButtonHeight),ContactsButtonImage,""):
			pass
		if GUI.Button(Rect(rightRowButtonsStartX,topPadding+bigButtonHeight*2+buttonHeightPadding*2,smallButtonWidth,bigButtonHeight),OptionsButtonImage,""):
			pass
		if GUI.Button(Rect(rightRowButtonsStartX+smallButtonWidth+5,topPadding+bigButtonHeight*2+buttonHeightPadding*2,smallButtonWidth,bigButtonHeight),ExitGameButtonImage,""):
			Application.Quit()
			*/
		//if GUI.Button(Rect(0,0,smallButtonWidth,bigButtonHeight),ExitGameButtonImage,""):
		//	Application.Quit()
		//GUI.Button(Rect(0,0,Screen.width,Screen.height),BackGroundImage,"")
		//GUI.Button(Rect(0,0,Screen.width,Screen.height),BackGroundImage,"")
		
		