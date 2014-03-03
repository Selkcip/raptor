using UnityEngine;
using System.Collections;
using Holoville.HOTween;

public class RaptorInteraction : MonoBehaviour {

	public Texture2D crosshair;
	public float maxHealth = 100;
	public float attack = 20f;

	[HideInInspector]
	public float health;

	//animation stuff
	protected Animator arms;
	private AnimatorStateInfo currentState;
	static int idleState = Animator.StringToHash("Base Layer.Idle");
	
	private bool canPounce = true;
	private bool isPouncing = false;
	private int pounceCoolDown = 3;

	private bool isSlashing = false;

	private bool isCrouching = false;

	private FirstPersonCharacter fpc;

	//Stuff for changing the color of the cursor
	private RaycastHit inRange;
	private float range = 8.5f;

	//Slashing melee detection
	private RaycastHit hit;
	private float meleeRange = 1.0f;

	// Use this for initialization
	void Start () {
		fpc = gameObject.GetComponent<FirstPersonCharacter>();
		arms = gameObject.GetComponentInChildren<Animator>();
		health = maxHealth;
	}
	
	// Update is called once per frame
	void Update () {
		Animation();
		Controls();
	}

	void Animation() {
		currentState = arms.GetCurrentAnimatorStateInfo(0);

		if(currentState.nameHash == idleState) {
			arms.SetBool("leftArmSlash", false);
			arms.SetBool("rightArmSlash", false);
			arms.SetBool("bothSlash", false);
		}
	}

	void Controls() {
		if(Input.GetMouseButton(0)) {
			Slash();
		}
		else if(Input.GetMouseButtonDown(1)) {
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

	void Slash() {
		if(!isSlashing) {
			isSlashing = true;
			//animation stuff
			int arm = Random.Range(0, 3);
			if(arm == 0) {
				arms.SetBool("leftArmSlash", true);
			}
			else if(arm == 1) {
				arms.SetBool("rightArmSlash", true);
			}
			else {
				arms.SetBool("bothSlash", true);
			}
			//hit detection
			if(Physics.Raycast(Camera.main.transform.position, Camera.main.transform.forward, out hit, meleeRange)) {
				if(hit.transform.tag == "enemy") {
					//do damage
					if(isPouncing) {
						hit.transform.GetComponent<Enemy>().health -= attack * 3f;
					}
					else {
						hit.transform.GetComponent<Enemy>().health -= attack;
					}
					//print(hit.transform.GetComponent<Enemy>().health);
				}
			}
			StartCoroutine("SlashCoolDown");
		}
	}

	IEnumerator SlashCoolDown() {
		yield return new WaitForSeconds(0.4f);
		isSlashing = false;
	}

	void Crouch(bool crouching) {
		Transform cam = Camera.main.transform;
		if(crouching) {
			HOTween.To(cam, 0.3f, new TweenParms().Prop("localPosition", new Vector3(0f, -1f, 0f), false));
			//GetComponent<CapsuleCollider>().height = 1f;
			fpc.walkSpeed = 1.75f;
			fpc.strafeSpeed = 1.25f;
			fpc.runSpeed = 1.75f;
		}
		else if (!crouching){
			HOTween.To(cam, 0.3f, new TweenParms().Prop("localPosition", new Vector3(0f, -0.325f, 0f), false));
			//GetComponent<CapsuleCollider>().height = 1.5f;
			fpc.walkSpeed = 4f;
			fpc.strafeSpeed = 3;
			fpc.runSpeed = 8f;
		}
	}

	void Pounce() {
		if(canPounce && !isPouncing && fpc.grounded) {
			canPounce = false;
			isPouncing = true;
			fpc.enabled = false;
			rigidbody.drag = 1;
			rigidbody.AddForce(transform.forward * 15f, ForceMode.Impulse);
			rigidbody.AddForce(transform.up * 5.5f, ForceMode.Impulse);
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
				other.transform.GetComponent<Enemy>().knockedOut = true;
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
		Debug.DrawRay(Camera.main.transform.position, Camera.main.transform.forward * meleeRange, Color.red);
		if(Physics.Raycast(Camera.main.transform.position, Camera.main.transform.forward, out inRange, range)) {
			if(inRange.collider.tag == "enemy") {
				return true;
			}
		}
		return false;
	}
}
