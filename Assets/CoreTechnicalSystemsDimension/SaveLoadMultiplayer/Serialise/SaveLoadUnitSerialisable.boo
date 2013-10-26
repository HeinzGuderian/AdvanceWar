import UnityEngine

[Serializable ()]
class SaveLoadUnitSerialisable (ISerializable, ISaveLoadUnit): 
	
	private _parentObject as INormalForm
	//_type as System.Type
	LoadStruct as SaveLoadMultiplayerAspectClass.SaveLoadMultiplayerInfoStruct = SaveLoadMultiplayerAspectClass.SaveLoadMultiplayerInfoStruct(propertyInfo: {}, metaInfo:{}, type:"")
	
	def constructor():
		return
		
	def constructor(parent as INormalForm):
		_parentObject = parent
		//a = 2
		
	//def constructor(type as System.Type):
	//	_type = type
		
	static count as int = 0

	//Deserialization constructor.
	def constructor(info as SerializationInfo, ctxt as StreamingContext ):
		//Get the values from info and assign them to the appropriate properties
		parentTypeString = info.GetValue("Type", string)
		
		currentType as System.Type = Type.GetType(parentTypeString)
		
		LoadStruct = SaveLoadMultiplayerAspectClass.SaveLoadMultiplayerInfoStruct(propertyInfo: {}, metaInfo:{}, type:"")
		LoadStruct.type = info.GetValue("Type", typeof(string))
		
		type as System.Type
		fields  as Boo.Lang.Hash = {}
		if( Type.GetType(LoadStruct.type as string) is LogiTroop ):
			fields = LogiTroop.PropertyInfoFieldsSupply
		else:
			fields = TroopClass.PropertyInfoFields
			
		if(  Type.GetType(LoadStruct.type as string) is LogiTroop ):
			fields = LogiTroop.PropertyInfoFieldsSupply
		elif( Type.GetType(LoadStruct.type as string) is FactoryScript ):
			fields = {}
		elif( Type.GetType(LoadStruct.type as string) is LoginScreen ):
			fields = LoginScreen.PropertyInfoFieldsLogin
		elif( Type.GetType(LoadStruct.type as string) is OilfieldScript ):
			fields = OilfieldScript.PropertyInfoFieldsSupply
		elif( Type.GetType(LoadStruct.type as string) is CentralWarehouseScript ):
			fields = CentralWarehouseScript.PropertyInfoFieldsCW
		else:
			fields = TroopClass.PropertyInfoFields
		
		for pair in fields as Boo.Lang.Hash:
			currentProperty = currentType.GetProperty(pair.Key.ToString())
			if currentProperty != null:
				type = currentProperty.PropertyType
				Debug.Log(pair.Key.ToString())
				Debug.Log(type.FullName)
				Debug.Log(info.GetValue(pair.Key.ToString(), type))
				LoadStruct.propertyInfo[pair.Key.ToString()] = info.GetValue(pair.Key.ToString(), type)
				
		//a = SaveLoadMultiplayerAspectClass.MetaPropertyInfo
			//info.AddValue(pair.Key.ToString(), pair.Value)
		for hash in SaveLoadMultiplayerAspectClass.MetaPropertyInfo as Boo.Lang.Hash:
			/*
			currentProperty = currentType.GetProperty(pair.Key.ToString())
			if currentProperty != null:
				type = currentProperty.PropertyType
				b = info.GetValue(pair.Key.ToString(), type)
				c = pair.Key.ToString()
				*/
			try:
				LoadStruct.metaInfo[hash.Key.ToString()] = info.GetValue(hash.Key.ToString(), (hash.Value as Boo.Lang.Hash)["type"] as System.Type)
			except e as SerializationException: 
				print(e)
	
	
        
	//Serialization function.
	virtual def GetObjectData(info as SerializationInfo, ctxt as StreamingContext ):
		normalStruct = _parentObject.ProduceNormalForm()
		//a = 10
	    //You can use any custom name for your name-value pair. But make sure you
	    // read the values with the same name. For ex:- If you write EmpId as "EmployeeId"
	    // then you should read the same with "EmployeeId"
		for pair in normalStruct.propertyInfo as Boo.Lang.Hash:
			info.AddValue(pair.Key.ToString(), pair.Value)
			
		for pair in normalStruct.metaInfo as Boo.Lang.Hash:
			info.AddValue(pair.Key.ToString(), pair.Value)
			
		info.AddValue("Type", normalStruct.type)		
		
		
	def SaveUnit(path as string):
		stream as Stream = File.Open(path, FileMode.Create);
		count += 1
		bformatter as BinaryFormatter = BinaryFormatter();
		    
		Console.WriteLine("Writing Employee Information");
		bformatter.Serialize(stream, self);
		stream.Close();
		
	def LoadUnit(path as string) as SaveLoadMultiplayerAspectClass.SaveLoadMultiplayerInfoStruct:
		stream = File.Open(path, FileMode.Open);
		bformatter = BinaryFormatter();
		        
		Console.WriteLine("Reading Employee Information");
		mp as SaveLoadUnitSerialisable = bformatter.Deserialize(stream);
		LoadStruct = mp.LoadStruct
		stream.Close(); 
		return LoadStruct
