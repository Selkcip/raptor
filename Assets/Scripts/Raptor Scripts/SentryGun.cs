using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Holoville.HOTween;

public class SentryGun : MonoBehaviour {

	//Looking things
	public float fov = 45f;
	public float viewDis = 10f;
	public float noticeTime = 2;

	float curFov = 0;
	float curViewDis = 0;
	float alertFov = 180f;
	float alertViewDis = 10;
	Vector3 enemyDiff;
	Vector3 enemyPos;
	Vector3 enemyDir;
	float noticeTimer = 0;
	public bool enemyVisible = false;
	bool mentionEnemyVisible = false;
	public bool enemySeen = false;

	//Tweening things
	private bool tweening = false;
	private Transform player;

	public float rotationRange = 90f;

	//Shooting things
	public float fireRate = 0.25f;
	public Transform leftMuzzle;
	public Transform rightMuzzle;
	public GameObject projectile;

	private float fireCoolDown = 0;

	// Use this for initialization
	void Start () {
		player = GameObject.Find("Player").transform;

		curFov = fov;
		curViewDis = viewDis;
	}
	
	// Update is called once per frame
	void Update () {
		//searching
		if (!enemyVisible && !tweening){
			tweening = true;
			ResetSearch();
		}
		else if(enemyVisible) {
			HOTween.Kill(transform);
			tweening = false;
			transform.LookAt(new Vector3(player.position.x, transform.position.y, player.position.z));
			Shoot();
		}

		curFov = Mathf.Max(fov, curFov - 1.0f * Time.deltaTime);
		curViewDis = 10f;//Mathf.Max(0.0001f, viewDis * lightLevel / maxLightLevel);//Mathf.Max(viewDis, curViewDis - 1.0f * Time.deltaTime);
		if(Alarm.activated) {
			curFov = alertFov;
			//curViewDis = viewDis*2;
		}

		LookForEnemy();
		fireCoolDown = Mathf.Max(0, fireCoolDown - Time.deltaTime);

		Debug.DrawRay(transform.position, transform.forward, Color.magenta);
	}

	void LookForEnemy() {
		enemyVisible = false;
		RaptorInteraction player = GameObject.Find("Player").GetComponent<RaptorInteraction>();
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
		//Replace this stuff with sentry sounds
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

	void ResetSearch() {
		if(enemyVisible) {
			tweening = false;
			return;
		}
		noticeTimer = 0f;
		HOTween.To(transform, 5.0f, new TweenParms().Prop("rotation", new Vector3(0f, 0f, 0f), false).OnComplete(SearchRight));
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

	void Shoot() {
		if(fireCoolDown <= 0) {
			fireCoolDown = fireRate;
			if(leftMuzzle != null && rightMuzzle != null && projectile != null) {
				Instantiate(projectile, leftMuzzle.position, leftMuzzle.rotation);
				Instantiate(projectile, rightMuzzle.position, rightMuzzle.rotation);
			}
		}
	}
}
