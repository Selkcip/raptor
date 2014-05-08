using UnityEngine;
using System.Collections;

public class DockTrigger : TaggedTriggerable {
	public string targetScene;

	SceneTransition transition;
	Transform playerShip;
	Vector3 dockPos;
	bool docked = false;

	void OnTriggerEnter2D(Collider2D other) {
		if(!docked) {
			if(LevelSelector.coastIsClear && tags.Count <= 0 || tags.Contains(other.tag) || (other.transform.parent != null && tags.Contains(other.transform.parent.tag))) {
				PlayerShipController control = other.GetComponent<PlayerShipController>();
				if(control != null && control.isCloaked) {
					control.enabled = false;
					other.collider2D.enabled = false;
					other.rigidbody2D.isKinematic = true;
					other.transform.parent = transform.parent;
					playerShip = other.transform;
					dockPos = playerShip.localPosition;

					transition = GameObject.FindObjectOfType<SceneTransition>();
					transition.targetScene = targetScene;
					transition.triggerList.Add(this);

					isTriggered = true;
					docked = true;
				}
			}
		}
	}

	void Update() {
		if(playerShip) {
			dockPos = Vector3.Lerp(dockPos, transform.localPosition, 0.01f);
			playerShip.localPosition = dockPos;// Vector3.Lerp(playerShip.localPosition, Vector3.zero, 0.01f);
		}
	}
}
