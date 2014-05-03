using UnityEngine;
using System.Collections;
using Holoville.HOTween;

public class Notoriety {
	public static float kill = 2000;
	public static float hack = 5;
	public static float steal = 1;
}

public class RaptorInteraction : MonoBehaviour {
	public Texture2D crosshair;
	public Texture2D noiseIndicator;
	public Texture2D painIndicator;
	//public PainIndicator painIndicator;

	//Raptor Stats
	public static string name = "Regina";
	public static string level = "DemoShip";
	public static float maxHealth = 100f;
	public static float attack = 20f;
	public static float stealthTime = 180f; //time in seconds

	//Defaults
	public static string defaultLevel = "DemoShip";
	public static float defaultMaxHealth = 100f;
	public static float defaultAttack = 20f;
	public static float defaultStealthTime = 180f; //time in seconds

	public Transform eatTarget;

	public static bool defusing = false;

	private bool climbing = false;
	public Transform raptorArms;
	Quaternion armRotation;
	Quaternion defaultRotation;

	public float pounceSpeed = 10;
	public float verticalPounceComponent = 0.1f;

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

	IKRaptor ikControl;

	private bool prevGrounded = true;
	public bool isMoving = false;
	public bool isRunning = false;

	private bool chainPounce = true;
	private bool isPouncing = false;
	private int pounceCoolDown = 3;

	public bool isSlashing = false;
	public bool isCrouching = false;
	public float lightLevel = 0;
	public float maxLightLevel = 10;

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
	public static float _notoriety = 0f;//Notoriety should increase by 2000 for killing a guy;
	public static float notorietyStep = 2000;
	public static int keyCount = 0;

	public static bool cutscene = false;

	public static float notoriety {
		get { return _notoriety; }
		set { 
			_notoriety = value;
			print("+"+value+" Notoriety");
		}
	}

	public Transform inventory;

	//Pause
	public bool paused = false;

	// Use this for initialization
	void Start() {
		LevelSelector.coastIsClear = false;
		ShipDoor.escaping = false;
		fpc = gameObject.GetComponent<FirstPersonCharacter>();
		hud = gameObject.GetComponent<RaptorHUD>();
		arms = gameObject.GetComponentInChildren<Animator>();

		ikControl = GetComponent<IKRaptor>();

		health = maxHealth;

		//defaultRotation = raptorArms.localRotation;
	}

