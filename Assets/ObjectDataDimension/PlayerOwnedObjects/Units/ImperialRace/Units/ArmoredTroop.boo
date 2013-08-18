partial class ArmoredTroop (TroopClass ): 
	
	def ArmoredTroop():
		return
		
	//Deserialization constructor.
	/*
	def ArmoredTroop(info as SerializationInfo, ctxt as StreamingContext ):
		
		//Get the values from info and assign them to the appropriate properties
		//EmpId = (int)info.GetValue("EmployeeId", typeof(int));
		//EmpName = (String)info.GetValue("EmployeeName", typeof(string));
		//selfNormal as INormalForm = self
		//normalStruct = TroopNormalForm.ProduceNormalForm()
		
		selfNormal as INormalForm = self
		normalStruct = selfNormal.ProduceNormalForm(gameObject)
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
		
*/
	override def Awake ():
		_productionCost = 100
		WeaponList = [WeaponSystem(Name: "Tank Guns", Range: 3, HardDamage: 8, HardMinimumDamage: 5, SoftDamage: 3, SoftMinimumDamage: 1 )
						, WeaponSystem(Name: "IFV missiles", Range: 3, HardDamage: 5, HardMinimumDamage: 2, SoftDamage: 0, SoftMinimumDamage: 0 )
						, WeaponSystem(Name: "IFV Cannon", Range: 2, HardDamage: 3, HardMinimumDamage: 1, SoftDamage: 4, SoftMinimumDamage: 2)
						, WeaponSystem(Name: "Company Mortar", Range: 4, HardDamage: 1, HardMinimumDamage: 0, SoftDamage: 4, SoftMinimumDamage: 2)
						 ]
		super()
			/*			 
		stream as Stream = File.Open("EmployeeInfo.osl", FileMode.Create);
		count += 1
		bformatter as BinaryFormatter = BinaryFormatter();
            
		Console.WriteLine("Writing Employee Information");
		bformatter.Serialize(stream, self);
		stream.Close();
		*/	
 
						 /*
		WeaponList = System.Collections.Generic.List[of WeaponSystem]()
		WeaponList.Add(WeaponSystem(Name: "Infantry close range", Range: 3, HardDamage: 3, HardMinimumDamage: 1, SoftDamage: 3, SoftMinimumDamage: 1 ))
		WeaponList.Add( WeaponSystem(Name: "Infantry and IFV missiles", Range: 5, HardDamage: 5, HardMinimumDamage: 2, SoftDamage: 0, SoftMinimumDamage: 0 ) )
		WeaponList.Add( WeaponSystem(Name: "Company Mortar Unit", Range: 6, HardDamage: 1, HardMinimumDamage: 0, SoftDamage: 2, SoftMinimumDamage: 1 ) )
		WeaponList.Add( WeaponSystem(Name: "IFV Cannon", Range: 4, HardDamage: 3, HardMinimumDamage: 1, SoftDamage: 4, SoftMinimumDamage: 2) )
		*/

