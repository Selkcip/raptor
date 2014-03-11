﻿using UnityEngine;
using System.Collections;
using System.Collections.Generic;

[RequireComponent(typeof(ThirdPersonCharacter))]
public class Enemy : MonoBehaviour {

	public float walkSpeed = 0.25f;
	public float runSpeed = 1.0f;
	public float avoidDis = 2f;
	public float collisionDeflectForce = 10f;
	public float viewDis = 10f;
	public float fov = 45f;
	public float noticeTime = 2;
	public float health = 100f;
	public float fleeHealth = 25f;
	public float standTime = 5f;
	public float lookTime = 1f;
	public float inspectTime = 5f;
	public float useTime = 5f;
	public float patrolTime = 5f;
	public float curiousNoiseLevel = 1f;
	public float alarmedNoiseLevel = 5f;
	public Weapon weapon;
	public Transform weaponAnchor;
	public bool carryingObject = false;
	public int money = 0;
	public float heat = 10f;
	public float heatFalloff = 0.25f;
	public float sleepTime = 0f;
	public string stateName;

	private bool crouch = false;

	//knocking the enemy out
	public bool knockedOut = false;
	private bool ragDoll = false;

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
	float noticeTimer = 0;
	public bool enemyVisible = false;
	public bool enemySeen = false;
	public float noiseLevel = 0;
	public Vector3 noiseDir = new Vector3();
	public float lightLevel = 0;
	public float maxLightLevel = 100;
	public float minLightLevel = 10;

	public float boredomLevel = 0;
	public ShipGridItem mostInteresting;
	public bool usingObject = false;
	public Transform useTarget;
	public Vector3 leftHandPos;
	public float leftHandWeight = 0;

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
		float lookTimer = 0;
		Vector3 lookDir = -transform.forward;
		Vector3 lookPos = new Vector3();
		State stand = new State(
			delegate() {
				return true;
			},
			delegate() {
				stateName = "Stand";
				speed = 0;

				lookTimer += Time.deltaTime;
				//if(targetDir != lookDir) {
				if(targetPos != lookPos) {
					//targetDir = Vector3.Lerp(targetDir, lookDir, lookTimer / lookTime);
					targetPos = Vector3.Lerp(targetPos, lookPos, lookTimer / lookTime);
				}
				else {
					if(lookTimer >= lookTime) {
						float ang = Mathf.Atan2(lookDir.z, lookDir.x) + Mathf.PI + Random.Range(-Mathf.PI/6, Mathf.PI/6);
						lookDir.x = Mathf.Cos(ang);
						lookDir.y = 0;
						lookDir.z = Mathf.Sin(ang);
						lookDir.Normalize();

						float lookDis = 5;
						float lookDisY = 2;
						lookPos.x = transform.position.x + Random.Range(-lookDis, lookDis);
						lookPos.y = transform.position.y + Random.Range(-lookDisY, lookDisY);
						lookPos.z = transform.position.z + Random.Range(-lookDis, lookDis);

						lookTimer = 0;
					}
				}

				standTimer += Time.deltaTime;
				return false;
			}
		);

