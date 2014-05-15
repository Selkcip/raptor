using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(NavMeshAgent))]
[RequireComponent(typeof(ThirdPersonCharacter))]
public class PlanningNPC : MonoBehaviour {
	public Transform target;										// target to aim for
	public float targetChangeTolerance = 1;				            // distance to target before target can be changed

	Vector3 targetPos;

	public float walkSpeed = 0.25f;
	public float runSpeed = 1.0f;
	public float maxStamina = 5;
	public float viewDis = 10f;
	public float fov = 45f;
	public float noticeTime = 2;
	public float health = 100f;
	public float fleeHealth = 25f;
	public float standTime = 5f;
	public float lookTime = 1f;
	public float inspectTime = 5f;
	public float useTime = 5f;
	public float wanderTime = 5f;
	public bool followsNoise = false;
	public float curiousNoiseLevel = 1f;
	public float alarmedNoiseLevel = 5f;
	public float noiseLevel = 0;
	public float maxLightLevel = 100;
	public float minLightLevel = 10;
	public float lightLevel = 0;
	public Weapon weapon;
	public Transform weaponAnchor;
	public Transform inventory;
	public Transform head;
	public int money = 0;
	public float sleepTime = 0;
	public float stamina = 1;

	public float enemyVisibility = 1;

	public bool sleeping = false;
	public bool knockedOut = false;
	public bool dead = false;
	public bool tired = false;
	public bool healthLow = false;
	public bool hasTarget = false;
	public bool atTarget = false;
	public bool standing = false;
	public bool running = false;
	public bool carryingObject = false;
	public bool hasUseTarget = false;
	public bool usingObject = false;
	public bool crouch = false;
	public bool enemyVisible = false;
	//public bool enemyNoticed = false;
	public bool enemySeen = false;
	public bool alertShip = false;
	public bool alarmFound = false;
	public bool alarmActivated = false;
	public bool bored = false;
	public bool canInspect = false;
	public bool curious = false;
	public bool alarmed = false;
	public bool hasFlashlight = false;
	public bool flashLightOn = false;
	public bool needLight = false;
	public bool canSee = false;

	//Vector3 targetDir;
	//Vector3 targetPos;

	bool ragDoll = false;
	float speed = 0;
	public float curFov = 0;
	public float curViewDis = 0;
	float alertFov = 360;
	public float noticeTimer = 0;
	float bodyRemaining = 1;
	bool mentionEnemyVisible = false;
	float oldLightLevel = 0;

	public Vector3 enemyPos;
	public Transform useTarget;
	public Vector3 noiseDir = new Vector3();
	public Vector3 noisePos = new Vector3();
	public float boredomLevel = 0;
	public ShipGridItem mostInteresting;
	public Vector3 leftHandPos;
	public float leftHandWeight = 0;
	public Vector3 rightHandPos;
	public float rightHandWeight = 0;

	protected Planner planner = new Planner();
	protected List<PlanAction> plan = new List<PlanAction>();
	protected List<PlanGoal> goals = new List<PlanGoal>();
	protected PlanGoal goal;
	public string actionName = "no action";

	protected StateMachine states;

	public NavMeshAgent agent { get; private set; }                 // the navmesh agent required for the path finding
	public ThirdPersonCharacter character { get; private set; }     // the character we are controlling
	public Animator animator { get; private set; }
	public RagdollHelper ragdollHelper;// = GetComponent<RagdollHelper>();
	public RaptorInteraction player;

	// Use this for initialization
	public virtual void Start() {

		// get the components on the object we need ( should not be null due to require component so no need to check )
		character = GetComponent<ThirdPersonCharacter>();
		animator = GetComponent<Animator>();

		agent = GetComponentInChildren<NavMeshAgent>();
		agent.updatePosition = false;
		agent.updateRotation = false;

		ragdollHelper = GetComponent<RagdollHelper>();

		player = GameObject.FindObjectOfType<RaptorInteraction>();
		stamina = maxStamina;

		//InitGoals();
		//InitActions();

		//Plan();

		InitStates();

		RagDoll(transform, false);
	}

	NavMeshHit nearestHit;
	Vector3 NearestNavPoint(Vector3 pos) {
		NavMesh.SamplePosition(pos, out nearestHit, 10, 0);
		if(nearestHit.hit) {
			pos = nearestHit.position;
		}
		return pos;
	}

