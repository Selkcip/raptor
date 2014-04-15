using UnityEngine;
using System.Collections;

public class Guard : PlanningNPC {

	public float punchDamage = 0.5f;
	public float punchDistance = 2;
	public float punchCoolDown = 1;

	public bool playerDead = false;
	public bool nearEnemy = false;
	public bool facingEnemy = false;
	public bool canPunch = false;
	public bool canShoot = false;

	protected float punchTime = 0;
	protected Vector3 patrolPos;

	// Use this for initialization
	public override void Start () {
		base.Start();
	}

	protected PlanGoal gKillPlayer;
	public override void InitGoals() {
		base.InitGoals();

		gKillPlayer = new PlanGoal(
			"kill player",
			new PlanState() {
				{"playerDead", false}
			},
			new PlanState() {
				{"playerDead", true}
			},
			25);
		goals.Add(gKillPlayer);
	}

	PlanAction aFindPlayer, aChasePlayer, aPunchPlayer, aCoolPunch, aShootPlayer, aPatrol, aFacePlayer;
	public override void InitActions() {
		base.InitActions();

		aFindPlayer = new PlanAction(
			new PlanState() {
				{ "enemySeen", true },
				{ "enemyVisible", false },
				{ "running", true },
				{ "knockedOut", false },
				{ "dead", false }
			},
			new PlanState() {
				{ "playerVisible", true }
			},
			delegate() {
				Vector3 moveDir = enemyPos-transform.position;
				if(moveDir.magnitude > targetChangeTolerance) {
					Move(moveDir, enemyPos);
				}
				else {
					enemySeen = false;
				}

				return false;
			});
		aFindPlayer.name = "find player";
		//planner.Add(aFindPlayer);

		aChasePlayer = new PlanAction(
			new PlanState() {
				{ "enemySeen", true },
				//{ "enemyVisible", false },
				{ "nearEnemy", false },
				{ "running", true },
				{ "knockedOut", false },
				{ "dead", false }
			},
			new PlanState() {
				//{ "atTarget", true },
				{ "enemyVisible", true },
				{ "nearEnemy", true }
			},
			delegate() {
				//target = player.transform;

				agent.SetDestination(enemyPos);

				// update the agents posiiton 
				agent.transform.position = transform.position;

				if((enemyPos-transform.position).magnitude <= targetChangeTolerance){
					enemySeen = false;
				}

				// use the values to move the character
				Move(agent.desiredVelocity, enemyPos);

				return false;
			});
		aChasePlayer.name = "chase player";
		planner.Add(aChasePlayer);

		aPunchPlayer = new PlanAction(
			new PlanState() {
				{ "enemySeen", true },
				{ "enemyVisible", true },
				{ "nearEnemy", true },
				{ "facingEnemy", true },
				{ "standing", true },
				{ "canPunch", true },
				{ "knockedOut", false },
				{ "dead", false }
			},
			new PlanState() {
				{ "playerDead", true }
			},
			delegate() {
				player.Hurt(new Damage(punchDamage, transform.position));
				punchTime = punchCoolDown;

				return false;
			});
		aPunchPlayer.name = "punch player";
		planner.Add(aPunchPlayer);

		aCoolPunch = new PlanAction(
			new PlanState() {
				{ "canPunch", false },
				{ "knockedOut", false },
				{ "dead", false }
			},
			new PlanState() {
				{ "canPunch", true }
			},
			delegate() {
				punchTime -= Time.deltaTime;

				return false;
			});
		aCoolPunch.name = "cool punch";
		planner.Add(aCoolPunch);

		aFacePlayer = new PlanAction(
			new PlanState() {
				{ "enemySeen", true },
				{ "enemyVisible", true },
				//{ "standing", true },
				{ "facingEnemy", false },
				{ "knockedOut", false },
				{ "dead", false }
			},
			new PlanState() {
				{ "facingEnemy", true }
			},
			delegate() {
				Vector3 targetDir = (enemyPos - transform.position).normalized;

				Move(Vector3.zero, enemyPos);

				//facingEnemy = Vector3.Dot(targetDir, transform.forward) >= 0.9f;

				return false;
			});
		aFacePlayer.name = "face player";
		planner.Add(aFacePlayer);

		aShootPlayer = new PlanAction(
			new PlanState() {
				{ "enemySeen", true },
				{ "enemyVisible", true },
				{ "nearEnemy", false },
				{ "facingEnemy", true },
				{ "canShoot", true },
				{ "standing", true },
				{ "knockedOut", false },
				{ "dead", false }
			},
			new PlanState() {
				{ "playerDead", true }
			},
			delegate() {
				Vector3 targetDir = (enemyPos - transform.position).normalized;

				Move(Vector3.zero, enemyPos);

				if(weapon != null) {
					weapon.transform.LookAt(enemyPos);
					return weapon.Use(gameObject);
				}

				if(!weapon.hasAmmo) {
					weapon.transform.localRotation = Quaternion.identity;
				}

				return false;
			});
		aShootPlayer.name = "shoot player";
		planner.Add(aShootPlayer);

		float patrolTimer = 0;
		aPatrol = new PlanAction(
			new PlanState() {
				{ "enemySeen", false },
				{ "enemyVisible", false },
				{ "curious", false },
				{ "alarmed", false },
				{ "canInspect", false },
				{ "running", false },
				{ "knockedOut", false },
				{ "dead", false }
			},
			new PlanState() {
				{ "enemySeen", true }
			},
			delegate() {
				patrolTimer += Time.deltaTime;

				agent.SetDestination(patrolPos);

				// update the agents posiiton 
				agent.transform.position = transform.position;

				NavMeshHit hit;
				agent.Raycast(transform.position+transform.forward, out hit);

				if(hit.hit || patrolTimer >= patrolTime || (patrolPos - transform.position).magnitude <= targetChangeTolerance) {
					patrolPos = transform.position + transform.forward * 10;
					patrolTimer = 0;
				}

				// use the values to move the character
				Move(agent.desiredVelocity);

				return false;
			});
		aPatrol.name = "patrol";
		planner.Add(aPatrol);
	}
	
	// Update is called once per frame
	public override void Update () {
		//Set bools and stuff up here
		playerDead = player.health <= 0;
		canPunch = punchTime <= 0;
		nearEnemy = (enemyPos - transform.position).magnitude <= punchDistance;
		Vector3 enemyDiff = enemyPos - transform.position;
		enemyDiff.y *= 0;
		facingEnemy = Vector3.Dot(enemyDiff.normalized, transform.forward) >= 0.9f;
		canShoot = weapon != null && weapon.hasAmmo;

		//This should be last in most cases
		base.Update();
	}
}
