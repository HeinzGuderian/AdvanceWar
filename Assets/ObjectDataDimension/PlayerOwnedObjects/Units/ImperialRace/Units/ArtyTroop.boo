partial class ArtyTroop (TroopClass ): 
	
	override def Awake ():		
		_productionCost = 100
		WeaponList = [WeaponSystem(Name: "Artillery Cannon", Range: 6, HardDamage: 5, HardMinimumDamage: 3, SoftDamage: 5, SoftMinimumDamage: 3 )
						, WeaponSystem(Name: "Artillery Rockets", Range: 6, HardDamage: 8, HardMinimumDamage: 3, SoftDamage: 0, SoftMinimumDamage: 0 )
						, WeaponSystem(Name: "Infantry close range", Range: 1, HardDamage: 1, HardMinimumDamage: 0, SoftDamage: 1, SoftMinimumDamage: 0 )
					]
		super()
						 
						 /*
		WeaponList = System.Collections.Generic.List[of WeaponSystem]()
		WeaponList.Add(WeaponSystem(Name: "Infantry close range", Range: 3, HardDamage: 3, HardMinimumDamage: 1, SoftDamage: 3, SoftMinimumDamage: 1 ))
		WeaponList.Add( WeaponSystem(Name: "Infantry and IFV missiles", Range: 5, HardDamage: 5, HardMinimumDamage: 2, SoftDamage: 0, SoftMinimumDamage: 0 ) )
		WeaponList.Add( WeaponSystem(Name: "Company Mortar Unit", Range: 6, HardDamage: 1, HardMinimumDamage: 0, SoftDamage: 2, SoftMinimumDamage: 1 ) )
		WeaponList.Add( WeaponSystem(Name: "IFV Cannon", Range: 4, HardDamage: 3, HardMinimumDamage: 1, SoftDamage: 4, SoftMinimumDamage: 2) )
		*/