	protected State stand, sleep, moveToTarget, useObject, activateAlarm, flee, inspect, wander, followNoise, chaseNoise;
	public virtual void InitStates() {
		states = new StateMachine();

		float standTimer = 0;
		float lookTimer = 0;
		Vector3 lookPos = Vector3.zero;
		stand = new State(
			delegate() {
				return true;
			},
			delegate() {
				actionName = "Stand";

				lookTimer += Time.deltaTime;

				Move(Vector3.zero, targetPos);

				if(targetPos != lookPos) {
					targetPos = Vector3.Lerp(targetPos, lookPos, lookTimer / lookTime);
				}
				else {
					if(lookTimer >= lookTime) {
						float lookDis = 0.25f;
						lookPos.x += Random.Range(-lookDis, lookDis);
						lookPos.y += Random.Range(-lookDis, lookDis);
						lookPos.z += Random.Range(-lookDis, lookDis);

						lookTimer = 0;
					}
				}

				standTimer += Time.deltaTime;
				if(standTimer >= standTime) {
					stamina = maxStamina;
					standTimer = 0;
					return true;
				}

				return false;
			}
		);

		sleep = new State(
			delegate() {
				return sleeping || knockedOut;
			},
			delegate() {
				actionName = "Sleep";

				if(!knockedOut) {
					knockedOut = true;
					character.enabled = false;
					rigidbody.isKinematic = true;
					RagDoll(transform, true);
					GetComponent<CapsuleCollider>().enabled = false;
					animator.enabled = false;

					DropEverything();

					gameObject.GetComponent<ShipGridItem>().interestLevel = 0.001f;

					if(weapon != null) {
						weapon.Drop();
						weapon = null;
						carryingObject = false;
					}

					SoundManager.instance.Play3DSound((AudioClip)Resources.Load("Sounds/Raptor Sounds/enemies/Guard/dying"), SoundManager.SoundType.Dialogue, gameObject);
				}
				else {
					if(!dead) {
						sleepTime -= Time.deltaTime;

						if(sleepTime <= 0) {
							if(!animator.enabled) {
								rigidbody.isKinematic = false;
								animator.enabled = true;
								RagDoll(transform, false);
								collider.enabled = true;
								character.enabled = true;

								gameObject.GetComponent<ShipGridItem>().interestLevel = Mathf.Infinity;
							}
							else {
								knockedOut = false;
								animator.SetBool("GetUpFromBelly", false);
								animator.SetBool("GetUpFromBack", false);
								SoundManager.instance.Play3DSound((AudioClip)Resources.Load("Sounds/Raptor Sounds/enemies/Guard/iguessipassedout"), SoundManager.SoundType.Dialogue, gameObject);
								return true;
							}
						}
					}
				}

				return false;
			}
		);

		moveToTarget = new State(
			delegate() {
				return hasTarget && !atTarget;
			},
			delegate() {
				actionName = "MoveToTarget";

				// update the progress if the character has made it to the previous target
				//if((target.position - targetPos).magnitude > targetChangeTolerance) {
				targetPos = target.position;
				agent.SetDestination(targetPos);
				//}

				// update the agents posiiton 
				agent.transform.position = transform.position;

				if(agent.pathStatus == NavMeshPathStatus.PathPartial) {
					//print("can't reach target");
					target = null;
					useTarget = null;
					return true;
				}

				// use the values to move the character
				//character.Move(agent.desiredVelocity.normalized * speed, false, false, targetPos);
				Move(agent.desiredVelocity, targetPos);
				standing = false;

				return atTarget;
			}
		);

		float useTimer = 0;
		Vector3 useTargetPos = Vector3.zero;
		useObject = new State(
			delegate() {
				return hasUseTarget && usingObject && atTarget;
			},
			delegate() {
				actionName = "Use Object";

				animator.SetIKPositionWeight(AvatarIKGoal.LeftHand, 1.0f);

				useTimer += Time.deltaTime;

				if(useTarget != null) {
					useTargetPos = useTarget.position;
					if(usingObject && (leftHandPos != useTargetPos || leftHandWeight < 1)) {
						leftHandPos = useTargetPos;// Vector3.Lerp(leftHandPos, useTargetPos, useTimer / useTime);
						//leftHandWeight = Mathf.Min(1, leftHandWeight + Time.deltaTime);
						leftHandWeight = Mathf.Min(1, useTimer / useTime);
					}
					else {
						if(useTarget.tag != "enemy") {
							SoundManager.instance.Play3DSound((AudioClip)Resources.Load("Sounds/Raptor Sounds/enemies/Guard/whatdoesthisbuttondo"), SoundManager.SoundType.Dialogue, gameObject);
						}
						usingObject = false;
						useTarget.SendMessageUpwards("Use", gameObject, SendMessageOptions.DontRequireReceiver);
						useTarget = null;
						target = null;
					}
				}
				else {
					usingObject = false;
					useTarget = null;
					target = null;
				}

				if(!usingObject) {
					useTimer = 0;
				}

				return !hasUseTarget || !usingObject;
			}
		);

		activateAlarm = new State(
			delegate() {
				return alertShip && !enemyVisible;
			},
			delegate() {
				actionName = "Activate Alarm";

				running = true;

				if(!alarmFound) {
					float minAlarmDis = Mathf.Infinity;
					Alarm minAlarm;
					Vector3 minAlarmPos = transform.position;
					if(Alarm.alarms.Count > 0) {
						minAlarm = Alarm.alarms[0];
						if(!Alarm.activated) {
							foreach(Alarm alarm in Alarm.alarms) {
								targetPos = alarm.transform.position;
								agent.SetDestination(targetPos);
								float dis = (alarm.transform.position - transform.position).magnitude;
								if(dis < minAlarmDis) {
									minAlarmDis = dis;
									minAlarmPos = alarm.transform.position;
									minAlarm = alarm;
								}
							}
						}

						target = minAlarm.transform;
						alarmFound = true;
					}
					else {
						Alarm.activated = true;
						alarmActivated = true;
					}
				}
				else {
					usingObject = true;
					useTarget = target;
					//alarmActivated = true;
					enemySeen = false;
					return true;
				}

				return false;
			}
		);

		bool fleePosSet = false;
		flee = new State(
			delegate() {
				return healthLow && enemySeen;
			},
			delegate() {
				actionName = "Flee";

				running = true;

				if(!fleePosSet) {
					List<Vector3> positions = new List<Vector3>();
					positions.Add(NearestNavPoint(transform.position + transform.forward * 10));
					positions.Add(NearestNavPoint(transform.position - transform.forward * 10));
					positions.Add(NearestNavPoint(transform.position + transform.right * 10));
					positions.Add(NearestNavPoint(transform.position - transform.right * 10));

					float maxDis = 0;
					targetPos = positions[0];
					foreach(Vector3 pos in positions) {
						float dis = (player.transform.position - pos).magnitude;
						if(dis > maxDis) {
							targetPos = pos;
							maxDis = dis;
						}
					}

					fleePosSet = true;
				}
				
				agent.SetDestination(targetPos);

				// update the agents posiiton 
				agent.transform.position = transform.position;
				//print(agent.desiredVelocity);

				// use the values to move the character
				Move(agent.desiredVelocity, targetPos);

				if(agent.pathStatus == NavMeshPathStatus.PathPartial || agent.remainingDistance < targetChangeTolerance) {
					fleePosSet = false;
					return true;
				}

				return false;
			}
		);

		float inspectTimer = 0;
		inspect = new State(
			delegate() {
				return bored && canInspect;
			},
			delegate() {
				actionName = "Inspect";

				if(!atTarget) {
					if(mostInteresting != null) {
						target = mostInteresting.transform;

						PlanningNPC npc = mostInteresting.GetComponent<PlanningNPC>();
						if(npc != null && (npc.knockedOut || npc.dead)) {
							alertShip = true;
						}
					}

					return true;
				}
				else {

					lookTimer += Time.deltaTime;

					Move(Vector3.zero, targetPos);

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
									bored = false;
								}
							}

							lookTimer = 0;
						}
					}

