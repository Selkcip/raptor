using UnityEngine;
using System.Collections;

public class ClimbTextTrigger : MonoBehaviour {
	public Switch trigger;
	public Tutorial tutorial;

	void Update() {
		if (!trigger.isTriggered) {
			tutorial.SendMessage("ChangeList", 4, SendMessageOptions.DontRequireReceiver);
			this.enabled = false;
		}
	}
}