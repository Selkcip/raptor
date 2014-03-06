using UnityEngine;
using System.Collections;

[RequireComponent(typeof(ThirdPersonCharacter))]
public class Enemy : MonoBehaviour {

	public float walkSpeed = 0.25f;
	public float runSpeed = 1.0f;
	public float collisionDeflectForce = 10;
	public float viewDis = 10f;
	public float fov = 45f;
	public float health = 100f;
	public float fleeHealth = 25;
	public float standTime = 2f;
	public float patrolTime = 5f;
	public float curiousNoiseLevel = 1;
	public float alarmedNoiseLevel = 5;
	public Weapon weapon;
	public float heat = 10;
	public float heatFalloff = 0.25f;
	public float sleepTime = 0f;
	public string stateName;

	//knocking the enemy out?
	public bool knockedOut = false;

	public ThirdPersonCharacter character { get; private set; }     // the character we are controlling
	public Transform target;										// target to aim for
	public float targetChangeTolerance = 1;				            // distance to target before target can be changed

	Vector3 targetDir;
	Vector3 targetPos;
	bool running = false;
	float speed = 0;

	float curFov = 0;
	float curViewDis = 0;
	float alertFov = 360;
	float alertViewDis = 10;
	Vector3 enemyDiff;
	Vector3 enemyPos;
	Vector3 enemyDir;
	public bool enemyVisible = false;
	public bool enemySeen = false;
	public float noiseLevel = 0;
	public Vector3 noiseDir = new Vector3();

	private float bodyRemaining = 1;

	StateMachine states;

	//Animation stuff
	protected Animator enemy;

