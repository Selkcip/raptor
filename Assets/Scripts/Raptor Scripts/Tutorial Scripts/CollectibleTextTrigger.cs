using UnityEngine;
using System.Collections;

public class CollectibleTextTrigger : MonoBehaviour {
	public Mine mine;
	public Tutorial tutorial;
	public GameObject collectible;

	void Update() {
		if(mine.hacked) {
			tutorial.SendMessage("ChangeList", 6, SendMessageOptions.DontRequireReceiver);
			collectible.SetActive(true);
			this.enabled = false;
		}
	}
}
