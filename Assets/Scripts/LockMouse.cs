using UnityEngine;
using System.Collections;

public class LockMouse : MonoBehaviour {

	public bool lockMouse = true;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		if(lockMouse) {
			Screen.lockCursor = true;
		}
		else {
			Screen.lockCursor = false;
		}
	}
}
