interface ITerrain (): 
	IsOccupied as bool:
		get
		set

	TerrainType as TerrainScript.TerrainTypeEnum:
		get
		set

	ContainedObjects as List:
		get
		set
		
	TerrainNeighbors as Boo.Lang.Hash:
		get
		
		
		

	