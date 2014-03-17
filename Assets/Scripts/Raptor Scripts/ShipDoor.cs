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
	private BlackHole vacuum;

	[SerializeField]
	private Camera shipCam;

	public static bool escaping = false;

	// Use this for initialization
	void Start () {
		CloseDoor();
	}
	
	// Update is called once per frame
	void Update () {

	}

	void OpenDoor() {
		HOTween.To(upDoor, 10f, new TweenParms().Prop("localPosition", new Vector3(0f, 4f, 0f), true));
		HOTween.To(lowDoor, 10f, new TweenParms().Prop("localPosition", new Vector3(0f, -4f, 0f), true));
	}

	void CloseDoor() {
		HOTween.To(upDoor, 0.1f, new TweenParms().Prop("localPosition", new Vector3(0f, -4f, 0f), true));
		HOTween.To(lowDoor, 0.1f, new TweenParms().Prop("localPosition", new Vector3(0f, 4f, 0f), true));
	}

	void OnTriggerEnter(Collider other) {
		OpenDoor();
		escaping = true;
		vacuum.active = true;
		Camera.main.tag = null;
		shipCam.camera.enabled = true;
		shipCam.tag = "MainCamera";
	
		if(other.transform.name == "Player") {
			GameObject hud = GameObject.Find("HUD");

			foreach(Transform child in hud.transform) {
				child.gameObject.SetActive(false);
			}

			other.transform.position = new Vector3(69f, 420f, 1337f);

			//shipCam.camera.enabled = true;

			StartCoroutine("ShipTween");
		}
	}

	IEnumerator ShipTween() {
		yield return new WaitForSeconds(10f);
		HOTween.To(ship, 30f, new TweenParms().Prop("localPosition", new Vector3(0f, 0f, 1000f), true));
	}
}