	// Use this for initialization
	void Start() {

		// get the components on the object we need ( should not be null due to require component so no need to check )
		character = GetComponent<ThirdPersonCharacter>();
		enemy = GetComponent<Animator>();

		targetDir = transform.forward;

		curFov = fov;
		curViewDis = viewDis;

		states = new StateMachine();

		float standTimer = 0;
		State stand = new State(
			delegate() {
				return true;
			},
			delegate() {
				stateName = "Stand";
				speed = 0;

				standTimer += Time.deltaTime;
				return false;
			}
		);

		State sleep = new State(
			delegate() {
				return sleepTime > 0;
			},
			delegate() {
				stateName = "Sleep";
				speed = 0;

				curFov = 0;
				curViewDis = 0;

				if(sleepTime > 0 && !knockedOut) {
					knockedOut = true;

					character.enabled = false;
					rigidbody.isKinematic = true;
					RagDoll(transform, true);
					GetComponent<CapsuleCollider>().enabled = false;
					GetComponent<Animator>().enabled = false;

					if(weapon != null) {
						weapon.Drop();
						weapon = null;
					}
				}

				sleepTime -= Time.deltaTime;
				return !knockedOut;
			},
			10
		);

		State wakeUp = new State(
			delegate() {
				return knockedOut && sleepTime <= 0;
			},
			delegate() {
				stateName = "Wake Up";
				speed = 0;

				knockedOut = false;

				rigidbody.isKinematic = false;
				RagDoll(transform, false);
				GetComponent<Animator>().enabled = true;
				GetComponent<CapsuleCollider>().enabled = true;
				character.enabled = true;
				return true;
			}
		);

		float patrolTimer = 0;
		State patrol = new State(
			delegate() {
				if(standTimer >= standTime) {
					standTimer = 0;
					return true;
				}
				return false;
			},
			delegate() {
				stateName = "Patrol";
				speed = walkSpeed;

				patrolTimer += Time.deltaTime;
				if(patrolTimer >= patrolTime) {
					patrolTimer = 0;
					return true;
				}
				return false;
			}
		);

		State shoot = new State(
			delegate() {
				return enemyVisible && weapon != null && weapon.type == WeaponType.projectile && (weapon.ammo > 0 || weapon.clip > 0);
			},
			delegate() {
				stateName = "Shoot";
				speed = 0.0001f;

				float enemyDis = (enemyPos - transform.position).magnitude;
				targetDir = (enemyPos - transform.position).normalized;

				if(weapon != null) {
					weapon.transform.LookAt(enemyPos);
					return weapon.Use();
				}

				return !(enemyVisible && weapon.ammo > 0);
			},
			5
		);

		State chase = new State(
			delegate() {
				return enemySeen && health > fleeHealth;//&& (!(enemyVisible && weapon.ammo > 0) || (enemyVisible && weapon != null && weapon.type == WeaponType.melee));
			},
			delegate() {
				stateName = "Chase";
				speed = runSpeed;

				if(!enemySeen) {
					return true;
				}

				float enemyDis = (enemyPos - transform.position).magnitude;
				if(enemyDis <= targetChangeTolerance) {
					targetDir = enemyDiff;
					if(weapon != null) {
						weapon.Use();
					}
					enemySeen = false;
				}
				else {
					targetDir += (enemyPos - transform.position).normalized * 5;
				}

				return false;
			}
		);

		float oldHealth = health;

		State hurt = new State(
			delegate() {
				return health < oldHealth;//&& (!(enemyVisible && weapon.ammo > 0) || (enemyVisible && weapon != null && weapon.type == WeaponType.melee));
			},
			delegate() {
				stateName = "Hurt";

				curFov = alertFov;
				curViewDis = viewDis * 2;

				oldHealth = health;

				return true;
			},
			10
		);

		State flee = new State(
			delegate() {
				return enemyVisible && health <= fleeHealth;//&& (!(enemyVisible && weapon.ammo > 0) || (enemyVisible && weapon != null && weapon.type == WeaponType.melee));
			},
			delegate() {
				stateName = "Flee";
				speed = runSpeed;

				if(!enemyVisible) {
					enemySeen = false;
					return true;
				}

				targetDir -= (enemyPos - transform.position).normalized * 5;

				return false;
			},
			10
		);

		State soundAlarm = new State(
			delegate() {
				return !enemySeen && !Alarm.activated;
			},
			delegate() {
				stateName = "Sound Alarm";
				speed = runSpeed;

				float minAlarmDis = Mathf.Infinity;
				Alarm minAlarm;
				Vector3 minAlarmPos = transform.position;
				minAlarm = Alarm.alarms[0];
				if(!Alarm.activated) {
					foreach(Alarm alarm in Alarm.alarms) {
						float dis = (alarm.transform.position - transform.position).magnitude;
						if(dis < minAlarmDis) {
							minAlarmDis = dis;
							minAlarmPos = alarm.transform.position;
							minAlarm = alarm;
						}
					}
				}

				if(minAlarmDis <= targetChangeTolerance) {
					if(minAlarm != null) {
						minAlarm.Use();
					}
				}
				else {
					targetDir += (minAlarmPos - transform.position).normalized * 5;
				}

				return Alarm.activated;
			}
		);

		State followNoise = new State(
			delegate() {
				return noiseLevel >= curiousNoiseLevel;
			},
			delegate() {
				stateName = "Follow Noise";
				speed = walkSpeed;

				targetDir += noiseDir;

				standTimer = standTime;

				return noiseLevel < curiousNoiseLevel;
			}
		);

		State chaseNoise = new State(
			delegate() {
				return noiseLevel >= alarmedNoiseLevel;
			},
			delegate() {
				stateName = "Chase Noise";
				speed = runSpeed;

				targetDir += noiseDir;

				standTimer = standTime;

				return noiseLevel < alarmedNoiseLevel;
			}
		);

		states.Add(stand);

		stand.Add(sleep);
		stand.Add(patrol);
		stand.Add(hurt);
		stand.Add(shoot);
		stand.Add(chase);
		stand.Add(flee);
		stand.Add(followNoise);

		sleep.Add(wakeUp);

		wakeUp.Add(stand);

		patrol.Add(sleep);
		patrol.Add(hurt);
		patrol.Add(shoot);
		patrol.Add(chase);
		patrol.Add(flee);
		patrol.Add(followNoise);

		//shoot.Add(sleep);
		//shoot.Add(chase);
		shoot.Add(flee);
		shoot.Add(soundAlarm);

		chase.Add(sleep);
		chase.Add(shoot);
		chase.Add(flee);
		chase.Add(soundAlarm);

		followNoise.Add(sleep);
		followNoise.Add(hurt);
		followNoise.Add(chaseNoise);
		followNoise.Add(chase);
		followNoise.Add(flee);

		chaseNoise.Add(sleep);
		chaseNoise.Add(hurt);
		chaseNoise.Add(chase);
		chaseNoise.Add(flee);

		RagDoll(transform, false);
	}

	void OnCollisionEnter(Collision col) {
		OnCollisionStay(col);
	}

	void OnCollisionStay(Collision col) {
		if(col.other.tag == "Player") {
			curFov = alertFov;
			curViewDis = viewDis * 2;
		}
		if(col.contacts.Length > 0) {
			Vector3 norm = col.contacts[0].normal;
			/*foreach(ContactPoint point in col.contacts) {
				norm += point.normal;
			}*/
			//print(norm+": "+Vector3.Dot(norm, transform.up));
			if(Vector3.Dot(norm, transform.up) < 1) {
				Vector3 reflect = Vector3.Reflect(transform.forward, norm);
				float length = new Vector2(reflect.x, reflect.z).magnitude;
				float rang = Mathf.Atan2(reflect.z, reflect.x) + Random.Range(-0.1f, 0.1f);
				reflect.x = Mathf.Cos(rang) * length;
				reflect.z = Mathf.Sin(rang) * length;
				reflect.Normalize();
				targetDir += reflect * collisionDeflectForce;
			}
		}
	}

