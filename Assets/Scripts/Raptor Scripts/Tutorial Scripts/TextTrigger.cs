using UnityEngine;
using System.Collections;

public class TextTrigger : MonoBehaviour {
	public int index = 1;
	private Tutorial tutorial;

	void Start() {
		tutorial = GameObject.Find("Tutorial Text").GetComponent<Tutorial>();
	}
	
	void OnTriggerEnter(Collider other) {
		if(other.tag == "Player") {
			tutorial.SendMessage("ChangeList", index, SendMessageOptions.DontRequireReceiver);
			gameObject.SetActive(false);
		}
	}
}