		float inspectTimer = 0;
		//Vector3 itemPos = new Vector3();
		State inspect = new State(
			delegate() {
				return mostInteresting != null && boredomLevel >= mostInteresting.interestLevel && (!mostInteresting.carryable || (mostInteresting.carryable && !carryingObject));
			},
			delegate() {
				stateName = "Inspect";
				speed = 0;

				boredomLevel = 0;

				if(mostInteresting != null){
					targetDir = mostInteresting.transform.position - transform.position;
				}
				//targetDir = itemPos - transform.position;

				//if(targetPos-transform.position)

				float itemDis = targetDir.magnitude;
				if(itemDis > targetChangeTolerance) {
					speed = walkSpeed;
					if(mostInteresting != null) {
						targetPos = Vector3.zero + mostInteresting.transform.position;
					}
				}
				else {
					lookTimer += Time.deltaTime;
					if(targetPos != lookPos) {
						targetPos = Vector3.Lerp(targetPos, lookPos, lookTimer / lookTime);
					}
					else {
						inspectTimer += Time.deltaTime;
						if(lookTimer >= lookTime) {
							float lookDis = 0.25f;
							if(mostInteresting != null) {
								lookPos.x = mostInteresting.transform.position.x + Random.Range(-lookDis, lookDis);
								lookPos.y = mostInteresting.transform.position.y + Random.Range(-lookDis, lookDis);
								lookPos.z = mostInteresting.transform.position.z + Random.Range(-lookDis, lookDis);

								if(mostInteresting.useTarget != null) {
									useTarget = mostInteresting.useTarget;
									usingObject = true;
								}
							}

							//mostInteresting.SendMessage("Use", gameObject, SendMessageOptions.DontRequireReceiver);
							

							lookTimer = 0;
						}
					}
				}

				//crouch = true;
				//targetDir = transform.position + transform.forward;

				if(inspectTimer >= inspectTime) {
					inspectTimer = 0;
					mostInteresting = null;
					//crouch = false;
					return true;
				}

				return false;
			}
		);

