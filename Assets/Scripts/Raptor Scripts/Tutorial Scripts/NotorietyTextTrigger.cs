using UnityEngine;
using System.Collections;

public class NotorietyTextTrigger : MonoBehaviour {
	public PlanningNPC enemy;
	public Tutorial tutorial;

	void Update() {
		if(enemy.knockedOut || enemy.dead) {
			tutorial.SendMessage("ChangeList", 2, SendMessageOptions.DontRequireReceiver);
			this.enabled = false;
		}
	}
}
