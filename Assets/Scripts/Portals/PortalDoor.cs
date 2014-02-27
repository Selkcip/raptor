using UnityEngine;
using System.Collections;

public class PortalDoor : Door {

	// Public Target allows door to be assigned during play.
	public PortalDoor target;

	// Private variables that need to be configured in inspector.
	[SerializeField] private Transform portalCamera;
	[SerializeField] private Transform m_portalSurface;
	[SerializeField] private Transform m_cameraTarget;

	// Other private variables.
	private bool trackingPlayer = false;
	private bool inTrigger = false;

	// Public Properties
	public Transform portalSurface { get { return m_portalSurface; } }
	public Transform cameraTarget { get { return m_cameraTarget; } }

	// Draws a line in editor to show door connections.
	void OnDrawGizmos() {
		if(target != null)
			Gizmos.DrawLine(transform.position, target.transform.position);
	}

	void Update() {
		if(Input.GetKeyDown(KeyCode.Q)) {
			Debug.Log("Camera Position: " + Camera.main.transform.position);
		}
	}

	public override Room GetNeighbor(Room current) {
		return target.rooms[0];
	}

	void OnTriggerEnter(Collider other) {
		if(!locked) {
			if(other.tag == "Player") {
				inTrigger = true;
				OpenDoor();
				target.OpenDoor();
				EnablePortalCamera();
				CancelInvoke("DisablePortalCamera");
			}
		}
	}

	void OnTriggerExit(Collider other) {
		if(other.tag == "Player") {
			inTrigger = false;
			if(!target.inTrigger) {
				CloseDoor();
				target.CloseDoor();
				Invoke("DisablePortalCamera", 0.5f);
			}
		}
	}

	public override void LockDoor() {
		base.LockDoor();
		target.m_locked = true;
	}

	public override void UnlockDoor() {
		base.UnlockDoor();
		target.m_locked = true;
	}

	public void TransferPortalEffect() {
		CancelInvoke("DisablePortalCamera");
		DisablePortalCamera();
		target.EnablePortalCamera();
	}

	void EnablePortalCamera() {
		trackingPlayer = true;
		portalCamera.gameObject.camera.enabled = true;
	}

	void DisablePortalCamera() {
		trackingPlayer = false;
		portalCamera.gameObject.camera.enabled = false;
	}

	// Mirros the portalCamera to the player's camera.
	void LateUpdate() {
		if(trackingPlayer) {
			Vector3 cameraToDoor = m_portalSurface.position - Camera.main.transform.position;
			portalCamera.position = target.cameraTarget.position - cameraToDoor;
			portalCamera.rotation = Camera.main.transform.rotation;
		}
	}
}