		bool initUse = true;
		float useTimer = 0;
		State use = new State(
			delegate() {
				return usingObject && useTarget != null;
			},
			delegate() {
				stateName = "Use";
				speed = 0;

				if(initUse) {
					//leftHandPos = enemy.
				}

				enemy.SetIKPositionWeight(AvatarIKGoal.LeftHand, 1.0f);

				Vector3 useTargetPos = useTarget.position;
				if(usingObject && (leftHandPos != useTargetPos || leftHandWeight < 1)) {
					leftHandPos = useTargetPos;// Vector3.Lerp(leftHandPos, useTargetPos, useTimer / useTime);
					//leftHandWeight = Mathf.Min(1, leftHandWeight + Time.deltaTime);
					leftHandWeight = Mathf.Min(1, useTimer / useTime);
				}
				else {
					usingObject = false;
					useTarget.SendMessageUpwards("Use", gameObject, SendMessageOptions.DontRequireReceiver);
					useTarget = null;
				}

				useTimer += Time.deltaTime;

				return !usingObject;
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
						carryingObject = false;
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

				AvoidObstacles();

				targetPos = transform.position + targetDir * 10;

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

				targetPos = enemyPos;

				if(weapon != null) {
					weapon.transform.LookAt(enemyPos);
					return weapon.Use(gameObject);
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

				AvoidObstacles();

				targetPos = enemyPos;

				if(!enemySeen) {
					return true;
				}

				float enemyDis = (enemyPos - transform.position).magnitude;
				if(enemyDis <= targetChangeTolerance) {
					targetDir = enemyDiff;
					if(weapon != null) {
						weapon.Use(gameObject);
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

				AvoidObstacles();

				targetPos = transform.position + targetDir * 10;

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

				AvoidObstacles();

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

				targetPos = minAlarmPos;

				if(minAlarmDis <= targetChangeTolerance) {
					if(minAlarm != null) {
						//minAlarm.Use();
						usingObject = true;
						useTarget = minAlarm.transform;
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

				AvoidObstacles();

				targetDir += noiseDir;
				targetPos = transform.position + targetDir * 10;

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

				AvoidObstacles();

				targetDir += noiseDir;
				targetPos = transform.position + targetDir * 10;

				standTimer = standTime;

				return noiseLevel < alarmedNoiseLevel;
			}
		);

		State toggleFlashlight = new State(
			delegate() {
				return weapon != null && weapon.flashLight != null && (lightLevel <= minLightLevel || lightLevel >= maxLightLevel);
			},
			delegate() {
				stateName = "Toggle Flashlight";

				weapon.flashLight.enabled = lightLevel <= minLightLevel ? true : false;

				return noiseLevel < alarmedNoiseLevel;
			}
		);

		states.Add(stand);

		stand.Add(sleep);
		stand.Add(inspect);
		stand.Add(patrol);
		stand.Add(hurt);
		stand.Add(shoot);
		stand.Add(chase);
		stand.Add(flee);
		stand.Add(followNoise);
		stand.Add(toggleFlashlight);

		sleep.Add(wakeUp);

		wakeUp.Add(stand);

		inspect.Add(use);
		inspect.Add(sleep);
		inspect.Add(toggleFlashlight);

		use.Add(sleep);

		patrol.Add(sleep);
		patrol.Add(hurt);
		patrol.Add(inspect);
		patrol.Add(shoot);
		patrol.Add(chase);
		patrol.Add(flee);
		patrol.Add(followNoise);
		patrol.Add(toggleFlashlight);

		shoot.Add(sleep);
		shoot.Add(chase);
		shoot.Add(flee);
		shoot.Add(soundAlarm);
		shoot.Add(toggleFlashlight);

		chase.Add(sleep);
		chase.Add(shoot);
		chase.Add(flee);
		chase.Add(soundAlarm);
		chase.Add(toggleFlashlight);
		 
		soundAlarm.Add(use);
		soundAlarm.Add(toggleFlashlight);

		followNoise.Add(sleep);
		followNoise.Add(hurt);
		followNoise.Add(inspect);
		followNoise.Add(chaseNoise);
		followNoise.Add(chase);
		followNoise.Add(flee);
		followNoise.Add(toggleFlashlight);

		chaseNoise.Add(sleep);
		chaseNoise.Add(hurt);
		chaseNoise.Add(inspect);
		chaseNoise.Add(chase);
		chaseNoise.Add(flee);
		chaseNoise.Add(toggleFlashlight);

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
			if(Vector3.Dot(norm, transform.up) < 0.5f) {
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
		curViewDis = Mathf.Max(0.0001f, viewDis * lightLevel/maxLightLevel);//Mathf.Max(viewDis, curViewDis - 1.0f * Time.deltaTime);
		if(Alarm.activated) {
			curFov = alertFov;
			//curViewDis = viewDis*2;
		}

		boredomLevel += Time.deltaTime;

		LookForEnemy();
		CheckGrid();

		//AvoidObstacles();

		if(health > 0) {
			states.Update();
			ShipGrid.AddFluidI(transform.position, "heat", heat*Time.deltaTime, heatFalloff, 0.01f);
		}
		else {
			knockedOut = true;
			character.enabled = false;
			rigidbody.isKinematic = true;
			if(!ragDoll) {
				RagDoll(transform, true);
				//transform.position = transform.position + transform.Find("Ethan/char_ethan_skeleton/char_ethan_Hips").localPosition;
				//rigidbody.AddForce(Camera.main.transform.forward * 10, ForceMode.Impulse);

			}
			GetComponent<CapsuleCollider>().enabled = false;
			GetComponent<Animator>().enabled = false;

			RaptorInteraction.notoriety += Notoriety.kill;

			if(weapon != null) {
				weapon.Drop();
				weapon = null;
				carryingObject = false;
			}
		}

		if(health > 0 && !knockedOut) {
			targetDir.Normalize();
			//character.Move(targetDir * speed, false, false, transform.position + transform.forward * 10);
			//character.Move(targetDir * speed, crouch, false, transform.position + targetDir * 10);
			character.Move(targetDir * speed, crouch, false, targetPos);
			//character.Move(targetDir * speed, false, false, Camera.main.transform.position);
		}

		Animation();
	}

	void AvoidObstacles() {
		RaycastHit hit;
		if(rigidbody.SweepTest(transform.forward, out hit, avoidDis)) {
			Vector3 norm = hit.normal;
			if(Vector3.Dot(norm, transform.up) < 0.5f) {
				Vector3 reflect = Vector3.Reflect(transform.forward, norm);
				float length = new Vector2(reflect.x, reflect.z).magnitude;
				float rang = Mathf.Atan2(reflect.z, reflect.x) + Random.Range(-0.1f, 0.1f);
				reflect.x = Mathf.Cos(rang) * length;
				reflect.z = Mathf.Sin(rang) * length;
				reflect.Normalize();
				targetDir += reflect * collisionDeflectForce * (1.0f - hit.distance / avoidDis);
				if(hit.distance < 0.25f) {
					targetDir = -transform.forward;
				}
			}
		}
	}

	void LookForEnemy() {
		enemyVisible = false;
		RaptorInteraction player = GameObject.Find("Player").GetComponent<RaptorInteraction>();
		if(player != null && player.health > 0) {
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
							noticeTimer += (1.0f-hit.distance/curViewDis)*Time.deltaTime;
							if(noticeTimer >= noticeTime) {
								enemyVisible = true;
								enemySeen = true;
								enemyPos = enemyHead.position;
								//enemyDir = enemyHead.forward;
							}
						}
					}
				}
			}
		}
	}

	void CheckGrid() {
		//GameObject gridObject = GameObject.Find("CA Grid");
		if(ShipGrid.instance != null) {
			ShipGridCell cell = ShipGrid.GetPosI(transform.position);
			
			//Listen for noise
			ShipGridFluid noise;
			cell.fluids.TryGetValue("noise", out noise);
			if(noise != null) {
				noiseLevel = noise.level;

				foreach(ShipGridCell neigh in cell.neighbors) {
					neigh.fluids.TryGetValue("noise", out noise);
					if(noise != null) {
						if(noise.level > noiseLevel) {
							noiseLevel = noise.level;
							noiseDir = ShipGrid.IndexToPosI(neigh.x, neigh.y, neigh.z) - transform.position;
						}
					}
				}
			}

			ShipGridFluid cellLight;
			cell.fluids.TryGetValue("light", out cellLight);
			lightLevel = cellLight != null ? cellLight.level : 0;

			//Look for objects to inspect and bodies
			List<ShipGridItem> contents = new List<ShipGridItem>();
			contents.AddRange(cell.contents);
			foreach(ShipGridCell neigh in cell.neighbors){
				contents.AddRange(neigh.contents);
			}
			contents.Sort(delegate(ShipGridItem a, ShipGridItem b) {
				return Mathf.RoundToInt(a.interestLevel - b.interestLevel);
			});
			if(contents.Count > 0) {
				mostInteresting = contents[0];
			}
			else {
				mostInteresting = null;
			}
		}
	}

	public void Use(GameObject user) {
		if(user.tag == "Player") {
			RaptorInteraction player = user.GetComponent<RaptorInteraction>();
			if(!knockedOut) {
				RaptorInteraction.notoriety += Notoriety.steal;
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
	}

	public void KnockOut(float time) {
		if(!enemyVisible && sleepTime <= 0) {
			sleepTime = time;
		}
		else if(enemyVisible && sleepTime <= 0){
			health = 0;
		}
	}

	public void Hurt(float damage) {
		health -= damage;
	}

	public void TakeMoney(int amount) {
		money += amount;
	}

	void Animation() {
		enemy.SetFloat("Health", health);
		enemy.SetBool("KnockedOut", knockedOut);
	}

	void OnAnimatorIK() {
		if(!usingObject) {
			leftHandWeight = Mathf.Max(0, leftHandWeight-Time.deltaTime);
			//enemy.SetIKPositionWeight(AvatarIKGoal.LeftHand, leftHandWeight - Time.deltaTime);
		}
		enemy.SetIKPositionWeight(AvatarIKGoal.LeftHand, leftHandWeight);
		//enemy.SetIKRotationWeight(AvatarIKGoal.LeftHand, 1.0f);
		enemy.SetIKPosition(AvatarIKGoal.LeftHand, leftHandPos);
		//enemy.SetIKRotation(AvatarIKGoal.LeftHand, leftHandObj.rotation);
	}

	void RagDoll(Transform obj, bool on) {
		foreach(Transform child in obj) {
			if(child.name == "Gun") {
				continue;
			}

			child.tag = "enemy";
			if(child.rigidbody != null) {
				child.rigidbody.isKinematic = !on;

				if(on) {
					child.rigidbody.AddForce(Camera.main.transform.forward * 5f, ForceMode.Impulse);
				}
			}

			if(child.collider != null) {
				child.collider.enabled = on;
			}
			RagDoll(child, on);
		}
		ragDoll = on;
	}
}
