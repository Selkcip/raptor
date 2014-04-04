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
	public float noiseLevel = 0;
	public float maxLightLevel = 100;
	public float minLightLevel = 10;
	public float lightLevel = 0;
	public Weapon weapon;
	public Transform weaponAnchor;
	public int money = 0;
	public float sleepTime = 0;

	public bool sleeping = false;
	public bool knockedOut = false;
	public bool dead = false;
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
	public bool enemySeen = false;
	public bool alarmFound = false;
	public bool alarmActivated = false;
	public bool bored = false;
	public bool canInspect = false;

	//Vector3 targetDir;
	//Vector3 targetPos;

	bool ragDoll = false;
	float speed = 0;
	public float curFov = 0;
	public float curViewDis = 0;
	float alertFov = 360;
	float noticeTimer = 0;
	float bodyRemaining = 1;
	bool mentionEnemyVisible = false;
	float oldLightLevel = 0;

	public Transform useTarget;
	public Vector3 noiseDir = new Vector3();
	public float boredomLevel = 0;
	public ShipGridItem mostInteresting;
	public Vector3 leftHandPos;
	public float leftHandWeight = 0;
	public Vector3 rightHandPos;
	public float rightHandWeight = 0;

	Planner planner = new Planner();
	List<PlanAction> plan = new List<PlanAction>();
	List<PlanState> goals = new List<PlanState>();
	PlanState goal;
	public string actionName = "no action";

	public NavMeshAgent agent { get; private set; }                 // the navmesh agent required for the path finding
	public ThirdPersonCharacter character { get; private set; }     // the character we are controlling
	public Animator animator { get; private set; }
	private RagdollHelper ragdollHelper;// = GetComponent<RagdollHelper>();
	private RaptorInteraction player;

	// Use this for initialization
	void Start() {

		// get the components on the object we need ( should not be null due to require component so no need to check )
		character = GetComponent<ThirdPersonCharacter>();
		animator = GetComponent<Animator>();

		agent = GetComponentInChildren<NavMeshAgent>();
		agent.updatePosition = false;
		agent.updateRotation = false;

		ragdollHelper = GetComponent<RagdollHelper>();

		player = GameObject.FindObjectOfType<RaptorInteraction>();

		InitGoals();
		InitActions();

		goals.Sort(delegate(PlanState a, PlanState b) {
			return b.priority - a.priority;
		});
		//print("planning");
		//Find a plan
		foreach(PlanState state in goals) {
			//print(state.ToString());
		}

		//Plan();

		//print(aPassOut.input.Diff(aPassOut.input.Extract(this)));

		speed = walkSpeed;

		RagDoll(transform, false);
	}

	//Goals
	PlanState gDie, gPassOut, gWakeUp, gStand, gMoveToTarget, gUseObject, gActivateAlarm, gFlee, gInspect;
	protected void InitGoals() {
		/*gDie = new PlanState(200) {
			{"knockedOut", true}
		};
		goals.Add(gDie);*/

		gPassOut = new PlanState(100) {
			{"knockedOut", true}
		};
		goals.Add(gPassOut);

		gWakeUp = new PlanState(100) {
			{"knockedOut", false}
		};
		goals.Add(gWakeUp);

		gStand = new PlanState() {
			{"standing", true}
		};
		goals.Add(gStand);

		gMoveToTarget = new PlanState(1) {
			{"atTarget", true}
		};
		goals.Add(gMoveToTarget);

		gUseObject = new PlanState(2) {
			{"usingObject", false}
		};
		goals.Add(gUseObject);

		gActivateAlarm = new PlanState(75) {
			{"alarmActivated", true},
			{"running", true}
		};
		goals.Add(gActivateAlarm);

		gFlee = new PlanState(50) {
			{"enemyVisible", false},
			{"running", true}
		};
		goals.Add(gFlee);

		gInspect = new PlanState(1) {
			{"bored", false}
		};
		goals.Add(gInspect);

	}

	//Actions
	PlanAction aPassOut, aSleep, aWakeUp, aStand, aMoveToTarget, aWalk, aRun, aUseObject, aFindAlarm, aActivateAlarm, aFlee, aInspect, aFindInteresting;
	protected void InitActions() {
		aPassOut = new PlanAction(
			new PlanState() {
				{ "sleeping", true },
				{ "knockedOut", false }
			},
			new PlanState() { 
				{ "knockedOut", true }
			},
			delegate() {
				knockedOut = true;

				character.enabled = false;
				rigidbody.isKinematic = true;
				RagDoll(transform, true);
				GetComponent<CapsuleCollider>().enabled = false;
				animator.enabled = false;

				gameObject.GetComponent<ShipGridItem>().interestLevel = 0.001f;

				if(weapon != null) {
					weapon.Drop();
					weapon = null;
					carryingObject = false;
				}
				return false;
			});
		aPassOut.name = "pass out";
		planner.Add(aPassOut);

		aSleep = new PlanAction(
			new PlanState() {
				{ "sleeping", true },
				{ "knockedOut", true },
				{ "dead", false }
			},
			new PlanState() {
				{ "sleeping", false }
			},
			delegate() {
				sleepTime -= Time.deltaTime;
				//knockedOut = sleepTime <= 0;
				return false;
			});
		aSleep.name = "sleep";
		planner.Add(aSleep);

		aWakeUp = new PlanAction(
			new PlanState() {
				{ "sleeping", false },
				{ "knockedOut", true }
			},
			new PlanState() {
				{ "knockedOut", false }
			},
			delegate() {
				if(!animator.enabled) {
					rigidbody.isKinematic = false;
					animator.enabled = true;
					RagDoll(transform, false);
					collider.enabled = true;
					character.enabled = true;

					gameObject.GetComponent<ShipGridItem>().interestLevel = Mathf.Infinity;
				}
				else {
					animator.SetBool("GetUpFromBelly", false);
					animator.SetBool("GetUpFromBack", false);
					knockedOut = false;
				}
				return false;
			});
		aWakeUp.name = "wake up";
		planner.Add(aWakeUp);

		aWalk = new PlanAction(
			new PlanState() { 
				{ "running", true }, 
			},
			new PlanState() {
				{ "running", false }
			},
			delegate() {
				running = false;
				return false;
			});
		aWalk.name = "walk";
		planner.Add(aWalk);

		aRun = new PlanAction(
			new PlanState() { 
				{ "running", false }, 
			},
			new PlanState() {
				{ "running", true }
			},
			delegate() {
				running = true;
				return false;
			});
		aRun.name = "run";
		planner.Add(aRun);

		aStand = new PlanAction(
			new PlanState() { 
				{ "standing", false },
				{ "knockedOut", false },
				{ "sleeping", false },
				{ "running", false }
			},
			new PlanState() {
				{ "standing", true }
			},
			delegate() {
				character.Move(Vector3.zero, false, false, transform.position + transform.forward * 100);
				if(!character.moving) {
					standing = true;
				}
				return false;
			});
		aStand.name = "stand";
		planner.Add(aStand);

		aMoveToTarget = new PlanAction(
			new PlanState() {
				{ "hasTarget", true },
				{ "atTarget", false },
				{ "knockedOut", false },
				{ "sleeping", false }
			},
			new PlanState() {
				{ "atTarget", true }
			},
			delegate() {
				// update the progress if the character has made it to the previous target
				if((target.position - targetPos).magnitude > targetChangeTolerance) {
					targetPos = target.position;
					agent.SetDestination(targetPos);
				}

				// update the agents posiiton 
				agent.transform.position = transform.position;

				// use the values to move the character
				character.Move(agent.desiredVelocity.normalized * speed, false, false, targetPos);
				standing = false;

				return false;
			});
		aMoveToTarget.name = "move to target";
		planner.Add(aMoveToTarget);

		float useTimer = 0;
		Vector3 useTargetPos = Vector3.zero;
		aUseObject = new PlanAction(
			new PlanState() {
				{ "hasUseTarget", true },
				{ "usingObject", true },
				{ "atTarget", true },
				{ "standing", true },
				{ "knockedOut", false },
				{ "sleeping", false }
			},
			new PlanState() {
				{ "usingObject", false }
			},
			delegate() {
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

				return false;
			});
		aUseObject.name = "use object";
		planner.Add(aUseObject);

		aFindAlarm = new PlanAction(
			new PlanState() {
				{ "alarmFound", false },
				{ "enemyVisible", false },
				{ "enemySeen", true },
				{ "running", true },
				{ "knockedOut", false },
				{ "sleeping", false }
			},
			new PlanState() {
				{ "alarmFound", true },
				{ "hasTarget", true }
				//{ "alarmActivated", true }
			},
			delegate() {
				float minAlarmDis = Mathf.Infinity;
				Alarm minAlarm;
				Vector3 minAlarmPos = transform.position;
				minAlarm = Alarm.alarms[0];
				if(!Alarm.activated) {
					foreach(Alarm alarm in Alarm.alarms) {
						targetPos = alarm.transform.position;
						agent.SetDestination(targetPos);
						float dis = agent.remainingDistance;// (alarm.transform.position - transform.position).magnitude;
						if(dis < minAlarmDis) {
							minAlarmDis = dis;
							minAlarmPos = alarm.transform.position;
							minAlarm = alarm;
						}
					}
				}

				target = minAlarm.transform;
				alarmFound = true;

				return false;
			});
		aFindAlarm.name = "find alarm";
		planner.Add(aFindAlarm);

		aActivateAlarm = new PlanAction(
			new PlanState() {
				{ "alarmActivated", false },
				{ "hasTarget", true },
				{ "atTarget", true },
				{ "alarmFound", true },
				{ "knockedOut", false },
				{ "sleeping", false }
			},
			new PlanState() {
				{ "alarmActivated", true }
			},
			delegate() {
				usingObject = true;
				useTarget = target;
				alarmActivated = true;

				return false;
			});
		aActivateAlarm.name = "activate alarm";
		planner.Add(aActivateAlarm);

		aFlee = new PlanAction(
			new PlanState() {
				{ "healthLow", true },
				{ "enemyVisible", true },
				{ "running", true },
				{ "knockedOut", false },
				{ "sleeping", false }
			},
			new PlanState() {
				{ "enemyVisible", false }
			},
			delegate() {
				targetPos = transform.position + (transform.position - player.transform.position) * 100;
				agent.SetDestination(targetPos);

				// update the agents posiiton 
				agent.transform.position = transform.position;

				// use the values to move the character
				character.Move(agent.desiredVelocity.normalized * speed, false, false, targetPos);
				standing = false;

				return false;
			});
		aFlee.name = "flee";
		planner.Add(aFlee);

		aFindInteresting = new PlanAction(
			new PlanState() {
				{ "canInspect", true },
				{ "knockedOut", false },
				{ "sleeping", false }
			},
			new PlanState() {
				{ "atTarget", true }
			},
			delegate() {
				target = mostInteresting.transform;

				return false;
			});
		aFindInteresting.name = "find interesting";
		planner.Add(aFindInteresting);

		float lookTimer = 0;
		Vector3 lookPos = Vector3.zero;
		float inspectTimer = 0;
		aInspect = new PlanAction(
			new PlanState() {
				{ "bored", true },
				{ "canInspect", true },
				{ "atTarget", true },
				{ "knockedOut", false },
				{ "sleeping", false }
			},
			new PlanState() {
				{ "bored", false }
			},
			delegate() {
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
								bored = false;
							}
						}

						//mostInteresting.SendMessage("Use", gameObject, SendMessageOptions.DontRequireReceiver);


						lookTimer = 0;
					}
				}

				if(inspectTimer >= inspectTime) {
					inspectTimer = 0;
					mostInteresting = null;
					boredomLevel = 0;
				}

				return false;
			});
		aInspect.name = "inspect";
		planner.Add(aInspect);
	}

	// Update is called once per frame
	void Update() {
		dead = health <= 0;
		healthLow = health <= fleeHealth;
		sleeping = dead || sleepTime > 0;
		hasTarget = target != null;
		atTarget = hasTarget ? (target.position - transform.position).magnitude < targetChangeTolerance : false;
		hasUseTarget = useTarget != null;
		alarmActivated = Alarm.activated;
		bored = boredomLevel > 0;
		canInspect = mostInteresting != null && mostInteresting.interestLevel <= boredomLevel;

		curFov = Mathf.Max(fov, curFov - 1.0f * Time.deltaTime);
		curViewDis = Mathf.Max(0.0001f, viewDis * lightLevel / maxLightLevel);//Mathf.Max(viewDis, curViewDis - 1.0f * Time.deltaTime);
		if(Alarm.activated) {
			curFov = alertFov;
			//curViewDis = viewDis*2;
		}

		boredomLevel += Time.deltaTime;

		speed = running ? runSpeed : walkSpeed;

		LookForEnemy();
		CheckGrid();

		Plan();
	}

	void LookForEnemy() {
		enemyVisible = false;
		if(player != null && player.health > 0) {
			Transform enemyHead = Camera.main.transform;
			if(enemyHead != null) {
				Vector3 enemyDiff = enemyHead.position - (transform.position + new Vector3(0, 1, 0));
				Vector3 enemyDir = new Vector3();
				enemyDir.x = enemyDiff.x;
				enemyDir.y = enemyDiff.y;
				enemyDir.z = enemyDiff.z;
				enemyDiff.y = 0;
				enemyDiff.Normalize();

				if(Vector3.Dot(transform.forward, enemyDiff) >= 1.0f - (curFov / 2.0f) / 90.0f) {
					RaycastHit hit;
					if(Physics.Raycast(transform.position + new Vector3(0, 1, 0), enemyDir, out hit, curViewDis)) {
						if(hit.collider.tag == "Player" || (hit.collider.transform.parent != null && hit.collider.transform.parent.tag == "Player")) {
							noticeTimer += (1.0f - hit.distance / curViewDis) * Time.deltaTime;
							if(noticeTimer >= noticeTime) {
								enemyVisible = true;
								enemySeen = true;
								//enemyPos = enemyHead.position;
								//enemyDir = enemyHead.forward;
							}
						}
					}
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
			if(mentionEnemyVisible) {
				SoundManager.instance.Play3DSound((AudioClip)Resources.Load("Sounds/Raptor Sounds/enemies/Guard/wherediditgo"), SoundManager.SoundType.Dialogue, gameObject);
				mentionEnemyVisible = false;
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
			float newLight = cellLight != null ? cellLight.level : 0;
			lightLevel += (newLight - lightLevel) * 0.1f;
			if(oldLightLevel >= minLightLevel && lightLevel < minLightLevel) {
				SoundManager.instance.Play3DSound((AudioClip)Resources.Load("Sounds/Raptor Sounds/enemies/Guard/icantseeanything"), SoundManager.SoundType.Dialogue, gameObject);
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

	void Plan() {
		if(plan.Count > 0) {
			//Carry out plan
			PlanAction action = plan[0];
			actionName = action.name;
			//print(actionName);
			if(action.input.Diff(action.input.Extract(this)) <= 0) {
				action.Update();
				if(action.output.Diff(action.output.Extract(this)) <= 0) {
					plan.Remove(action);
				}
			}
			else {
				ClearPlan();
			}
		}
		else {
			//print("planning");
			actionName = "no action";
			//Sort list of goals by priority
			goals.Sort(delegate(PlanState a, PlanState b) {
				return b.priority - a.priority;
			});
			//print("planning");
			//Find a plan
			foreach(PlanState state in goals) {
				//print(state.priority);
				plan = planner.Plan(this, state);
				if(plan.Count > 0) {
					goal = state;
					break;
				}
			}
		}
	}

	void ClearPlan() {
		plan.Clear();
		print("cleared plan");
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
						player.eatTarget = transform;
						transform.localScale = new Vector3(bodyRemaining, bodyRemaining, bodyRemaining);
					}
					else {
						player.eatTarget = null;
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
		ClearPlan();
	}

	public void Hurt(float damage) {
		health -= damage;
	}

	public void TakeMoney(int amount) {
		money += amount;
	}

	void Animation() {
		animator.SetFloat("Health", health);
		animator.SetBool("KnockedOut", knockedOut);
	}

	void OnAnimatorIK() {
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

	void RagDoll(Transform obj, bool on) {
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
