class TeamBuildingScript (TeamScript): 
	
	_library as LibraryScript
	
	
	def SetTeam(playerNumber as PlayerNumberEnum):
		players = GameObject.FindGameObjectsWithTag ('Player')
		for player as GameObject in players:
			if (player.GetComponent[of TeamScript]() as TeamScript).Player != _playerNumber:
				playerScript = player.GetComponent[of PlayerScript]()
				assert playerScript != null
				_library.RemoveGameObjectInList(gameObject, playerScript.Buildings)
				//print(playerScript.Buildings)
		super(playerNumber)	
		for player as GameObject  in players:
			//b = (player.GetComponent[of TeamScript]() as TeamScript).Player
			if (player.GetComponent[of TeamScript]() as TeamScript).Player == playerNumber:
				playerScript = player.GetComponent[of PlayerScript]()
				assert playerScript != null
				playerScript.Buildings.AddUnique(gameObject)
				//a = playerScript.Buildings
				//print(playerScript)
				//print(""+playerScript+"  "+playerScript.Buildings)
		
		
	
		
	def Awake():
		_library = GameObject.Find('GameRules').GetComponent[of LibraryScript]()
		super()
		
