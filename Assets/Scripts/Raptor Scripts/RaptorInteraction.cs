using UnityEngine;
using System.Collections;
using Holoville.HOTween;

public class RaptorInteraction : MonoBehaviour {

	public Texture2D crosshair;
	public float maxHealth = 10;	//the number of times you can get hit
	public float attack = 20f;

	//sound stuff
	public float walkNoiseLevel = 1;
	public float walkNoiseFalloff = 0.25f;
	public float runNoiseLevel = 5;
	public float runNoiseFalloff = 0.75f;
	public float pounceNoiseLevel = 20;
	public float crouchNoiseDampen = 0;


	public float mapAmountNeeded = 5;
	public float knockOutTime = 30;
	public ParticleSystem bloodSpurt;

	[HideInInspector]
	public float health;

	//animation stuff
	protected Animator arms;
	private AnimatorStateInfo currentState;
	static int idleState = Animator.StringToHash("Base Layer.Idle");

	private bool prevGrounded = true;

	private bool chainPounce = true;
	private bool isPouncing = false;
	private int pounceCoolDown = 3;

	private bool isSlashing = false;

	private bool isCrouching = false;

	private FirstPersonCharacter fpc;
	private RaptorHUD hud;

	//Stuff for changing the color of the cursor
	private RaycastHit inRange;
	private float range = 8.5f;

	//Slashing melee detection
	private RaycastHit hit;
	private float meleeRange = 1.0f;

	private float mapAmountAcquired = 0;

	// Use this for initialization
	void Start() {
		fpc = gameObject.GetComponent<FirstPersonCharacter>();
		hud = gameObject.GetComponent<RaptorHUD>();
		arms = gameObject.GetComponentInChildren<Animator>();
		health = maxHealth;
	}

	// Update is called once per frame
	void Update() {
		Animation();
		if(health > 0) {
			Controls();
			HUD();
			MakeNoise();

			//prevents the player from getting stuck when pouncing next to a wall
			if(hud.stamina <= 0f) {
				isPouncing = false;
				fpc.enabled = true;
			}
		}
		else {
			//Die
			fpc.enabled = false;
			rigidbody.isKinematic = true;
		}
	}

	void HUD() {
		//Stamina updates
		if(isPouncing) {
			hud.Deplete("stamina", 1f * Time.deltaTime);
		}
		else if(chainPounce) {
			hud.Regenerate("stamina", 2.0f * Time.deltaTime);
		}
		else {
			hud.Regenerate("stamina", .66f * Time.deltaTime);
		}
	}

	void MakeNoise() {
		GameObject gridObject = GameObject.Find("CA Grid");
		if(gridObject != null) {
			ShipGrid grid = gridObject.GetComponent<ShipGrid>();
			ShipGridCell cell = grid.GetPos(transform.position);

			float noiseLevel = walkNoiseLevel;
			float noiseFalloff = walkNoiseFalloff;

			if(fpc.grounded) {
				if(!prevGrounded) {
					//noiseLevel = pounceNoiseLevel;
					//noiseFalloff = runNoiseFalloff;
				}
				else {
					if(fpc.moving) {
						if(fpc.running && !isCrouching) {
							noiseLevel = runNoiseLevel;
							noiseFalloff = runNoiseFalloff;
						}
						noiseLevel *= isCrouching ? crouchNoiseDampen : 1;
					}
					else {
						noiseLevel *= 0;
					}
				}
				prevGrounded = true;

			}
			else {
				if(prevGrounded) {
					//noiseLevel = pounceNoiseLevel;
					//noiseFalloff = runNoiseFalloff;
				}
				else {
					noiseLevel *= 0;
				}
				prevGrounded = false;
			}

			grid.AddFluid(transform.position, "noise", noiseLevel, noiseFalloff, 0.01f);
		}
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
			RaycastHit hit;
			if(Physics.Raycast(Camera.main.transform.position, Camera.main.transform.forward, out hit, 2)) {
				hit.transform.root.gameObject.SendMessage("Use", this, SendMessageOptions.DontRequireReceiver);
			}
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
						hit.transform.root.GetComponent<Enemy>().Hurt(1000);
					}
					else {
						hit.transform.root.GetComponent<Enemy>().Hurt(attack);
					}
					bloodSpurt.Play();
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
		else if(!crouching) {
			HOTween.To(cam, 0.3f, new TweenParms().Prop("localPosition", new Vector3(0f, -0.325f, 0f), false));
			//GetComponent<CapsuleCollider>().height = 1.5f;
			fpc.walkSpeed = 4f;
			fpc.strafeSpeed = 3;
			fpc.runSpeed = 8f;
		}
	}

	void Pounce() {
		if(hud.stamina == 1.0f && !isPouncing && fpc.grounded) {
			chainPounce = false;
			isPouncing = true;
			fpc.enabled = false;
			fpc.grounded = false;
			rigidbody.drag = 1;
			rigidbody.AddForce(transform.forward * 15f, ForceMode.Impulse);
			rigidbody.AddForce(transform.up * 5.5f, ForceMode.Impulse);
		}
	}

	void OnCollisionEnter(Collision other) {
		if(isPouncing) {
			isPouncing = false;
			rigidbody.drag = 0;
			fpc.enabled = true;
			//Chain pouncing
			if(other.gameObject.tag == "enemy") {
				other.transform.root.GetComponent<Enemy>().KnockOut(knockOutTime);
				chainPounce = true;
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
		GUI.DrawTexture(new Rect(x, y, crosshair.width / 3, crosshair.height / 3), crosshair);
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

	public void TransferMap(float amount) {
		mapAmountAcquired += amount;
	}

	public void Eat(float amount) {
		bloodSpurt.Play();
		if(health < maxHealth) {
			health += 0.02f;
			hud.health = health / maxHealth;
		}
		//print(health + " : " + hud.health);
	}

	public void Hurt(float damage) {
		health -= 1;
		hud.Deplete("health", 1.0f/maxHealth);
	}
}
