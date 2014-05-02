using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Holoville.HOTween;

public class SecurityCamera : MonoBehaviour {

	//Looking things
	public float fov = 45f;
	public float viewDis = 10f;
	public float noticeTime = 2;
	public float notorietyToSpawn = 10000;

	float curFov = 0;
	float curViewDis = 0;
	float alertFov = 180f;
	float alertViewDis = 10;
	Vector3 enemyDiff;
	Vector3 enemyPos;
	Vector3 enemyDir;
	public float noticeTimer = 0;
	public bool enemyVisible = false;
	bool mentionEnemyVisible = false;
	public bool enemySeen = false;

	//Tweening things
	private bool tweening = false;
	public RaptorInteraction player;
	private Vector3 startingRotation;

	private float rotationRange = 45f;//if you change this, you have to change the handle's rotation
	public bool canRotate = true;

	// Use this for initialization
	void Start() {
		if(RaptorInteraction.notoriety < notorietyToSpawn) Destroy(gameObject);

		player = GameObject.FindObjectOfType<RaptorInteraction>();
		startingRotation = transform.localEulerAngles;

		curFov = fov;
		curViewDis = viewDis;
	}

	// Update is called once per frame
	void Update() {
		//searching
		if(!enemyVisible && !tweening && canRotate) {
			tweening = true;
			ResetSearch();
		}
		else if(enemyVisible) {
			if(canRotate) {
				HOTween.Kill(transform);
				tweening = false;
				transform.LookAt(player.transform.position);
			}
			Alarm.ActivateAlarms();
		}

		curFov = Mathf.Max(fov, curFov - 1.0f * Time.deltaTime);
		curViewDis = 10f;//Mathf.Max(0.0001f, viewDis * lightLevel / maxLightLevel);//Mathf.Max(viewDis, curViewDis - 1.0f * Time.deltaTime);
		if(Alarm.activated) {
			curFov = alertFov;
			//curViewDis = viewDis*2;
		}

		LookForEnemy();
		LookForDeadBodies();

		Debug.DrawRay(transform.position, transform.forward, Color.magenta);
	}

	void LookForEnemy() {
		enemyVisible = false;
		//RaptorInteraction player = GameObject.Find("Player").GetComponent<RaptorInteraction>();
		if(player != null && player.health > 0) {
			Transform enemyHead = Camera.main.transform;
			if(enemyHead != null) {
				enemyDiff = enemyHead.position - transform.position;
				enemyDir.x = enemyDiff.x;
				enemyDir.y = enemyDiff.y;
				enemyDir.z = enemyDiff.z;
				enemyDiff.Normalize();

				if(Vector3.Dot(transform.forward, enemyDiff) >= 1.0f - (curFov / 2.0f) / 90.0f) {
					RaycastHit hit;
					if(Physics.Raycast(transform.position, enemyDir, out hit, curViewDis)) {
						if(hit.collider.tag == "Player" || (hit.collider.transform.parent != null && hit.collider.transform.parent.tag == "Player")) {
							noticeTimer += (1.0f - hit.distance / curViewDis) * Time.deltaTime;
							if(noticeTimer >= noticeTime) {
								enemyVisible = true;
								enemySeen = true;
								enemyPos = enemyHead.position;
							}
						}
						else if(noticeTimer > 0) {
							noticeTimer -= Time.deltaTime;
							if(noticeTimer < 0) {
								noticeTimer = 0;
							}
						}
					}
				}
			}
		}
		//Replace this stuff with camera sounds
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

	void LookForDeadBodies() {
		RaycastHit hit;
		Physics.Raycast(transform.position, transform.forward, out hit, curViewDis);
		Debug.DrawLine(transform.position, hit.point);
		List<ShipGridCell> region = ShipGrid.GetRegionI(new Bounds(hit.point, new Vector3(2,2,2)));
		foreach(ShipGridCell cell in region) {
			foreach(ShipGridItem item in cell.contents) {
				if(item != null) {
					PlanningNPC npc = item.GetComponent<PlanningNPC>();
					if(npc != null) {
						if(npc.dead) {
							Alarm.ActivateAlarms();
						}
					}
				}
			}
		}
	}

	void ResetSearch() {
		if(enemyVisible) {
			tweening = false;
			return;
		}
		noticeTimer = 0f;
		HOTween.To(transform, 5.0f, new TweenParms().Prop("localRotation", startingRotation, false).OnComplete(SearchRight));
	}

	void SearchRight() {
		if(enemyVisible) {
			tweening = false;
			return;
		}
		HOTween.To(transform, 5.0f, new TweenParms().Prop("localRotation", new Vector3(0f, rotationRange, 0f), true).OnComplete(SearchLeft));
	}

	void SearchLeft() {
		if(enemyVisible) {
			tweening = false;
			return;
		}
		HOTween.To(transform, 5.0f, new TweenParms().Prop("localRotation", new Vector3(0f, -rotationRange, 0f), true).OnComplete(SearchRight));
	}
}

