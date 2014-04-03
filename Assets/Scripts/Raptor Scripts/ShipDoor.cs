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

	void OpenDoor() {
		HOTween.To(upDoor, 10f, new TweenParms().Prop("localPosition", new Vector3(0f, 4f, 0f), true));
		HOTween.To(lowDoor, 10f, new TweenParms().Prop("localPosition", new Vector3(0f, -4f, 0f), true));
	}

	void CloseDoor() {
		HOTween.To(upDoor, 0.1f, new TweenParms().Prop("localPosition", new Vector3(0f, -4f, 0f), true));
		HOTween.To(lowDoor, 0.1f, new TweenParms().Prop("localPosition", new Vector3(0f, 4f, 0f), true));
	}

	void OnTriggerEnter(Collider other) {
		if(other.transform.name == "Player") {
			if(upDoor != null) {
				OpenDoor();
			}
			escaping = true;
			//vacuum.active = true;

			BlackHole[] blackHoles = transform.GetAllComponentsInChildren<BlackHole>();
			foreach(BlackHole hole in blackHoles) {
				hole.active = true;
			}

			Camera.main.tag = null;
			shipCam.camera.enabled = true;
			shipCam.tag = "MainCamera";

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
		if(upDoor != null) {
			yield return new WaitForSeconds(10f);
		}
		else {
			yield return new WaitForSeconds(2f);
		}
		HOTween.To(ship, 30f, new TweenParms().Prop("localPosition", new Vector3(0f, 0f, 1000f), true));
		AsyncOperation async = Application.LoadLevelAsync("shiptest");
		async.allowSceneActivation = false;
		yield return new WaitForSeconds(5f);
		async.allowSceneActivation = true;
	}
}
