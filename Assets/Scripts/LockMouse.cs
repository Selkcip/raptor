using UnityEngine;
using System.Collections;

public class LockMouse : MonoBehaviour {
	public bool mouseLocked = false;

	public static bool lockMouse = true;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {

		if(Input.GetKey(KeyCode.P)) {
			Application.LoadLevel(Application.loadedLevel);
		}

		Screen.lockCursor = lockMouse;
		mouseLocked = Screen.lockCursor;
	}
}
