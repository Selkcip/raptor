using UnityEngine;
using System.Collections;
using Holoville.HOTween;

public class RaptorInteraction : MonoBehaviour {

	public Texture2D crosshair;

	private bool canPounce = true;
	private bool isPouncing = false;
	private int pounceCoolDown = 3;

	private bool isCrouching = false;

	private FirstPersonCharacter fpc;

	private RaycastHit hit;
	private float range = 8.5f;

	// Use this for initialization
	void Start () {
		fpc = gameObject.GetComponent<FirstPersonCharacter>();
	}
	
	// Update is called once per frame
	void Update () {
		Controls();
	}

	void Controls() {
		if(Input.GetMouseButton(0)) {
			//slash
		}
		else if(Input.GetMouseButton(1)) {
			Pounce();
		}

		if(Input.GetKeyDown(KeyCode.LeftControl)) {
			isCrouching = !isCrouching;
			Crouch(isCrouching);
		}

		if(Input.GetKey(KeyCode.E)) {
			//interact
		}
	}

	void Crouch(bool crouching) {
		Transform cam = Camera.main.transform;
		if(crouching) {
			HOTween.To(cam, 0.3f, new TweenParms().Prop("localPosition", new Vector3(0f, -1f, 0f), false));
			fpc.walkSpeed = 1.75f;
			fpc.strafeSpeed = 1.25f;
			fpc.runSpeed = 1.75f;
		}
		else if (!crouching){
			HOTween.To(cam, 0.3f, new TweenParms().Prop("localPosition", new Vector3(0f, -0.325f, 0f), false));
			fpc.walkSpeed = 4f;
			fpc.strafeSpeed = 3;
			fpc.runSpeed = 8f;
		}
	}

	void Pounce() {
		if(canPounce && !isPouncing && fpc.grounded) {
			canPounce = false;
			isPouncing = true;
			print("pounce");
			fpc.enabled = false;
			rigidbody.drag = 1;
			rigidbody.AddForce(transform.forward * 15f, ForceMode.Impulse);
			rigidbody.AddForce(transform.up * 5f, ForceMode.Impulse);
			StartCoroutine("PounceCoolDown");
		}
	}

	IEnumerator PounceCoolDown() {
		yield return new WaitForSeconds(pounceCoolDown);
		canPounce = true;
	}

	void OnCollisionEnter(Collision other) {
		if(isPouncing) {
			isPouncing = false;
			rigidbody.drag = 0;
			fpc.enabled = true;

			//Chain pouncing
			if(other.gameObject.tag == "enemy") {
				canPounce = true;
			}
		}
	}

	void OnGUI() {
		if(InAttackRange()) {
			GUI.color = Color.red;
		}
		else {
			GUI.color = Color.white;
		}
		float x = (Screen.width / 2) - (crosshair.width / 6);
		float y = (Screen.height / 2) - (crosshair.height / 6);
		GUI.DrawTexture(new Rect(x, y, crosshair.width/3, crosshair.height/3),crosshair);
	}

	bool InAttackRange() {
		Debug.DrawRay(Camera.main.transform.position, Camera.main.transform.forward * range, Color.cyan);
		if(Physics.Raycast(Camera.main.transform.position, Camera.main.transform.forward, out hit, range)) {
			if(hit.collider.tag == "enemy") {
				return true;
			}
		}
		return false;
	}
}
