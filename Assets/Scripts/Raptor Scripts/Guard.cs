using UnityEngine;
using System.Collections;

public class Guard : PlanningNPC {

	public float punchDamage = 5;
	public float punchDistance = 2;
	public float punchCoolDown = 1;

	public bool playerDead = false;
	protected PlanCondition cPlayerDead;
	public bool nearEnemy = false;
	protected PlanCondition cNearEnemy;
	public bool facingEnemy = false;
	protected PlanCondition cFacingEnemy;
	public bool canPunch = false;
	protected PlanCondition cCanPunch;
	public bool canShoot = false;
	protected PlanCondition cCanShoot;

	protected float punchTime = 0;
	protected Vector3 patrolPos;

	// Use this for initialization
	public override void Start () {
		base.Start();
	}

	public override void InitConds() {
		base.InitConds();
		cPlayerDead = delegate() { return playerDead; };
		cNearEnemy = delegate() { return nearEnemy; };
		cFacingEnemy = delegate() { return facingEnemy; };
		cCanPunch = delegate() { return canPunch; };
		cCanShoot = delegate() { return canShoot; };
	}

	protected PlanGoal gKillPlayer;
	public override void InitGoals() {
		base.InitGoals();

		gKillPlayer = new PlanGoal(
			"kill player",
			new PlanState() {
				{cPlayerDead, false}
			},
			new PlanState() {
				{cPlayerDead, true}
			},
			25);
		goals.Add(gKillPlayer);
	}

	PlanAction aFindPlayer, aChasePlayer, aPunchPlayer, aCoolPunch, aShootPlayer, aPatrol, aFacePlayer;
	public override void InitActions() {
		base.InitActions();

		aChasePlayer = new PlanAction(
			new PlanState() {
				{ cEnemySeen, true },
				//{ cEnemyVisible, false },
				{ cNearEnemy, false },
				{ cRunning, true },
				{ cKnockedOut, false },
				{ cDead, false }
			},
			new PlanState() {
				//{ "atTarget", true },
				{ cEnemyVisible, true },
				{ cNearEnemy, true }
			},
			delegate() {
				//target = player.transform;

				agent.SetDestination(enemyPos);

				// update the agents posiiton 
				agent.transform.position = transform.position;

				//print(agent.remainingDistance);

				if(agent.remainingDistance <= targetChangeTolerance || agent.pathStatus == NavMeshPathStatus.PathPartial) {
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
				{ cEnemySeen, true },
				{ cEnemyVisible, true },
				{ cNearEnemy, true },
				{ cFacingEnemy, true },
				//{ cStanding, true },
				{ cCanPunch, true },
				{ cKnockedOut, false },
				{ cDead, false }
			},
			new PlanState() {
				{ cPlayerDead, true }
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
				{ cCanPunch, false },
				{ cKnockedOut, false },
				{ cDead, false }
			},
			new PlanState() {
				{ cCanPunch, true }
			},
			delegate() {
				punchTime -= Time.deltaTime;

				return false;
			});
		aCoolPunch.name = "cool punch";
		planner.Add(aCoolPunch);

		aFacePlayer = new PlanAction(
			new PlanState() {
				//{ cEnemySeen, true },
				{ cEnemyVisible, true },
				//{ cStanding, true },
				{ cFacingEnemy, false },
				{ cKnockedOut, false },
				{ cDead, false }
			},
			new PlanState() {
				{ cFacingEnemy, true },
				{ cEnemySeen, true }
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
				{ cEnemySeen, true },
				{ cEnemyVisible, true },
				{ cNearEnemy, false },
				{ cFacingEnemy, true },
				{ cCanShoot, true },
				{ cStanding, true },
				{ cKnockedOut, false },
				{ cDead, false }
			},
			new PlanState() {
				{ cPlayerDead, true }
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

		//Make wander into partol
		aWander.name = "patrol";
		aWander.output.Clear();
		aWander.output = new PlanState() {
			{ cEnemySeen, true }
		};

		/*float patrolTimer = 0;
		aPatrol = new PlanAction(
			new PlanState() {
				{ cEnemySeen, false },
				{ cEnemyVisible, false },
				{ "curious", false },
				{ "alarmed", false },
				{ "canInspect", false },
				{ "alertShip", false },
				{ cRunning, false },
				{ cKnockedOut, false },
				{ cDead, false }
			},
			new PlanState() {
				{ cEnemySeen, true }
			},
			delegate() {
				patrolTimer += Time.deltaTime;

				agent.SetDestination(patrolPos);

				// update the agents posiiton 
				agent.transform.position = transform.position;

				NavMeshHit hit;
				agent.Raycast(transform.position+transform.forward, out hit);

				if(hit.hit || patrolTimer >= patrolTime || agent.remainingDistance <= targetChangeTolerance || agent.pathStatus == NavMeshPathStatus.PathPartial) {
					//Vector3 randomDir = Random.insideUnitSphere * 10;
					//NavMesh.SamplePosition(transform.position + randomDir, out hit, 10, 1);
					//patrolPos = hit.position;// transform.position + transform.forward * 10;
					patrolPos = transform.position + transform.forward * 10;
					patrolTimer = 0;
				}

				// use the values to move the character
				Move(agent.desiredVelocity);

				return false;
			});
		aPatrol.name = "patrol";
		planner.Add(aPatrol);*/
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
