import UnityEngine

class CameraMove (MonoBehaviour): 

	def Start ():
		pass
	
	def Update ():
		horizontalInput = Input.GetAxis ("Horizontal"); 		
		if horizontalInput > 0:
			transform.position.x += 1 
		elif horizontalInput < 0:
			transform.position.x -= 1 
		
		verticalInput = Input.GetAxis ("Vertical"); 
		if verticalInput > 0:
			transform.position.y += 1 
		elif verticalInput < 0:
			transform.position.y -= 1
			