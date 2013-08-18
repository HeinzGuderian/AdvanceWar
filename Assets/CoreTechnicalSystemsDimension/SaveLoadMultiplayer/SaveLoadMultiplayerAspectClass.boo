import UnityEngine

static class SaveLoadMultiplayerAspectClass (MonoBehaviour): 
	
	struct SaveLoadMultiplayerInfoStruct:
		propertyInfo as Boo.Lang.Hash
		metaInfo as Boo.Lang.Hash
		type as string
		
	MetaPropertyInfo as Boo.Lang.Hash:
		get:
			properties as Boo.Lang.Hash = {}
			properties["PositionX"] = {"value": null, "type": double }
			properties["PositionY"] = {"value": null, "type": double }
			properties["PositionZ"] = {"value": null, "type": double }
			properties["Team"] = {"value": null, "type": string }
			properties["Name"] = {"value": null, "type": string }
			return properties

	def Start ():
		pass
	
	def Update ():
		pass
		
	def ProduceTroopNormalStruct(infoHash as Boo.Lang.Hash) as SaveLoadMultiplayerInfoStruct:
		//callerNormal.PropertyInfo
		
		infoStruct = SaveLoadMultiplayerInfoStruct(propertyInfo: {}, metaInfo: {}, type: "")
		/*
		propertyHash as Boo.Lang.Hash = {}
		for component as PropertyInfo  in caller.GetType().GetProperties() : 
			if false == component.ToString().Contains("UnityEngine") and component.CanWrite == true:
				//a = component
				propertyHash[component.ToString().Split()[1]] = component.GetValue(caller, null);
		*/
		
		//print(propertyHash)
		infoStruct.type = infoHash["Type"]
		infoStruct.metaInfo = MetaPropertyInfo
		hashKeysToRemove = [] // This is needed becouse apprentyl you can't remove from a hash while iterating through it
		hashKeysToRemove.Add("Type") 
		tempHash = {} // This is needed becouse apprentyl you can't save to a hash while iterating through it
		for hash in infoStruct.metaInfo:
			//hashToAdd = hash "value"
			tempHash[hash.Key] = infoHash[hash.Key]
			//infoStruct.metaInfo[hash.Key] = infoHash[hash.Key]   // dont work, creates iterataie through hash runtime error
			tempString as string = hash.Key.ToString()
			hashKeysToRemove.Add(tempString)
			
		infoStruct.metaInfo = tempHash
		for key as string in hashKeysToRemove as List:
			infoHash.Remove(key)
			
		for hash in infoHash:
			infoStruct.propertyInfo[hash.Key] = infoHash[hash.Key]
			
		
		
			
		
		
		return infoStruct	
		
	def ProduceNormalForm(caller as MonoBehaviour) as SaveLoadMultiplayerInfoStruct:
		callerNormal as INormalForm = caller
		//callerNormal.PropertyInfo
		
		infoStruct = SaveLoadMultiplayerInfoStruct(propertyInfo: {}, metaInfo: {}, type: "")
		/*
		propertyHash as Boo.Lang.Hash = {}
		for component as PropertyInfo  in caller.GetType().GetProperties() : 
			if false == component.ToString().Contains("UnityEngine") and component.CanWrite == true:
				//a = component
				propertyHash[component.ToString().Split()[1]] = component.GetValue(caller, null);
		*/
		
		//print(propertyHash)
		infoStruct.propertyInfo = callerNormal.PropertyInfo
		//for hash in infoStruct.propertyInfo:
			//print(hash.Key)
			
		infoStruct.metaInfo = ProduceMetaData(caller)	
		infoStruct.type = caller.GetType().ToString()
		return infoStruct
	
	
	def ProduceMetaData(caller as MonoBehaviour):	
		metaHash as Boo.Lang.Hash = {}
		//d = caller
		//a = caller.gameObject
		//b = caller.gameObject.transform
		//c = caller.gameObject.transform.position
		metaHash["PositionX"] = caller.gameObject.transform.position.x
		metaHash["PositionY"] = caller.gameObject.transform.position.y
		metaHash["PositionZ"] = caller.gameObject.transform.position.z
		metaHash["Team"] = caller.gameObject.GetComponent[of TeamScript]().PlayerNumber
		metaHash["Name"] = caller.gameObject.GetComponent[of DataScript]().Name
		return metaHash
				
				//writer.WriteStartElement(component.ToString());
		
		
	def LoadFromNormalForm(caller as MonoBehaviour, infoStruct as SaveLoadMultiplayerInfoStruct):
		callerNormal as INormalForm = caller
		for pair in infoStruct.propertyInfo: 
			currentProperty = caller.GetType().GetProperty(pair.Key.ToString())
			if currentProperty != null and  callerNormal.PropertyInfo.ContainsKey(currentProperty.ToString()) :
				currentProperty.SetValue(caller, pair.Value, null);
		 
	def LoadFromMetaData(caller as MonoBehaviour, infoStruct as SaveLoadMultiplayerInfoStruct):
		caller.gameObject.transform.position.x = infoStruct.metaInfo["PositionX"]
		caller.gameObject.transform.position.y = infoStruct.metaInfo["PositionY"]
		caller.gameObject.transform.position.z = infoStruct.metaInfo["PositionZ"]
		caller.gameObject.GetComponent[of TeamScript]().SetTeam( infoStruct.metaInfo["Team"]  )
		caller.gameObject.GetComponent[of DataScript]().Name = infoStruct.metaInfo["Name"]
		
		