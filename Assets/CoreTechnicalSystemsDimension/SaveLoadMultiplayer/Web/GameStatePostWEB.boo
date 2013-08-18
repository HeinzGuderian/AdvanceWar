import UnityEngine

partial class GameState (MonoBehaviour): 
	def GetPostWEB() as ISaveLoadGame:
		return PostWEB.FindWebScript()
		

		
	def Update():
		if true == LevelIsLoaded:
			allGameObjects as (UnityEngine.GameObject) =  (GameObject.FindObjectsOfType(GameObject) as (UnityEngine.GameObject))
			callFunction2 = {x as IGameState | x.StartTurnActions()}
			CallIGameState(allGameObjects, callFunction2)
			//_currentPlayerGUI.PrintToScreen(_currentTurn.ToString())
			LevelIsLoaded = false
			if true == Player1HaveWon or true == Player2HaveWon:
				DeleteGame = true
				_haveWon = true
			for hash in PropertyInfo as Boo.Lang.Hash:
				print(""+hash.Key+" : "+hash.Value +"\n")