	// Update is called once per frame
	void Update() {
		Animation();
		if(health > 0) {
			isMoving = fpc.moving;
			isRunning = fpc.running;

			Controls();
			HUD();
			MakeNoise();
			CheckGrid();

			EdgeDetectEffectNormals edge = Camera.main.GetComponent<EdgeDetectEffectNormals>();
			if(edge != null) {
				edge.enabled = true;// heatRenderer.enabled;
				edge.edgesOnly = Mathf.Lerp(edge.edgesOnly, Mathf.Max(0, Mathf.Min(1, 1 - lightLevel / maxLightLevel)), 0.1f);
			}

			//prevents the player from getting stuck when pouncing next to a wall
			if(hud.stamina <= 0f) {
				//isPouncing = false;
				//fpc.enabled = true;
			}
		}
		else {
			//Die
			fpc.enabled = false;
			rigidbody.isKinematic = false;
			rigidbody.constraints = RigidbodyConstraints.FreezeRotation;
			toggleRotator(false);
			arms.SetBool("isDead", true);
			if(!dieSoundPlaying) {
				dieSoundPlaying = true;
				SoundManager.instance.Play2DSound((AudioClip)Resources.Load("Sounds/Raptor Sounds/raptor/dying2"), SoundManager.SoundType.Sfx);
			}
		}

		Climb();
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

	void CheckGrid() {
		ShipGridCell cell = ShipGrid.GetPosI(transform.position);

		ShipGridFluid cellLight;
		cell.fluids.TryGetValue("light", out cellLight);
		float newLight = cellLight != null ? cellLight.level : 0;
		//lightLevel += (newLight - lightLevel) * 0.1f;
		lightLevel = Mathf.Lerp(lightLevel, newLight, 0.75f);

		ShipGridFluid damage;
		cell.fluids.TryGetValue("damage", out damage);
		if(damage != null && damage.level > 1f) {
			Hurt(new Damage(damage.level, transform.position));
		}
	}

	void Animation() {
		ikControl.isMoving = isMoving && fpc.grounded;
		ikControl.speed = (isMoving ? fpc.movingSpeed : new Vector3(0,0,1));

		ikControl.isPouncing = isPouncing;
		ikControl.isClinging = climbing;
		ikControl.isJumping = !fpc.grounded;

		currentState = arms.GetCurrentAnimatorStateInfo(0);

		if(currentState.nameHash == idleState || currentState.nameHash == crouchIdleState) {
			arms.SetBool("leftArmSlash", false);
			arms.SetBool("rightArmSlash", false);
			arms.SetBool("bothSlash", false);
		}

		//Eating sound stuff
		/*if(arms.GetBool("isEating") && !eatSoundPlaying) {
			eatSoundPlaying = true;
			SoundManager.instance.Play2DSound((AudioClip)Resources.Load("Sounds/Raptor Sounds/raptor/eating1"), SoundManager.SoundType.Sfx);
		}*/
	}

	void Controls() {
		if(!Pause.paused) {
			toggleRotator(true);
			if(RebindableInput.GetKey("Slash")) {
				Slash();
			}
			else if(RebindableInput.GetKeyDown("Pounce")) {
				Pounce();
			}

			if(RebindableInput.GetKeyDown("Crouch")) {
				isCrouching = !isCrouching;
				Crouch(isCrouching);
			}

			if(RebindableInput.GetKey("Use")) {
				RaycastHit hit;
				int mask = ~(1 << LayerMask.NameToLayer("Player"));
				if(Physics.Raycast(Camera.main.transform.position, Camera.main.transform.forward, out hit, 2, mask)) {
					//hit.transform.SendMessageUpwards("Use", gameObject, SendMessageOptions.DontRequireReceiver);
					ikControl.UseObject(hit.point+Camera.main.transform.up, hit.transform);
					if(hit.transform.tag != "trap") {
						defusing = false;
					}
				}
				else {
					defusing = false;
				}
				if(eatTarget != null) {
					eatTarget.SendMessageUpwards("Use", gameObject, SendMessageOptions.DontRequireReceiver);
				}
				else {
					toggleRotator(true);
					rigidbody.freezeRotation = false;
					rigidbody.constraints = RigidbodyConstraints.FreezeRotationX | RigidbodyConstraints.FreezeRotationZ;
					//arms.SetBool("isEating", false);
					eatSoundPlaying = false;
				}
			}
			//animation stuff
			else if(RebindableInput.GetKeyUp("Use")) {
				//eating stuff
				eatTarget = null;
				toggleRotator(true);
				rigidbody.freezeRotation = false;
				rigidbody.constraints = RigidbodyConstraints.FreezeRotationX | RigidbodyConstraints.FreezeRotationZ;
				arms.SetBool("isEating", false);
				eatSoundPlaying = false;

				//defusing mines
				defusing = false;
			}
		
			//Stop climbing
			if(RebindableInput.GetKeyDown("Jump") && climbing) {
				climbing = false;
				rigidbody.constraints = RigidbodyConstraints.FreezeRotationX | RigidbodyConstraints.FreezeRotationZ;
				rigidbody.isKinematic = false;
				fpc.enabled = true;
			}
		}
		else {
			toggleRotator(false);
		}
		if(RebindableInput.GetKeyDown("Drop")) {
			if(inventory.childCount > 0) {
				foreach(Transform child in inventory) {
					Collectible collectible = child.GetComponent<Collectible>();
					if(collectible != null && collectible.droppable && !collectible.keyCard) {
						child.parent = null;
						child.position = Camera.main.transform.TransformPoint(0, 0, 1);
						RaycastHit hit;
						int mask = ~(1 << LayerMask.NameToLayer("Player"));
						if(Physics.Raycast(Camera.main.transform.position, Camera.main.transform.forward, out hit, 1, mask)) {
							child.position = hit.point;
						}
						child.gameObject.active = true;
						break;
					}
				}
			}
		}
	}

	void Slash() {
		if(!isSlashing && !ikControl.isSlashing) {
			isSlashing = true;
			//animation stuff
			if(isCrouching) {
				if(Physics.Raycast(Camera.main.transform.position, transform.up, 1f)) {
					isSlashing = false;
					return;
				}
			}

			/*int arm = Random.Range(0, 3);
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
			}*/
			//hit detection
			Vector3 slashPos = Camera.main.transform.position + Camera.main.transform.forward * meleeRange;
			Transform slashTarget = null;
			if(Physics.Raycast(Camera.main.transform.position, Camera.main.transform.forward, out hit, meleeRange)) {
				slashPos = hit.point;
				slashTarget = hit.transform;
				if(hit.transform.tag == "enemy") {
					//do damage
					if(isPouncing) {
						//hit.transform.root.GetComponent<Enemy>().Hurt(1000);
						hit.transform.SendMessageUpwards("Hurt", new Damage(1000, transform.position), SendMessageOptions.DontRequireReceiver);
					}
					else {
						//hit.transform.root.GetComponent<Enemy>().Hurt(attack);
						hit.transform.SendMessageUpwards("Hurt", new Damage(attack, transform.position), SendMessageOptions.DontRequireReceiver);					
					}
					bloodSpurt.Play();
				}
			}
			ikControl.Slash(slashPos + transform.up*0.25f, slashTarget);
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
		//arms.SetBool("isCrouching", crouching);
		ikControl.isCrouching = crouching;
	}

	void Pounce() {
		if(hud.stamina == 1.0f && !isPouncing && (fpc.grounded || climbing)) {
			rigidbody.constraints = RigidbodyConstraints.FreezeRotationX | RigidbodyConstraints.FreezeRotationZ;
			rigidbody.isKinematic = false;
			fpc.enabled = true;
			climbing = false;

			chainPounce = false;
			isPouncing = true;
			fpc.grounded = false;
			rigidbody.velocity *= 0;
			float forwardpounce = pounceSpeed * (1 - verticalPounceComponent);
			float verticalPounce = pounceSpeed * verticalPounceComponent;
			rigidbody.velocity += Camera.main.transform.forward * forwardpounce;
			rigidbody.velocity += transform.up * verticalPounce;
			SoundManager.instance.Play2DSound((AudioClip)Resources.Load("Sounds/Raptor Sounds/raptor/slash2"), SoundManager.SoundType.Sfx);
		}
	}

	void OnCollisionEnter(Collision other) {
		if(isPouncing){// || !fpc.grounded) {
			//isPouncing = false;
			rigidbody.drag = 0;
			//fpc.enabled = true;

			//Chain pouncing
			if(other.gameObject.tag == "enemy") {
				//other.transform.root.GetComponent<Enemy>().KnockOut(knockOutTime);
				other.transform.SendMessageUpwards("KnockOut", knockOutTime, SendMessageOptions.DontRequireReceiver);
				chainPounce = true;
				isPouncing = false;
			}
			//else if(other.transform.tag == "room") {
			else if(other.rigidbody == null) {
				RaycastHit hit;
				int mask = ~(1 << LayerMask.NameToLayer("Player"));
				//check if the raptor is facing the wall
				if(Physics.Raycast(Camera.main.transform.position, Camera.main.transform.forward, out hit, 0.5f, mask)) {
					//if(hit.collider.gameObject == other.gameObject) {
						climbing = true;
						//armRotation = raptorArms.rotation;//Camera.main.transform.rotation;
						rigidbody.constraints = RigidbodyConstraints.FreezePosition;
						fpc.enabled = false;
						rigidbody.isKinematic = true;
						isPouncing = false;
						//print(hit.normal);
						ikControl.clingNormal = hit.normal;
						/*transform.rotation = Quaternion.LookRotation(-hit.normal);
						Vector3 angles = transform.localEulerAngles;
						angles.x -= 90;
						transform.localEulerAngles = angles;*/
					//}
				}
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

		float soundScale = noiseLevel / runNoiseLevel;
		soundScale += soundScale > 0 ? 1 : 0;
		x = (Screen.width / 2) - (noiseIndicator.width / 6) * soundScale;
		y = (Screen.height / 2) - (noiseIndicator.height / 6) * soundScale;

		GUI.DrawTexture(new Rect(x, y, noiseIndicator.width / 3 * soundScale, noiseIndicator.height / 3 * soundScale), noiseIndicator);
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
		if(inventory != null) {
			obj.transform.parent = inventory;
			obj.transform.localPosition *= 0;
			obj.gameObject.active = false;
			if(obj.keyCard) {
				keyCount++;
			}
		}
	}

	public void UnlockDoor(RaptorDoor door) {
		/*int cardCount = 0;
		foreach(Transform child in inventory) {
			Collectible collectible = child.GetComponent<Collectible>();
			if(collectible != null && collectible.keyCard) {
				cardCount++;
			}
		}*/

		/*if(keyCount >= door.keyCardsToUnlock) {
			door.LockDoor(false);
		}*/
		door.Unlock(keyCount);
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

	public void Hurt(Damage damage) {
		health -= damage.amount;
		hud.Deplete("health", damage.amount/maxHealth);

		/*PainIndicator indicator = (PainIndicator)Instantiate(painIndicator);
		indicator.transform.parent = Camera.main.transform;
		indicator.transform.localPosition = new Vector3(0, 0, 1);
		indicator.dir = Camera.main.transform.position-damage.pos;*/

		Indicator indicator = Indicator.New(painIndicator, damage.pos);
		indicator.tint = Color.red;
		indicator.dontDestroy = false;

		//print(health);
		SoundManager.instance.Play2DSound((AudioClip)Resources.Load("Sounds/Raptor Sounds/raptor/hurt"), SoundManager.SoundType.Sfx);
	}

	public void SellCollectibles() {
		if(inventory.childCount > 0) {
			foreach(Transform child in inventory) {
				Collectible collectible = child.GetComponent<Collectible>();
				if(collectible != null && !collectible.keyCard) {
					money += collectible.value;
				}

				CollectibleUpgrade upgrade = child.GetComponent<CollectibleUpgrade>();
				if(upgrade != null) {
					upgrade.Apply(this);
				}
			}
		}
		keyCount = 0;
	}

	void Climb() {
		isPouncing = fpc.grounded ? false : isPouncing;
		/*if(climbing) {
			raptorArms.rotation = armRotation;
			//Camera.main.GetComponent<SimpleMouseRotator>().rotationRange.x = 0f;
		}
		else {
			raptorArms.localRotation = defaultRotation;
			//Camera.main.GetComponent<SimpleMouseRotator>().rotationRange.x = 170f;
		}*/

	}

	public void toggleRotator(bool on){
		//GetComponent<SimpleMouseRotator>().enabled = on;
		//Camera.main.GetComponent<SimpleMouseRotator>().enabled = on;
	}

	/*void LateUpdate() {

		// read input from mouse or mobile controls
		float inputH = CrossPlatformInput.GetAxis("Mouse X");
		transform.localEulerAngles = transform.localEulerAngles + new Vector3(0, inputH*2, 0);

		if(rigidbody != null && !rigidbody.isKinematic) {
			rigidbody.angularVelocity *= 0;
			rigidbody.rotation = transform.rotation;
		}

	}*/
}