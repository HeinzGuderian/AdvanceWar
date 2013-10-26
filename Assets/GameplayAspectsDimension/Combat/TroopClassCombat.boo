import UnityEngine

partial public class TroopClass():
	[SerializeField]
	private _overWhatchNumber as int = 0
	OverWhatchNumber as int:
		get:
			return _overWhatchNumber
		set:
			if(value<0):
				Debug.Log("Error: Attempting to set new OverWhatchNumber to under 0 !")
				_overWhatchNumber = 0
			else:
				_overWhatchNumber = value
