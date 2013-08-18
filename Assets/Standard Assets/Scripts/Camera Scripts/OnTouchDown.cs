//  OnTouchDown.cs
//  Allows "OnMouseDown()" events to work on the iPhone.
//  Attack to the main camera.

using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class OnTouchDown : MonoBehaviour
{
	public enum MoveMode { None, Rotate, Zoom };
	bool hasMoved = false;
	bool inTouch = false;
	int id = -1;
	float time1 = 0;
	float speedFactor = 1;

	
    public void RayCasts(Rect rec) {
		//bool touching = false;
		//int touchID = 0;
		GUILayer l   = Camera.main.GetComponent(typeof(GUILayer)) as GUILayer;
		GUIElement ele = l.HitTest(Input.mousePosition);
		GUIElement ele1 = null;
		Vector3 CameraPos = Camera.main.transform.position;
		
		if(Input.touchCount > 0){
			
			ele1 = l.HitTest(new Vector3(Input.GetTouch(0).position.x, Input.GetTouch(0).position.y, CameraPos.z));
		
		Vector3 t = new Vector3(Input.GetTouch(0).position.x, Input.GetTouch(0).position.y, 0);
		Vector3 v = new Vector3(Input.GetTouch(0).position.x, Input.GetTouch(0).position.y, CameraPos.z);
		if(ele != null || ele1 != null || rec.Contains(new Vector3(Input.GetTouch(0).position.x, Screen.height-Input.GetTouch(0).position.y, 0)) ){
			return;
		}
		else if (Input.touchCount == 1 ){
			
			if ( hasMoved == true && Input.touchCount > 0 && !(Input.GetTouch(0).phase.Equals(TouchPhase.Moved))){
				hasMoved = false;
			}
			if ( Input.touchCount > 0 && Input.GetTouch(0).phase.Equals(TouchPhase.Moved)){
					TouchPhase a = Input.GetTouch(0).phase;
					Touch b = Input.GetTouch(0);
					// Then change camera
	                Camera.main.transform.position = new Vector3( CameraPos.x + (Input.GetTouch(0).deltaPosition.x*-1),CameraPos.y + (Input.GetTouch(0).deltaPosition.y*-1),CameraPos.z);
					// Mark that we have moved
					hasMoved = true;
				
			}
			// If a touch has happend
			
			if( hasMoved==false && Input.touchCount > 0 && Input.GetTouch(0).phase.Equals(TouchPhase.Began) ) { 
				//Save Touch id and flag that we are in a touch
				//touchID = Input.GetTouch(0).fingerId;
				inTouch = true;
				time1 = Time.time;
				id = Input.GetTouch(0).fingerId;
				
				
			}
				
			//if( hasMoved==false && Input.touchCount > 0 && Input.GetTouch(0).phase.Equals(TouchPhase.Stationary) ) { 
		//		inTouch = false;	
		//	}
			// If we are in a touch
			if(hasMoved == false && inTouch == true && Input.GetTouch(0).fingerId == id  ){
				// Check if we are moving
				
				
				// Check if the touch is ending
				if( Input.touchCount > 0 &&  ( (Input.GetTouch(0).phase.Equals(TouchPhase.Began) ) ) ){
					// Check if we have moved
					TouchPhase a = Input.GetTouch(0).phase;
					Touch b = Input.GetTouch(0);
					if(hasMoved == false){
						// If not then send raycast
				        RaycastHit hit = new RaycastHit();
			            //if (Input.GetTouch(i).phase.Equals(TouchPhase.Began)) {
			            // Construct a ray from the current touch coordinates
						//Vector3 c = Input.GetTouch(0).position;
						//print(Input.GetTouch(0).position);
						Ray ray = Camera.main.ScreenPointToRay(new Vector3(Input.GetTouch(0).position.x, Input.GetTouch(0).position.y, CameraPos.z));
						if (Physics.Raycast(ray, out hit, Mathf.Infinity)) {
			                hit.transform.gameObject.SendMessage("OnMouseDown");
			           	//}
				       	}
						hasMoved = false;
						inTouch = false;
					}
					// Reset flags and id
					
				}
	    	}
		}
	}
}}