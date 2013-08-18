interface ITeam (): 
	PlayerNumber as TeamScript.PlayerNumberEnum:
		get
	
	PlayersTeam as string:
		get

	Player as TeamScript.PlayerNumberEnum:
		get
		set