					if(inspectTimer >= inspectTime) {
						inspectTimer = 0;
						mostInteresting = null;
						usingObject = false;
						boredomLevel = 0;
					}
				}

				return !bored;
			}
		);

		float wanderTimer = wanderTime;
		Vector3 wanderPos = new Vector3();
		wander = new State(
			delegate() {
				return wanderTime > 0 && !enemySeen && !enemyVisible && !tired;
			},
			delegate() {
				actionName = "Wander";

				running = false;
				wanderTimer += Time.deltaTime;

				agent.SetDestination(wanderPos);

				// update the agents posiiton 
				agent.transform.position = transform.position;

				// use the values to move the character
				Move(agent.desiredVelocity);

				NavMeshHit hit;
				if(wanderTimer >= wanderTime || agent.remainingDistance <= targetChangeTolerance) {// || agent.pathStatus == NavMeshPathStatus.PathPartial) {
					actionName = "Rethinking Wander";

					wanderPos = transform.position + transform.forward * 10;
					NavMesh.SamplePosition(wanderPos, out hit, 10, 0);
					if(hit.hit) {
						wanderPos = hit.position;
					}
					wanderTimer = 0;
					return true;
				}

				return false;// sleeping || enemySeen || alertShip || canInspect;
			}
		);

		bool initNoise = true;
		followNoise = new State(
			delegate() {
				return followsNoise && curious && !alarmed && !enemyVisible;
			},
			delegate() {
				actionName = "Follow Noise";

				running = false;

				if(initNoise) {
					noisePos = transform.position + noiseDir * 10;
					initNoise = false;
				}

				agent.SetDestination(noisePos);

				// update the agents posiiton 
				agent.transform.position = transform.position;

				NavMeshHit hit;
				agent.Raycast(transform.position + transform.forward, out hit);


				if(hit.hit || agent.remainingDistance <= targetChangeTolerance || agent.pathStatus == NavMeshPathStatus.PathPartial) {
					initNoise = true;
					return true;
				}

				// use the values to move the character
				Move(agent.desiredVelocity);

				return false;
			}
		);

		chaseNoise = new State(
			delegate() {
				return followsNoise && curious && alarmed && !enemyVisible;
			},
			delegate() {
				actionName = "Chase Noise";

				running = true;

				if(initNoise) {
					noisePos = transform.position + noiseDir * 10;
					initNoise = false;
				}

				agent.SetDestination(noisePos);

				// update the agents posiiton 
				agent.transform.position = transform.position;

				NavMeshHit hit;
				agent.Raycast(transform.position + transform.forward, out hit);


				if(hit.hit || agent.remainingDistance <= targetChangeTolerance || agent.pathStatus == NavMeshPathStatus.PathPartial) {
					initNoise = true;
					return true;
				}

				// use the values to move the character
				Move(agent.desiredVelocity);

				return false;
			}
		);

		sleep.priority = 100;
		flee.priority = 90;
		useObject.priority = 80;
		activateAlarm.priority = 70;
		inspect.priority = 60;
		chaseNoise.priority = 55;
		followNoise.priority = 50;
		moveToTarget.priority = 40;
		wander.priority = 10;

		states.Add(stand);
		states.Add(sleep);
		states.Add(moveToTarget);
		states.Add(useObject);
		states.Add(activateAlarm);
		states.Add(flee);
		//states.Add(inspect);
		states.Add(wander);
		//states.Add(followNoise);
		//states.Add(chaseNoise);
	}

	// Update is called once per frame
	public virtual void Update() {
		bool justDied = false;
		if(!dead && health <= 0) {
			dead = true;
			justDied = true;
			RaptorInteraction.notoriety += Notoriety.kill;
		}
		healthLow = health <= fleeHealth;
		sleeping = dead || sleepTime > 0;
		standing = !character.moving;
		stamina -= character.moving ? Time.deltaTime*speed : 0;
		tired = stamina <= 0;
		hasTarget = target != null;
		atTarget = hasTarget ? (target.position - transform.position).magnitude < targetChangeTolerance : false;
		hasUseTarget = useTarget != null;
		alarmActivated = Alarm.activated;
		alertShip = alarmActivated ? false : alertShip;
		bored = boredomLevel > 0;
		canInspect = mostInteresting != null && mostInteresting.interestLevel <= boredomLevel;
		curious = noiseLevel >= curiousNoiseLevel;
		alarmed = noiseLevel >= alarmedNoiseLevel;
		hasFlashlight = weapon != null && weapon.flashLight != null;
		flashLightOn = hasFlashlight && weapon.flashLight.enabled == true;
		needLight = lightLevel <= minLightLevel ? true : (lightLevel >= maxLightLevel ? false : needLight);

		if(weapon != null && weapon.flashLight != null) {
			weapon.flashLight.enabled = lightLevel <= minLightLevel ? true : (lightLevel >= maxLightLevel ? false : weapon.flashLight.enabled);
		}

		curFov = Mathf.Max(fov, curFov - 1.0f * Time.deltaTime);
		curViewDis = viewDis;// Mathf.Max(0.0001f, viewDis * lightLevel / maxLightLevel);//Mathf.Max(viewDis, curViewDis - 1.0f * Time.deltaTime);
		if(enemySeen || Alarm.activated) {
			curFov = alertFov;
			//curViewDis = viewDis*2;
		}

		boredomLevel += Time.deltaTime;

		speed = running ? runSpeed : walkSpeed;

		if(!dead && !knockedOut) {
			LookForEnemy();
			CheckGrid();
		}

		actionName = "No Action";
		//Plan();
		states.Update();
	}

	protected void Move(Vector3 moveDir, Vector3 lookPos) {
		character.Move(moveDir.normalized * speed, false, false, lookPos);
	}

	protected void Move(Vector3 moveDir) {
		Move(moveDir, transform.position + transform.forward * 100);
	}

	protected void LookForEnemy() {
		enemyVisible = false;
		if(!knockedOut) {
			if(player.active && player != null && player.health > 0) {
				Transform enemyHead = Camera.main.transform;
				if(enemyHead != null) {
					enemyVisibility = 1;
					enemyVisibility += player.isMoving ? 1 : 0;
					enemyVisibility += player.isRunning ? 2 : 0;
					enemyVisibility += player.isSlashing ? 1 : 0;
					enemyVisibility *= player.isCrouching ? 0.5f : 1;
					enemyVisibility /= 5; //Number of inputs
					enemyVisibility *= Mathf.Max(0, player.lightLevel / maxLightLevel);

					if(enemyVisibility >= 0.01f) {
						Vector3 enemyDiff = enemyHead.position - (transform.position + new Vector3(0, 1, 0));
						enemyDiff.Normalize();

						if(Vector3.Dot(head.forward, enemyDiff) >= 1.0f - (curFov / 2.0f) / 90.0f) {
							RaycastHit hit;
							if(Physics.Raycast(transform.position + new Vector3(0, 1, 0), enemyDiff, out hit, curViewDis)) {
								if(hit.collider.tag == "Player" || (hit.collider.transform.parent != null && hit.collider.transform.parent.tag == "Player")) {
									enemyVisible = true;
									noticeTimer += enemyVisibility * Mathf.Max(0, (1.0f - hit.distance / curViewDis)) * Time.deltaTime;
									print("noticing");
									if(noticeTimer >= noticeTime) {
										enemySeen = true;
										alertShip = true;
										enemyPos = enemyHead.position;
										//enemyDir = enemyHead.forward;
									}
								}
							}
							Color rayColor = Color.green;
							rayColor = enemyVisible ? Color.magenta : rayColor;
							rayColor = enemySeen ? Color.red : rayColor;
							//Debug.DrawRay(transform.position + new Vector3(0, 1, 0), enemyDiff, Color.red);
							Debug.DrawLine(transform.position + new Vector3(0, 1, 0), transform.position + new Vector3(0, 1, 0) + enemyDiff * curViewDis, rayColor);
						}
					}

					if(!enemyVisible) {
						noticeTimer = Mathf.Max(0, noticeTimer-Time.deltaTime);
					}
				}
			}
			if(enemySeen) {
				if(!mentionEnemyVisible) {
					List<string> lines = new List<string>();
					lines.Add("sweetjesusisthataraptor");
					lines.Add("whatwasthat");
					lines.Add("didyouseethat");
					SoundManager.instance.Play3DSound((AudioClip)Resources.Load("Sounds/Raptor Sounds/enemies/Guard/" + lines[Random.Range(0, lines.Count - 1)]), SoundManager.SoundType.Dialogue, gameObject);
					mentionEnemyVisible = true;
				}
			}
			else {
				if(mentionEnemyVisible && player.health > 0) {
					SoundManager.instance.Play3DSound((AudioClip)Resources.Load("Sounds/Raptor Sounds/enemies/Guard/wherediditgo"), SoundManager.SoundType.Dialogue, gameObject);
					mentionEnemyVisible = false;
				}
			}
		}
	}

	protected void CheckGrid() {
		//GameObject gridObject = GameObject.Find("CA Grid");
		if(ShipGrid.instance != null) {
			ShipGridCell cell = ShipGrid.GetPosI(transform.position);

			//Listen for noise
			ShipGridFluid noise;
			cell.fluids.TryGetValue("noise", out noise);
			if(noise != null) {
				noiseLevel = noise.level;
				//noiseDir.Set(0, 0, 0);
				/*foreach(ShipGridCell neigh in cell.neighbors) {
					neigh.fluids.TryGetValue("noise", out noise);
					if(noise != null) {
						if(noise.level > noiseLevel) {
							noiseLevel = noise.level;
							noiseDir += ShipGrid.IndexToPosI(neigh.x, neigh.y, neigh.z) - transform.position;
						}
					}
				}*/
				Vector3 diff = new Vector3();
				foreach(ShipGridCell neigh in cell.neighbors) {
					neigh.fluids.TryGetValue("noise", out noise);
					if(noise != null) {
						diff.x = neigh.x - cell.x;
						diff.y = neigh.y - cell.y;
						diff.z = neigh.z - cell.z;
						noiseDir += (diff * (noise.level-noiseLevel)).normalized * Mathf.Abs(noise.level);
					}
				}
				noiseDir.Normalize();
				Debug.DrawRay(transform.position, noiseDir, Color.blue);
			}

			ShipGridFluid cellLight;
			cell.fluids.TryGetValue("light", out cellLight);
			float newLight = cellLight != null ? cellLight.level : 0;
			lightLevel += (newLight - lightLevel) * 0.1f;
			if(oldLightLevel >= minLightLevel && lightLevel < minLightLevel) {
				//SoundManager.instance.Play3DSound((AudioClip)Resources.Load("Sounds/Raptor Sounds/enemies/Guard/icantseeanything"), SoundManager.SoundType.Dialogue, gameObject);
				oldLightLevel = lightLevel;
			}
			else if(lightLevel >= maxLightLevel) {
				oldLightLevel = lightLevel;
			}

			//Look for objects to inspect and bodies
			List<ShipGridItem> contents = new List<ShipGridItem>();
			contents.AddRange(cell.contents);
			foreach(ShipGridCell neigh in cell.neighbors) {
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
				//RaptorInteraction.notoriety += Notoriety.steal;
				//player.SendMessage("TakeMoney", 1, SendMessageOptions.DontRequireReceiver);
				LoseCollectible(user);
			}
			else {
				if(health > 0) {
					health = 0;
				}
				else {
					bodyRemaining -= 0.1f * Time.deltaTime;
					player.SendMessage("Eat", 1, SendMessageOptions.DontRequireReceiver);
					if(bodyRemaining > 0.25) {
						player.eatTarget = transform;
						//transform.localScale = new Vector3(bodyRemaining, bodyRemaining, bodyRemaining);
					}
					else {
						player.eatTarget = null;
						//DropEverything();
						Destroy(gameObject);
					}
				}
			}
		}
		else {
			if(knockedOut) {
				SoundManager.instance.Play3DSound((AudioClip)Resources.Load("Sounds/Raptor Sounds/enemies/Guard/heymanareyouok"), SoundManager.SoundType.Dialogue, user);
				sleepTime = 0;
			}
		}
	}

	public void KnockOut(float time) {
		if(!enemyVisible && sleepTime <= 0) {
			sleepTime = time;
			standing = false;
		}
		else if(enemyVisible && sleepTime <= 0) {
			//health = 0;
		}
	}

	public void Hurt(Damage damage) {
		health -= damage.amount;
		if(!knockedOut) {
			SoundManager.instance.Play3DSound((AudioClip)Resources.Load("Sounds/Raptor Sounds/enemies/Guard/hurt"), SoundManager.SoundType.Dialogue, gameObject);
		}
		curFov = 360;
		noticeTimer = noticeTime;
	}

	public void TakeMoney(int amount) {
		money += amount;
	}

	public void UnlockDoor(RaptorDoor door) {
		if(door.guardsCanUnlock){
			door.Unlock(door.keyCardsToUnlock);
		}
		//door.OpenDoor(door.guardsCanUnlock);
	}

	public void Collect(Collectible obj) {
		if(inventory != null) {
			obj.transform.parent = inventory;
			obj.transform.localPosition *= 0;
			obj.gameObject.SetActive(false);
		}
	}

	public void LoseCollectible(GameObject thief) {
		foreach(Transform child in inventory) {
			Collectible collectible = child.GetComponent<Collectible>();
			if(collectible != null) {
				RaptorInteraction.notoriety += Notoriety.steal;
				child.parent = null;
				child.position = transform.TransformPoint(0, 1, -1);
				RaycastHit hit;
				if(Physics.Raycast(transform.TransformPoint(0, 1, -1), -transform.forward, out hit, 1)) {
					child.position = hit.point;
				}
				child.gameObject.SetActive(true);
				//thief.SendMessageUpwards("Collect", collectible, SendMessageOptions.DontRequireReceiver);
				RaptorInteraction.notoriety += Notoriety.steal*collectible.value;
				break;
			}
		}
	}

	public void DropEverything() {
		foreach(Transform child in inventory) {
			Collectible collectible = child.GetComponent<Collectible>();
			if(collectible != null) {
				child.parent = null;
				child.position = transform.position+Vector3.up;
				/*RaycastHit hit;
				if(Physics.Raycast(transform.TransformPoint(0, 1, -1), -transform.forward, out hit, 1)) {
					child.position = hit.point;
				}*/
				child.gameObject.active = true;
				//thief.SendMessageUpwards("Collect", collectible, SendMessageOptions.DontRequireReceiver);
			}
		}
	}

	protected void Animation() {
		animator.SetFloat("Health", health);
		animator.SetBool("KnockedOut", knockedOut);
	}

	protected void OnAnimatorIK() {
		if(!usingObject) {
			//leftHandWeight = Mathf.Max(0, leftHandWeight-Time.deltaTime);
			if(weapon != null) {
				Transform leftHandTarget = weapon.transform.FindChild("Left Hand");
				leftHandPos = Vector3.Lerp(leftHandPos, leftHandTarget.position, 0.5f);
				leftHandWeight = 1.0f;
			}
			else {
				leftHandWeight = Mathf.Max(0, leftHandWeight - Time.deltaTime);
			}
			//animator.SetIKPositionWeight(AvatarIKGoal.LeftHand, leftHandWeight - Time.deltaTime);
		}
		animator.SetIKPositionWeight(AvatarIKGoal.LeftHand, leftHandWeight);
		//animator.SetIKRotationWeight(AvatarIKGoal.LeftHand, 1.0f);
		animator.SetIKPosition(AvatarIKGoal.LeftHand, leftHandPos);
		//animator.SetIKRotation(AvatarIKGoal.LeftHand, leftHandObj.rotation);

		if(weapon != null) {
			Transform rightHandTarget = weapon.transform.FindChild("Right Hand");
			rightHandPos = rightHandTarget.position;
			rightHandWeight = 1.0f;
		}
		else {
			rightHandWeight = Mathf.Max(0, rightHandWeight - Time.deltaTime);
		}

		animator.SetIKPositionWeight(AvatarIKGoal.RightHand, rightHandWeight);
		//animator.SetIKRotationWeight(AvatarIKGoal.RightHand, 1.0f);
		animator.SetIKPosition(AvatarIKGoal.RightHand, rightHandPos);
		//animator.SetIKRotation(AvatarIKGoal.RightHand, leftHandObj.rotation);
	}

	protected void RagDoll(Transform obj, bool on) {
		Transform[] children = transform.GetAllComponentsInChildren<Transform>();
		foreach(Transform child in children) {
			if(child.name == "Gun") {
				continue;
			}

			child.tag = "enemy";
			if(child.rigidbody != null) {
				child.rigidbody.isKinematic = !on;

				if(on) {
					//This is wrong I think. This should be based off the player's direction and point of impact
					child.rigidbody.AddForce(Camera.main.transform.forward * 5f, ForceMode.Impulse);
				}
			}

			if(child.collider != null) {
				child.collider.enabled = on;
			}
			//RagDoll(child, on);
		}
		ragDoll = on;
		if(ragdollHelper != null) {
			ragdollHelper.ragdolled = on;
		}
		rigidbody.isKinematic = on;
		collider.enabled = !on;
	}
}
