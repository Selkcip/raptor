using UnityEngine;
using System.Collections;

public class UpgradeTextTrigger : MonoBehaviour {

	public Tutorial tutorial;
	public GameObject sc;
	public GameObject semp;

	public void Use() {
		tutorial.SendMessage("ChangeList", 8, SendMessageOptions.DontRequireReceiver);
		sc.SetActive(true);
		semp.SetActive(true);
		this.enabled = false;
	}
}
