import UnityEngine

interface ISaveLoadGame (): 

	def SaveGame ()
	def LoadGame ()
	def DeleteGame(id as int)
	def DeleteGame(name as String)
	def GameID() as int
		
