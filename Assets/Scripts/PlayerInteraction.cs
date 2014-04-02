using UnityEngine;
using System.Collections;
using Holoville.HOTween;

public class PlayerInteraction : MonoBehaviour {

	public Texture crosshair;

	//[HideInInspector]
	public Room playerRoom;
	public float airPerBreath = 5;

	//[HideInInspector]
	public GameObject hitObject;
	public bool wearing = false;
	private float range = 2.25f;

	//float moveRate = 5.0f;
	//float rotateRate = 30.0f;

	private float tempHoldDistance;
	public  bool carrying = false;
	private bool equipped = false;

	// Use this for initialization
	void Start() {
		tempHoldDistance = range;
	}

	void OnGui() {
		GUI.DrawTexture(new Rect(Screen.width / 2.0f - crosshair.width / 2.0f, Screen.height / 2.0f - crosshair.height / 2.0f, crosshair.width, crosshair.height), crosshair);
	}

	// Update is called once per frame
	void Update() {
		Vector3 fwd = Camera.main.transform.TransformDirection(Vector3.forward);

		if(playerRoom != null) {
			playerRoom.air -= airPerBreath * Time.deltaTime;
		}

		if(Input.GetKeyDown(KeyCode.E)) {
			//pick up
			if(hitObject == null) {
				RaycastHit hit;

				if(Physics.Raycast(Camera.main.transform.position, fwd, out hit, range)) {
					hitObject = hit.collider.gameObject;
					if(hitObject.tag == "carry") {
						if(!hitObject.GetComponent<CarryableObject>().isLocked) {
							PickUpObject();
						}
						else {
							hitObject = null;
						}
					}
					else if(hitObject.tag == "equip") {
						if(hitObject.GetComponent<CarryableObject>() != null) {
							if(!hitObject.GetComponent<CarryableObject>().isLocked) {
								EquipObject();
							}
							else {
								hitObject = null;
							}
						}
						else {
							EquipObject();
						}
					}

					else {
						hitObject = null;
					}
				}
			}
			//drop
			else if(hitObject != null) {
				DropObject();
			}
		}

		//Holding something
		if(hitObject != null) {
			if(carrying) {
				RaycastHit info;
				tempHoldDistance = range;
				if(Physics.Raycast(Camera.main.transform.position, fwd, out info, range * 1.5f)) {
					if(!info.collider.isTrigger) {
						float distance = (info.point - transform.position).magnitude;
						if(distance < range + hitObject.transform.localScale.z / 2) {
							tempHoldDistance = distance - hitObject.transform.localScale.z / 2;
						}
					}
				}
				else {
					tempHoldDistance = range;
				}

				HOTween.To(hitObject.transform, 0.1f, "position", Camera.main.ViewportToWorldPoint(new Vector3(0.5f, 0.5f, tempHoldDistance)));
				//HOTween.To(hitObject.transform, 0.1f, "rotation", rigidbody.rotation);
				//hitObject.rigidbody.MovePosition(Camera.main.ViewportToWorldPoint(new Vector3(0.5f, 0.5f, tempHoldDistance)));
				//hitObject.rigidbody.MoveRotation(gameObject.rigidbody.rotation);

				if(tempHoldDistance < 0.75f) {
					DropObject();
				}
			}
			else if(equipped) {
				//if mouse click then do the tool's action
				if(Input.GetMouseButtonDown(0)) {
					hitObject.GetComponent<EquipableObject>().Action();
					hitObject.GetComponent<Animator>().Play("swingwrench");

				}
				if(Input.GetMouseButtonUp(0)) {
					hitObject.GetComponent<EquipableObject>().StopAction();
				}
			}
			Physics.IgnoreLayerCollision(2, 8, true);
			Physics.IgnoreLayerCollision(8, 9, true);
		}
	}

	void PickUpObject() {
		carrying = true;

		hitObject.rigidbody.isKinematic = true;
		hitObject.rigidbody.constraints = RigidbodyConstraints.FreezeRotation;
		hitObject.transform.gameObject.layer = 2;

	}

	void EquipObject() {
		equipped = true;
		hitObject.GetComponent<Animator>().enabled = true;
		hitObject.GetComponent<EquipableObject>().Equip(Camera.main.transform);
		hitObject.transform.gameObject.layer = 9;
		hitObject.rigidbody.isKinematic = true;
	}

	public void DropObject() {
		if(hitObject != null) {
			hitObject.rigidbody.isKinematic = false;
			hitObject.rigidbody.constraints = RigidbodyConstraints.FreezePositionX;
			hitObject.rigidbody.constraints = RigidbodyConstraints.FreezePositionY;

			if(equipped) {
				hitObject.GetComponent<EquipableObject>().DropTool();
				hitObject.GetComponent<Animator>().enabled = false;
				hitObject.transform.position = Camera.main.ViewportToWorldPoint(new Vector3(0.5f, 0.5f, 0.1f));
				hitObject.rigidbody.AddForce(gameObject.transform.forward * 1.25f, ForceMode.Impulse);
				hitObject.transform.parent = null;
				equipped = false;

			}
			hitObject.transform.gameObject.layer = 0;

			hitObject.rigidbody.constraints = RigidbodyConstraints.None;
			hitObject = null;
			carrying = false;
		}
	}
}
