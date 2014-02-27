using UnityEngine;
using System.Collections;

public class EnteredPortalEvent : BaseEvent { }

public class PortalMove : MonoBehaviour {
	public PortalDoor portalDoor;

	void OnTriggerStay(Collider other) {
		if(collider.bounds.Contains(other.transform.position)) {
			Vector3 offset = portalDoor.portalSurface.position - other.transform.position;
			Vector3 endPosition = portalDoor.target.cameraTarget.position - offset;
			other.transform.position = endPosition;
			if(other.tag == "Player") {
				EventManager.instance.TriggerEvent(new EnteredPortalEvent());
				portalDoor.TransferPortalEffect();
			}
		}
	}

}