using UnityEngine;
using System.Collections;

[RequireComponent(typeof(ThirdPersonCharacter))]
public class Enemy : MonoBehaviour {

	public float walkSpeed = 0.25f;
	public float runSpeed = 1.0f;
	public float viewDis = 10f;
	public float fov = 45f;
	public float health = 100f;
	public float standTime = 2f;
	public float patrolTime = 5f;
	public Weapon weapon;
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
				return false;
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

				sleepTime -= Time.deltaTime;
				return sleepTime <= 0;
			},
			10
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
				return enemyVisible && weapon != null && weapon.type == WeaponType.projectile && weapon.ammo > 0;
			},
			delegate() {
				stateName = "Shoot";
				speed = walkSpeed;

				float enemyDis = (enemyPos - transform.position).magnitude;
				targetDir = (enemyPos - transform.position).normalized;

				if(weapon != null) {
					return weapon.Use();
				}

				return false;
			},
			5
		);

		State chase = new State(
			delegate() {
				return enemySeen ;//&& (!(enemyVisible && weapon.ammo > 0) || (enemyVisible && weapon != null && weapon.type == WeaponType.melee));
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
						minAlarm.Activate();
					}
				}
				else {
					targetDir += (minAlarmPos - transform.position).normalized * 5;
				}

				return Alarm.activated;
			}
		);

		states.Add(stand);

		//stand.Add(sleep);
		stand.Add(patrol);
		stand.Add(shoot);
		stand.Add(chase);

		//patrol.Add(sleep);
		patrol.Add(shoot);
		patrol.Add(chase);

		//shoot.Add(sleep);
		shoot.Add(chase);
		shoot.Add(soundAlarm);

		//chase.Add(sleep);
		chase.Add(shoot);
		chase.Add(soundAlarm);
	}

	void OnCollisionEnter(Collision col) {
		OnCollisionStay(col);
	}

	void OnCollisionStay(Collision col) {
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
				targetDir += reflect * 5;
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

		enemyVisible = false;
		Transform enemyHead = Camera.main.transform;
		if(enemyHead != null) {
			enemyDiff = enemyHead.position - transform.position;
			enemyDiff.y = 0;
			enemyDiff.Normalize();

			if(Vector3.Dot(transform.forward, enemyDiff) >= 1.0f - (curFov / 2.0f) / 90.0f) {
				RaycastHit hit;
				if(Physics.Raycast(transform.position + new Vector3(0, 1, 0), enemyDiff, out hit, curViewDis)) {
					if(hit.collider.tag == "Player") {
						enemyVisible = true;
						enemySeen = true;
						enemyPos = enemyHead.position;
						enemyDir = enemyHead.forward;
					}
				}
			}
		}

		if(health > 0 && !knockedOut) {
			states.Update();
		}
		else {
			speed = 0;
			GetComponent<BoxCollider>().enabled = true;
			GetComponent<CapsuleCollider>().enabled = false;
		}

		targetDir.Normalize();
		character.Move(targetDir * speed, false, false, transform.position + transform.forward * 10);

		Animation();
	}

	public void SetTarget(Transform target) {
		this.target = target;
	}

	void Animation() {
		enemy.SetFloat("Health", health);
		enemy.SetBool("KnockedOut", knockedOut);
	}
}
