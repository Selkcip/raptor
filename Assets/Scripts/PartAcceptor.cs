using UnityEngine;
using System.Collections;

public class PartRemovedEvent : BaseEvent {
	public CarryableObject part;
	public PartAcceptor partAcceptor;

	public PartRemovedEvent(CarryableObject cObj, PartAcceptor pAcc){
		part = cObj;
		partAcceptor = pAcc;
	}
}

public class PartInsertedEvent : BaseEvent {
	public CarryableObject part;
	public PartAcceptor partAcceptor;
	
	public PartInsertedEvent(CarryableObject cObj, PartAcceptor pAcc){
		part = cObj;
		partAcceptor = pAcc;
	}
}

public class PartAcceptor : MonoBehaviour {

	public string[] partsToAccept;
	public bool lockPart = false;

	public bool holdingPart = false;
	public GameObject heldPart;

	void Update() {
		if (heldPart != null) {
			if (lockPart) {
				heldPart.GetComponent<CarryableObject>().isLocked = true;
			}
			else if (!lockPart) {
				heldPart.GetComponent<CarryableObject>().isLocked = false;
			}
		}
	}

	void OnTriggerEnter(Collider heldItem) {
		if (!holdingPart) {
			foreach(string partName in partsToAccept) {
				if (heldItem.gameObject.GetComponent<CarryableObject>().partName == partName) {
					if(heldItem.gameObject.GetComponent<CarryableObject>().held == false) {
						Drop();
						heldPart = heldItem.gameObject;
						heldItem.rigidbody.isKinematic = true;
						StartCoroutine("MoveToCenter", heldPart);
						holdingPart = true;
						heldItem.gameObject.GetComponent<CarryableObject>().held = true;
						EventManager.instance.QueueEvent(new PartInsertedEvent(heldPart.GetComponent<CarryableObject>(), this));
					}
				}
			}
		}
	}

	void OnTriggerExit(Collider heldItem) {
		if (holdingPart) {
			if(heldItem.gameObject == heldPart){
				heldPart.GetComponent<CarryableObject>().held = false;
				heldPart.GetComponent<CarryableObject>().isLocked = false;
				holdingPart = false;
				EventManager.instance.QueueEvent(new PartRemovedEvent(heldPart.GetComponent<CarryableObject>(), this));
				heldPart = null;
			}
		}
	}

	IEnumerator MoveToCenter(GameObject heldObject) {
		Vector3 startPosition = heldObject.transform.position;
		Vector3 endPosition = gameObject.transform.position;

		Quaternion startRotation = heldObject.transform.rotation;
		Quaternion endRotation = gameObject.transform.rotation;

		float completion = 0f;
		while (completion < 1f) {
			completion += Time.deltaTime * 4.0f;
			heldObject.transform.position = Vector3.Lerp(startPosition, endPosition, completion);
			heldObject.transform.rotation = Quaternion.Lerp(startRotation, endRotation, completion);

			yield return null;
		}
	}

	void Drop() {
		GameObject.FindGameObjectWithTag("Player").GetComponent<PlayerInteraction>().DropObject();
		GameObject.FindGameObjectWithTag("Player").GetComponent<PlayerInteraction>().hitObject = null;
	}
}
