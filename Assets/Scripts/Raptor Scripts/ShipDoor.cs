using UnityEngine;
using System.Collections;
using Holoville.HOTween;

public class ShipDoor : MonoBehaviour {
	[SerializeField]
	private Transform upDoor;
	[SerializeField]
	private Transform lowDoor;
	[SerializeField]
	private Transform ship;

	[SerializeField]
	private Camera shipCam;

	// Use this for initialization
	void Start () {

	}
	
	// Update is called once per frame
	void Update () {
		if(Input.GetKeyDown(KeyCode.L)) {
			OpenDoor();
		}
	}

	void OpenDoor() {
		HOTween.To(upDoor, 10f, new TweenParms().Prop("localPosition", new Vector3(0f, 4f, 0f), true));
		HOTween.To(lowDoor, 10f, new TweenParms().Prop("localPosition", new Vector3(0f, -4f, 0f), true));
	}

	void OnTriggerEnter(Collider other) {
		OpenDoor();
		if(other.transform.name == "Player") {
			GameObject hud = GameObject.Find("HUD");

			foreach(Transform child in hud.transform) {
				child.gameObject.SetActive(false);
			}

			foreach(Transform child in other.transform) {
				child.gameObject.SetActive(false);
			}

			shipCam.tag = "MainCamera";

			StartCoroutine("ShipTween");
		}
	}

	IEnumerator ShipTween() {
		yield return new WaitForSeconds(10f);
		HOTween.To(ship, 30f, new TweenParms().Prop("localPosition", new Vector3(0f, 0f, 1000f), true));
	}
}
