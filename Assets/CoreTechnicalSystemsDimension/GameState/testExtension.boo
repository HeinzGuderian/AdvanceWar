import UnityEngine.GameObject

class testExtension:
	[Extension]
	static def RecursiveRendererDisable(startNode as GameObject):
		for render as UnityEngine.Renderer in startNode.GetComponentsInChildren[of UnityEngine.Renderer]():
			render.enabled = false
			render.gameObject.layer = LayerMask.NameToLayer("Ignore Raycast")
	[Extension]		
	static def RecursiveRendererEnable(startNode as GameObject):
		for render as UnityEngine.Renderer in startNode.GetComponentsInChildren[of UnityEngine.Renderer]():
			render.enabled = true
			render.gameObject.layer = 0xF
	[Extension]
	static def RecursiveSetRendererMaterial(startNode as GameObject, materialInput as Material):
		for render as UnityEngine.Renderer in startNode.GetComponentsInChildren[of UnityEngine.Renderer]():
			render.material = materialInput
	[Extension]
	static def SetAnimation(startNode as GameObject, animationName as string):
		//print(startNode.GetComponentsInChildren[of Animation]())
		//a = startNode.GetComponentsInChildren[of Animation]()
		for currentAnimation as Animation in startNode.GetComponentsInChildren[of Animation]():
			//c = currentAnimation
			for animationState as AnimationState in currentAnimation as Animation:
				//b = animationState
				if animationState.name == animationName :
					//print("111")
					currentAnimation.Play (animationName,PlayMode.StopAll);