	// Update is called once per frame
	void Update() {
		curFov = Mathf.Max(fov, curFov - 1.0f * Time.deltaTime);
		curViewDis = Mathf.Max(viewDis, curViewDis - 1.0f * Time.deltaTime);
		if(Alarm.activated) {
			curFov = alertFov;
			curViewDis = viewDis*2;
		}

		LookForEnemy();
		ListenForNoise();

		if(health > 0) {
			states.Update();
			ShipGrid.AddFluidI(transform.position, "heat", heat, heatFalloff, 0.01f);
		}
		else {
			knockedOut = true;
			character.enabled = false;
			rigidbody.isKinematic = true;
			RagDoll(transform, true);
			GetComponent<CapsuleCollider>().enabled = false;
			GetComponent<Animator>().enabled = false;

			if(weapon != null) {
				weapon.Drop();
				weapon = null;
			}
		}

		if(health > 0 && !knockedOut) {
			targetDir.Normalize();
			character.Move(targetDir * speed, false, false, transform.position + transform.forward * 10);
		}

		Animation();
	}

	void LookForEnemy() {
		enemyVisible = false;
		Transform enemyHead = Camera.main.transform;
		if(enemyHead != null) {
			enemyDiff = enemyHead.position - (transform.position + new Vector3(0, 1, 0));
			enemyDir.x = enemyDiff.x;
			enemyDir.y = enemyDiff.y;
			enemyDir.z = enemyDiff.z;
			enemyDiff.y = 0;
			enemyDiff.Normalize();

			if(Vector3.Dot(transform.forward, enemyDiff) >= 1.0f - (curFov / 2.0f) / 90.0f) {
				RaycastHit hit;
				if(Physics.Raycast(transform.position + new Vector3(0, 1, 0), enemyDir, out hit, curViewDis)) {
					if(hit.collider.tag == "Player" || (hit.collider.transform.parent != null && hit.collider.transform.parent.tag == "Player")) {
						enemyVisible = true;
						enemySeen = true;
						enemyPos = enemyHead.position;
						//enemyDir = enemyHead.forward;
					}
				}
			}
		}
	}

	void ListenForNoise() {
		GameObject gridObject = GameObject.Find("CA Grid");
		if(gridObject != null) {
			ShipGrid grid = gridObject.GetComponent<ShipGrid>();

			Vector3 index = grid.PosToIndex(transform.position);

			ShipGridCell cell = grid.GetPos(transform.position);
			//grid.AddFluid(transform.position, "noise", 0.1f, 0.5f, 0.01f);
			/*ShipGridFluid noise = cell.fluids.Find(delegate(ShipGridFluid item) {
				return item.type == "noise";
			});
			if(noise != null) {
				noiseLevel = noise.level;

				foreach(ShipGridCell neigh in cell.neighbors) {
					noise = neigh.fluids.Find(delegate(ShipGridFluid item) {
						return item.type == "noise";
					});
					if(noise != null) {
						if(noise.level > noiseLevel) {
							noiseLevel = noise.level;
							noiseDir = grid.IndexToPos(neigh.x, neigh.y, neigh.z) - transform.position;
						}
					}
				}
			}*/
		}
	}

	public void Use(RaptorInteraction player) {
		if(!knockedOut) {
			player.SendMessage("TakeMoney", 1, SendMessageOptions.DontRequireReceiver);
		}
		else {
			if(health > 0) {
				health = 0;
			}
			else {
				bodyRemaining -= 0.1f * Time.deltaTime;
					player.SendMessage("Eat", 1, SendMessageOptions.DontRequireReceiver);
				if(bodyRemaining > 0.25) {
					transform.localScale = new Vector3(bodyRemaining, bodyRemaining, bodyRemaining);
				}
				else {
					Destroy(gameObject);
				}
			}
		}
	}

	public void KnockOut(float time) {
		if(!enemyVisible && sleepTime <= 0) {
			sleepTime = time;
		}
		else {
			health = 0;
		}
	}

	public void Hurt(float damage) {
		health -= damage;
	}

	void Animation() {
		enemy.SetFloat("Health", health);
		enemy.SetBool("KnockedOut", knockedOut);
	}

	void RagDoll(Transform obj, bool on) {
		foreach(Transform child in obj) {
			child.tag = "enemy";
			rigidbody.isKinematic = on;

			if(child.collider != null) {
				child.collider.enabled = on;
			}
			RagDoll(child, on);
		}

	}
}
