using UnityEngine;
using System.Collections;

public class Guard : PlanningNPC {

	public float punchDamage = 5;
	public float punchDistance = 2;
	public float punchCoolDown = 1;

	public bool playerDead = false;
	public bool nearEnemy = false;
	public bool facingEnemy = false;
	public bool canPunch = false;
	public bool canShoot = false;

	protected float punchTime = 0;
	protected Vector3 patrolPos;

	protected State chasePlayer, facePlayer, punchPlayer, shootPlayer;
	public override void InitStates() {
		base.InitStates();

		chasePlayer = new State(
			delegate() {
				return enemySeen && !nearEnemy;
			},
			delegate() {
				actionName = "Chase Player";

				running = true;

				agent.SetDestination(enemyPos);
				// update the agents posiiton 
				agent.transform.position = transform.position;

				if(agent.remainingDistance <= targetChangeTolerance || agent.pathStatus == NavMeshPathStatus.PathPartial) {
					return true;
				}

				// use the values to move the character
				Move(agent.desiredVelocity, enemyPos);

				return false;
			}
		);

		facePlayer = new State(
			delegate() {
				return enemyVisible && !facingEnemy;
			},
			delegate() {
				actionName = "Face Player";

				Move(Vector3.zero, enemyPos);

				return facingEnemy;
			}
		);

		punchPlayer = new State(
			delegate() {
				return enemySeen && enemyVisible && facingEnemy && nearEnemy;
			},
			delegate() {
				actionName = "Punch Player";

				if(punchTime <= 0) {
					player.Hurt(new Damage(punchDamage, transform.position));
					punchTime = punchCoolDown;
				}
				else {
					punchTime -= Time.deltaTime;
				}

				return true;
			}
		);

		shootPlayer = new State(
			delegate() {
				return enemySeen && enemyVisible && facingEnemy && !nearEnemy && canShoot;
			},
			delegate() {
				actionName = "Shoot Player";

				Vector3 targetDir = (enemyPos - transform.position).normalized;

				Move(Vector3.zero, enemyPos);

				if(weapon != null) {
					weapon.transform.LookAt(enemyPos);
					return weapon.Use(gameObject);
				}

				if(!weapon.hasAmmo) {
					weapon.transform.localRotation = Quaternion.identity;
				}

				return true;
			}
		);

		punchPlayer.priority = 87;
		shootPlayer.priority = 86;
		chasePlayer.priority = 85;
		facePlayer.priority = 84;

		states.Add(chasePlayer);
		states.Add(facePlayer);
		states.Add(punchPlayer);
		states.Add(shootPlayer);
	}
	
	// Update is called once per frame
	public override void Update () {
		//Set bools and stuff up here
		playerDead = player.health <= 0;
		canPunch = punchTime <= 0;
		enemyPos = enemyVisible ? Camera.main.transform.position : enemyPos;
		nearEnemy = (enemyPos - transform.position).magnitude <= punchDistance;
		Vector3 enemyDiff = enemyPos - transform.position;
		enemyDiff.y *= 0;
		Debug.DrawRay(transform.position + Vector3.up, enemyDiff);
		facingEnemy = Vector3.Dot(enemyDiff.normalized, transform.forward) >= 0.9f;
		canShoot = weapon != null && weapon.hasAmmo;

		//This should be last in most cases
		base.Update();
	}
}
