partial class CruiserTroop (TroopClass ): 
	
	def Awake ():
		WeaponList = [WeaponSystem(Name: "Infantry close range", Range: 3, HardDamage: 3, HardMinimumDamage: 1, SoftDamage: 3, SoftMinimumDamage: 1 )
						, WeaponSystem(Name: "Infantry and IFV missiles", Range: 5, HardDamage: 5, HardMinimumDamage: 2, SoftDamage: 0, SoftMinimumDamage: 0 )
						, WeaponSystem(Name: "Company Mortar Unit", Range: 6, HardDamage: 1, HardMinimumDamage: 0, SoftDamage: 2, SoftMinimumDamage: 1 )
						, WeaponSystem(Name: "IFV Cannon", Range: 4, HardDamage: 3, HardMinimumDamage: 1, SoftDamage: 4, SoftMinimumDamage: 2
						 )]
						 
						 /*
		WeaponList = System.Collections.Generic.List[of WeaponSystem]()
		WeaponList.Add(WeaponSystem(Name: "Infantry close range", Range: 3, HardDamage: 3, HardMinimumDamage: 1, SoftDamage: 3, SoftMinimumDamage: 1 ))
		WeaponList.Add( WeaponSystem(Name: "Infantry and IFV missiles", Range: 5, HardDamage: 5, HardMinimumDamage: 2, SoftDamage: 0, SoftMinimumDamage: 0 ) )
		WeaponList.Add( WeaponSystem(Name: "Company Mortar Unit", Range: 6, HardDamage: 1, HardMinimumDamage: 0, SoftDamage: 2, SoftMinimumDamage: 1 ) )
		WeaponList.Add( WeaponSystem(Name: "IFV Cannon", Range: 4, HardDamage: 3, HardMinimumDamage: 1, SoftDamage: 4, SoftMinimumDamage: 2) )
		*/

