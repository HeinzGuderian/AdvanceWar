import UnityEngine

partial class PlayerScript (INormalForm): 
	
	PropertyInfo as Boo.Lang.Hash:
		get:
			hash = {}
			hash["VictoryResources"] =VictoryResources
			hash["UniversalResources"] = UniversalResources
			return hash

	def ProduceNormalForm() as SaveLoadMultiplayerAspectClass.SaveLoadMultiplayerInfoStruct:
		infoStruct = SaveLoadMultiplayerAspectClass.SaveLoadMultiplayerInfoStruct(propertyInfo: {}, metaInfo: {}, type: "")
		infoStruct.propertyInfo = PropertyInfo
		//infoStruct.propertyInfo["VictoryResources"] = VictoryResources
		//infoStruct.propertyInfo["UniversalResources"] = UniversalResources
		infoStruct.metaInfo["Player"] =  TeamScript.FindTeamScript(gameObject).PlayerNumber.ToString()
		infoStruct.type = self.GetType().ToString()
		assert infoStruct.metaInfo["Player"] != null
		return infoStruct
		
	static def CreateUnit(infoHash as Boo.Lang.Hash):
		
		normalStruct = SaveLoadMultiplayerAspectClass.ProduceTroopNormalStruct(infoHash)
		/*
		ab = Type.GetType(normalStruct.type as string)
		ba = ResourcesLoadTable[Type.GetType(normalStruct.type as string)]
		cd = normalStruct.metaInfo["Team"] as string
		dc = TeamScript.StringToPlayerNumber( normalStruct.metaInfo["Team"] as string )
		*/
		playerNumber as TeamScript.PlayerNumberEnum = TeamScript.StringToPlayerNumber(infoHash["Player"])
		if playerNumber == TeamScript.PlayerNumberEnum.player1:
			GameObject.Find("Player1").GetComponent[of PlayerScript]().LoadFromNormalForm(normalStruct)
		elif playerNumber == TeamScript.PlayerNumberEnum.player2:
			GameObject.Find("Player2").GetComponent[of PlayerScript]().LoadFromNormalForm(normalStruct)
		else:
			raise "playerNumber was not player1 or player2"
		
		//newGameObject as GameObject = Instantiate(UnityEngine.Resources.Load("PlayerPreFab"), Vector3(0,0,0),  Quaternion.identity  )
		//newGOteamScript = newGameObject.GetComponent[of TeamBuildingScript]()
		//newGOteamScript.SetTeam(TeamScript.StringToPlayerNumber(infoHash["Player"]))
		
		//newGameObject.transform.rotation.x = 90 // Becouse otherwise they bug out and are turnd odd
		//newGameObject.transform.rotation = Quaternion.Euler(270, 0, 0)
		//newGameObject.GetComponent[of PlayerScript]().LoadFromNormalForm(infoHash)
		
	virtual def LoadFromNormalForm(propertyHash as Boo.Lang.Hash):
		 for pair in propertyHash: 
		 	currentProperty = self.GetType().GetProperty(pair.Key.ToString())
		 	if currentProperty != null:
		 		currentProperty.SetValue(self, pair.Value, null);
		 		
	virtual def LoadFromNormalForm(propertyStruct as SaveLoadMultiplayerAspectClass.SaveLoadMultiplayerInfoStruct):
		 for pair in propertyStruct.propertyInfo as Boo.Lang.Hash: 
		 	currentProperty = self.GetType().GetProperty(pair.Key.ToString())
		 	if currentProperty != null:
		 		currentProperty.SetValue(self, pair.Value, null);
