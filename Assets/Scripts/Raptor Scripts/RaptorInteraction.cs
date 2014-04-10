using UnityEngine;
using System.Collections;
using Holoville.HOTween;

public class Notoriety {
	public static float kill = 10;
	public static float hack = 5;
	public static float steal = 1;
}

public class RaptorInteraction : MonoBehaviour {
	public Texture2D crosshair;
	public Texture2D noiseIndicator;

	//Raptor Stats
	public static float maxHealth = 10f;	//the number of times you can get hit
	public static float attack = 20f;
	public static float stealthTime = 180f; //time in seconds

	public Transform eatTarget;

	//sound stuff
	public float noiseLifeTime = 0.5f;
	public float noiseFlowRate = 0.9f;
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

	private float noiseLevel;

	//animation stuff
	protected Animator arms;
	private AnimatorStateInfo currentState;
	static int idleState = Animator.StringToHash("Base Layer.Idle");
	static int crouchIdleState = Animator.StringToHash("Base Layer.crouching_Idle");

	private bool prevGrounded = true;

	private bool chainPounce = true;
	private bool isPouncing = false;
	private int pounceCoolDown = 3;

	private bool isSlashing = false;

	private bool isCrouching = false;

	//sound stuff
	bool eatSoundPlaying = false;
	bool dieSoundPlaying = false;

	private FirstPersonCharacter fpc;
	private RaptorHUD hud;

	//Stuff for changing the color of the cursor
	private RaycastHit inRange;
	private float range = 8.5f;

	//Slashing melee detection
	private RaycastHit hit;
	private float meleeRange = 1.0f;

	//Collection data
	public static float mapAmountAcquired = 0;
	public static int money = 100000;
	public static float notoriety = 900000f;//Notoriety should increase by 2000 for killing a guy;
	public static float notorietyStep = 2000;

	public Transform inventory;

	// Use this for initialization
	void Start() {
		ShipDoor.escaping = false;
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
			rigidbody.constraints = RigidbodyConstraints.FreezeRotation;
			toggleRotator(false);
			arms.SetBool("isDead", true);
			if(!dieSoundPlaying) {
				dieSoundPlaying = true;
				SoundManager.instance.Play2DSound((AudioClip)Resources.Load("Sounds/Raptor Sounds/raptor/dying2"), SoundManager.SoundType.Sfx);
			}
		}

		InAttackRange();
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
			//ShipGrid grid = gridObject.GetComponent<ShipGrid>();
			ShipGridCell cell = ShipGrid.GetPosI(transform.position);

			noiseLevel = walkNoiseLevel;
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

