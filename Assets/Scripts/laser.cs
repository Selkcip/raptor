using UnityEngine;
using System.Collections;

public class laser : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}

	void OnTriggerEnter(Collider other) {
		transform.parent.SendMessage("Triggered", other, SendMessageOptions.DontRequireReceiver);
	}
}
