import UnityEngine

class ApplicationSettings (MonoBehaviour): 
	_gameState as GameState
	
	def Awake():
    	DontDestroyOnLoad (gameObject)
    	
    	
    def Start():
    	_gameState = (GameObject.Find('GameRules').GetComponent[of GameState]() as GameState)
    	

	
