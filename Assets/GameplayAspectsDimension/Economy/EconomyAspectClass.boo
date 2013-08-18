import UnityEngine

static class EconomyAspectClass (MonoBehaviour): 

	def Start ():
		pass
	
	def Update ():
		pass
		
	
		
	// Code to pass in to a Basicmenu when you want a buy interface
	def BuyMenuCode(ref currentHash as Boo.Lang.Hash ,ref returnValues as List):
		//plusAndMinusAndIndexCountHeight = 20.0
		//plusAndMinusAndIndexCountWidth = 10
		objectRowWidth = 100
		objectX = 0
		objectY = 0
		rowHeight = 100
		// Add Plus button
		/*
		if(GUI.Button (Rect (objectX, objectY-plusAndMinusAndIndexCountHeight, plusAndMinusAndIndexCountWidth, plusAndMinusAndIndexCountHeight), GUIContent(" + ") ) ): 
			returnValues.Add( currentHash.Clone() )
		// Create Minus button 
		if(GUI.Button (Rect (objectX+plusAndMinusAndIndexCountWidth, objectY-plusAndMinusAndIndexCountHeight, plusAndMinusAndIndexCountWidth, plusAndMinusAndIndexCountHeight), GUIContent(" - ") ) ): 
			returnValues.Remove(currentHash)
		*/
		// Create label to view how many of the object you have bought
		//GUI.Label(Rect (objectX+plusAndMinusAndIndexCountWidth*2, objectY-plusAndMinusAndIndexCountHeight, plusAndMinusAndIndexCountWidth, plusAndMinusAndIndexCountHeight), (len([item for item in returnValues if item==currentHash]).ToString())  )   
		// If you click the button you add one object from that type
		if(GUI.Button (Rect (objectX, objectY, objectRowWidth, rowHeight), currentHash["GUIContent"] as GUIContent, "" ) ):
			returnValues.Add( currentHash.Clone() )
			
	def MultipleBuyChoiceCode(ref currentHash as Boo.Lang.Hash ,ref returnValues as List):
		plusAndMinusAndIndexCountHeight = 75.0
		plusAndMinusAndIndexCountWidth = 75
		stringHeight = 20
		padding = 0
		objectRowWidth = 150
		objectX = 0
		objectY = 0
		rowHeight = 75
		if(GUI.Button (Rect (objectX+padding, objectY+stringHeight, plusAndMinusAndIndexCountWidth, plusAndMinusAndIndexCountHeight), GUIContent(Resources.Load("Textures/Buttons/tx_button_buyPlus", Texture)),"" ) ): 
			returnValues.Add( currentHash.Clone() )
		// Create Minus button 
		if(GUI.Button (Rect (objectX+objectRowWidth-plusAndMinusAndIndexCountWidth-padding, objectY+stringHeight, plusAndMinusAndIndexCountWidth, plusAndMinusAndIndexCountHeight), GUIContent(Resources.Load("Textures/Buttons/tx_button_buyMinus", Texture)),"" ) ): 
			returnValues.Remove(currentHash)
		// Create label to view how many of the object you have bought
		GUI.Label(Rect (objectX+(objectRowWidth/2)-15, objectY, 30, plusAndMinusAndIndexCountHeight), (len([item for item in returnValues if item==currentHash]).ToString())+"00"  )   
		// If you click the button you add one object from that type
		if(GUI.Button (Rect (objectX, objectY+plusAndMinusAndIndexCountHeight+stringHeight, objectRowWidth, rowHeight), currentHash["GUIContent"] as GUIContent,"" ) ):
			returnValues.Add( currentHash.Clone() )


	def MultipleChoiceCode(ref currentHash as Boo.Lang.Hash ,ref returnValues as List):
		plusAndMinusAndIndexCountHeight = 20.0
		plusAndMinusAndIndexCountWidth = 10
		objectRowWidth = 70
		objectX = 0
		objectY = 0
		rowHeight = 100
		if(GUI.Button (Rect (objectX, objectY-plusAndMinusAndIndexCountHeight, plusAndMinusAndIndexCountWidth, plusAndMinusAndIndexCountHeight), GUIContent(" + ") ) ): 
			returnValues.Add( currentHash.Clone() )
		// Create Minus button 
		if(GUI.Button (Rect (objectX+plusAndMinusAndIndexCountWidth, objectY-plusAndMinusAndIndexCountHeight, plusAndMinusAndIndexCountWidth, plusAndMinusAndIndexCountHeight), GUIContent(" - ") ) ): 
			returnValues.Remove(currentHash)
		// Create label to view how many of the object you have bought
		GUI.Label(Rect (objectX+plusAndMinusAndIndexCountWidth*2, objectY-plusAndMinusAndIndexCountHeight, plusAndMinusAndIndexCountWidth, plusAndMinusAndIndexCountHeight), (len([item for item in returnValues if item==currentHash]).ToString())  )   
		// If you click the button you add one object from that type
		if(GUI.Button (Rect (objectX, objectY, objectRowWidth, rowHeight-5), currentHash["GUIContent"] as GUIContent,"" ) ):
			returnValues.Add( currentHash.Clone() )
		return
