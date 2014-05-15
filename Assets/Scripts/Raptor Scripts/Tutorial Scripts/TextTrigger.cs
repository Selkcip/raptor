using UnityEngine;
using System.Collections;

public class TextTrigger : MonoBehaviour {
	public int index = 1;
	
	void OnTriggerEnter(Collider other) {
		if(other.tag == "Player") {
			SendMessageUpwards("ChangeList", index, SendMessageOptions.DontRequireReceiver);
			gameObject.SetActive(false);
		}
	}
}