			ShipGrid.AddFluidI(transform.position, "noise", noiseLevel, noiseLifeTime, noiseFlowRate);
			//ShipGrid.AddFluidI(transform.position, "noise", 0, noiseFalloff, 0.01f);
		}
	}

	void Animation() {
		currentState = arms.GetCurrentAnimatorStateInfo(0);

		if(currentState.nameHash == idleState || currentState.nameHash == crouchIdleState) {
			arms.SetBool("leftArmSlash", false);
			arms.SetBool("rightArmSlash", false);
			arms.SetBool("bothSlash", false);
		}

		//Eating sound stuff
		if(arms.GetBool("isEating") && !eatSoundPlaying) {
			eatSoundPlaying = true;
			SoundManager.instance.Play2DSound((AudioClip)Resources.Load("Sounds/Raptor Sounds/raptor/eating1"), SoundManager.SoundType.Sfx);
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
				hit.transform.SendMessageUpwards("Use", gameObject, SendMessageOptions.DontRequireReceiver);
			}

			if (eatTarget != null){
				eatTarget.SendMessageUpwards("Use", gameObject, SendMessageOptions.DontRequireReceiver);
			}
			else {
				toggleRotator(true);
				rigidbody.freezeRotation = false;
				rigidbody.constraints = RigidbodyConstraints.FreezeRotationX | RigidbodyConstraints.FreezeRotationZ;
				arms.SetBool("isEating", false);
				eatSoundPlaying = false;
			}
		}
		//animation stuff
		else if(Input.GetKeyUp(KeyCode.E)) {
			eatTarget = null;
			toggleRotator(true);
			rigidbody.freezeRotation = false;
			rigidbody.constraints = RigidbodyConstraints.FreezeRotationX | RigidbodyConstraints.FreezeRotationZ;
			arms.SetBool("isEating", false);
			eatSoundPlaying = false;
		}

		if(Input.GetKeyUp(KeyCode.F)) {
			EdgeDetectEffectNormals edge = Camera.main.GetComponent<EdgeDetectEffectNormals>();
			if(edge != null) {
				edge.enabled = !edge.enabled;// heatRenderer.enabled;
			}
		}

		if(Input.GetKeyUp(KeyCode.R)) {
			Transform child = inventory.GetChild(0);
			if(child != null) {
				//child.gameObject
			}
		}
	}

	void Slash() {
		if(!isSlashing) {
			isSlashing = true;
			//animation stuff
			if(isCrouching) {
				if(Physics.Raycast(Camera.main.transform.position, transform.up, 1f)) {
					isSlashing = false;
					return;
				}
			}

			int arm = Random.Range(0, 3);
			if(arm == 0) {
				arms.SetBool("leftArmSlash", true);
				SoundManager.instance.Play2DSound((AudioClip)Resources.Load("Sounds/Raptor Sounds/raptor/slash1"), SoundManager.SoundType.Sfx);
			}
			else if(arm == 1) {
				arms.SetBool("rightArmSlash", true);
				SoundManager.instance.Play2DSound((AudioClip)Resources.Load("Sounds/Raptor Sounds/raptor/slash1"), SoundManager.SoundType.Sfx);
			}
			else {
				arms.SetBool("bothSlash", true);
				SoundManager.instance.Play2DSound((AudioClip)Resources.Load("Sounds/Raptor Sounds/raptor/slash2"), SoundManager.SoundType.Sfx);
			}
			//hit detection
			if(Physics.Raycast(Camera.main.transform.position, Camera.main.transform.forward, out hit, meleeRange)) {
				if(hit.transform.tag == "enemy") {
					//do damage
					if(isPouncing) {
						//hit.transform.root.GetComponent<Enemy>().Hurt(1000);
						hit.transform.SendMessageUpwards("Hurt", 1000, SendMessageOptions.DontRequireReceiver);
					}
					else {
						//hit.transform.root.GetComponent<Enemy>().Hurt(attack);
						hit.transform.SendMessageUpwards("Hurt", attack, SendMessageOptions.DontRequireReceiver);					
					}
					bloodSpurt.Play();
				}
			}
			StartCoroutine("SlashCoolDown");
		}
	}

	IEnumerator SlashCoolDown() {
		if(isCrouching) {
			yield return new WaitForSeconds(0.75f);
		}
		else {
			yield return new WaitForSeconds(0.4f);
		}
		isSlashing = false;
	}

	void Crouch(bool crouching) {
		Transform cam = Camera.main.transform;
		if(crouching) {
			//HOTween.To(cam, 0.3f, new TweenParms().Prop("localPosition", new Vector3(0f, -1f, 0f), false));
			//GetComponent<CapsuleCollider>().height = 1f;
			fpc.walkSpeed = 1.75f;
			fpc.strafeSpeed = 1.25f;
			fpc.runSpeed = 1.75f;
		}
		else if(!crouching) {
			if(Physics.Raycast(Camera.main.transform.position, transform.up, 1f)) {
				isCrouching = true;
				return;
			}
			//HOTween.To(cam, 0.3f, new TweenParms().Prop("localPosition", new Vector3(0f, -0.325f, 0f), false));
			//GetComponent<CapsuleCollider>().height = 1.5f;
			fpc.walkSpeed = 4f;
			fpc.strafeSpeed = 3;
			fpc.runSpeed = 8f;
		}
		arms.SetBool("isCrouching", crouching);
	}

	void Pounce() {
		if(hud.stamina == 1.0f && !isPouncing && fpc.grounded) {
			chainPounce = false;
			isPouncing = true;
			fpc.grounded = false;
			rigidbody.velocity *= 0;
			rigidbody.velocity += Camera.main.transform.forward * 15f;
			//rigidbody.velocity += Camera.main.transform.up * 5.5f;
			rigidbody.velocity += transform.up * 5.5f; //This is always up so the player can pounce straight up
			SoundManager.instance.Play2DSound((AudioClip)Resources.Load("Sounds/Raptor Sounds/raptor/slash2"), SoundManager.SoundType.Sfx);
		}
	}

	void OnCollisionEnter(Collision other) {
		if(isPouncing) {
			isPouncing = false;
			rigidbody.drag = 0;
			//fpc.enabled = true;
			//Chain pouncing
			if(other.gameObject.tag == "enemy") {
				//other.transform.root.GetComponent<Enemy>().KnockOut(knockOutTime);
				other.transform.SendMessageUpwards("KnockOut", knockOutTime, SendMessageOptions.DontRequireReceiver);
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
		if(!ShipDoor.escaping) {
			float x = (Screen.width / 2) - (crosshair.width / 6);
			float y = (Screen.height / 2) - (crosshair.height / 6);
			GUI.DrawTexture(new Rect(x, y, crosshair.width / 3, crosshair.height / 3), crosshair);

			float soundScale = noiseLevel / runNoiseLevel;
			soundScale += soundScale > 0 ? 1 : 0;
			x = (Screen.width / 2) - (noiseIndicator.width / 6) * soundScale;
			y = (Screen.height / 2) - (noiseIndicator.height / 6) * soundScale;

			GUI.DrawTexture(new Rect(x, y, noiseIndicator.width / 3 * soundScale, noiseIndicator.height / 3 * soundScale), noiseIndicator);
		}
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

	public void TakeMoney(int amount) {
		money += amount;
	}

	public void Collect(Collectible obj) {
		obj.transform.parent = inventory;
		obj.transform.localPosition *= 0;
		obj.enabled = false;
	}

	public void Eat(float amount) {
		if(Physics.Raycast(Camera.main.transform.position, Camera.main.transform.forward, 0.75f)) {
			bloodSpurt.Play();
		}

		toggleRotator(false);
		rigidbody.freezeRotation = true;
		arms.SetBool("isEating", true);

		/*if(!isCrouching) {
			isCrouching = true;
			Crouch(isCrouching);
		}*/

		if(health < maxHealth) {
			health += 0.02f;
			hud.health = health / maxHealth;
		}
	}

	public void Hurt(float damage) {
		health -= damage;
		hud.Deplete("health", 1.0f/maxHealth);
		SoundManager.instance.Play2DSound((AudioClip)Resources.Load("Sounds/Raptor Sounds/raptor/hurt"), SoundManager.SoundType.Sfx);
	}

	void toggleRotator(bool on){
		GetComponent<SimpleMouseRotator>().enabled = on;
		Camera.main.GetComponent<SimpleMouseRotator>().enabled = on;
	}
}
