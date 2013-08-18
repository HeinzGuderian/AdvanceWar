
import UnityEngine
import System;
import System.IO;
import System.Runtime.Serialization;
import System.Runtime.Serialization.Formatters.Binary;

partial class TroopClass (ISaveLoadUnit ): 
	//TroopNormalForm as INormalForm = self
	
		

		
	def SaveUnit(path as string):
		_saveClass.SaveUnit(path)

		
	public static def LoadUnit(path as string) as SaveLoadMultiplayerAspectClass.SaveLoadMultiplayerInfoStruct:
		//normalStruct = SaveLoadUnitSerialisable(TroopClass).LoadUnit(path)
		return SaveLoadUnitSerialisable().LoadUnit(path)
		/*
		b = normalStruct.metaInfo["team"]
		c = normalStruct.type
		d as System.Type = Type.GetType(normalStruct.type as string)
		w = ResourcesLoadTable
		e =  ResourcesLoadTable[Type.GetType(normalStruct.type as string)]
		f = normalStruct.metaInfo["positionX"]
		*/
		/*
		newUnit = FactoryEconomy.CreateUnit(ResourcesLoadTable[Type.GetType(normalStruct.type as string)], 
			Vector3(normalStruct.metaInfo["positionX"],normalStruct.metaInfo["positionY"],normalStruct.metaInfo["positionZ"]), 
			TeamScript.StringToPlayerNumber( normalStruct.metaInfo["team"] as string ))
		newUnit.GetComponent[of TroopClass]().LoadFromNormalForm(normalStruct)
		return
		*/
		//normalStruct as SaveLoadMultiplayerAspectClass.SaveLoadMultiplayerInfoStruct = _saveClass.Load()
		//normalStruct
		
		//FactoryEconomy.CreateUnit()
		
		
		/*
		stream = File.Open("EmployeeInfo.osl", FileMode.Open);
		bformatter = new BinaryFormatter();
		        
		Console.WriteLine("Reading Employee Information");
		mp = (Employee)bformatter.Deserialize(stream);
		stream.Close();
		            
		Console.WriteLine("Employee Id: {0}",mp.EmpId.ToString());
		Console.WriteLine("Employee Name: {0}",mp.EmpName);
		
		*/
	
	def InitialiseSerialize() as void:
		ResourcesLoadTable = {
		MechTroop :  UnityEngine.Resources.Load("Troops_land/MechTroopPreFab") ,
		ArmoredTroop : UnityEngine.Resources.Load("Troops_land/ArmoredTroopPreFab") ,
		ArtyTroop : UnityEngine.Resources.Load("Troops_land/ArtyTroopPreFab"),
		EngyTroop: UnityEngine.Resources.Load("Troops_land/EngineerTroopPreFab") ,
		AntiairTroop: UnityEngine.Resources.Load("Troops_land/AntiairTroopPreFab"),
		MotoTroop: UnityEngine.Resources.Load("Troops_land/MotoTroopPreFab") ,
		LogiTroop: UnityEngine.Resources.Load("Troops_land/LogisticsTroopPreFab") ,
		CommTroop: UnityEngine.Resources.Load("Troops_land/CommTroopPreFab")
		}
		_saveClass = SaveLoadUnitSerialisable(self)
		
	/*	
	//Deserialization constructor.
	virtual def TroopScript(info as SerializationInfo, ctxt as StreamingContext ):
		//Get the values from info and assign them to the appropriate properties
		//EmpId = (int)info.GetValue("EmployeeId", typeof(int));
		//EmpName = (String)info.GetValue("EmployeeName", typeof(string));
		//selfNormal as INormalForm = self
		//normalStruct = TroopNormalForm.ProduceNormalForm()
		
		selfNormal as INormalForm = self
		normalStruct = selfNormal.ProduceNormalForm()
		type as System.Type
		for pair in normalStruct.propertyInfo as Boo.Lang.Hash:
			currentProperty = self.GetType().GetProperty(pair.Key.ToString())
			type = currentProperty.GetType()
			if currentProperty != null and selfNormal.PropertyInfo.ContainsKey(currentProperty.ToString()):
				pair.Value = info.GetValue(pair.Key.ToString(), type)
			//info.AddValue(pair.Key.ToString(), pair.Value)
		for pair in normalStruct.metaInfo as Boo.Lang.Hash:
			currentProperty = self.GetType().GetProperty(pair.Key.ToString())
			type = currentProperty.GetType()
			if currentProperty != null and  selfNormal.PropertyInfo.ContainsKey(currentProperty.ToString()):
				pair.Value = info.GetValue(pair.Key.ToString(), type)
				
		normalStruct.type = info.GetValue("type", typeof(string));		
	
        
	//Serialization function.
	virtual def GetObjectData(info as SerializationInfo, ctxt as StreamingContext ):
		selfNormal as INormalForm = self
		normalStruct = selfNormal.ProduceNormalForm()
		a = 10
	    //You can use any custom name for your name-value pair. But make sure you
	    // read the values with the same name. For ex:- If you write EmpId as "EmployeeId"
	    // then you should read the same with "EmployeeId"
		for pair in normalStruct.propertyInfo as Boo.Lang.Hash:
			info.AddValue(pair.Key.ToString(), pair.Value)
			
		for pair in normalStruct.metaInfo as Boo.Lang.Hash:
			info.AddValue(pair.Key.ToString(), pair.Value)
			
		info.AddValue("type", normalStruct.type)	
		
	*/
