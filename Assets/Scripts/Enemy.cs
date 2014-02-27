using UnityEngine;
using System.Collections;

[RequireComponent(typeof(ThirdPersonCharacter))]
public class Enemy : MonoBehaviour {

	public float walkSpeed = 0.25f;
	public float runSpeed = 1.0f;
	public float viewDis = 10;
	public float fov = 45;
	public float life = 100;
	public float sleep = 0;

	public ThirdPersonCharacter character { get; private set; }     // the character we are controlling
	public Transform target;										// target to aim for
	public float targetChangeTolerance = 1;				            // distance to target before target can be changed

	Vector3 targetDir;
	Vector3 targetPos;
	bool running = false;

	float curFov = 0;
	float curViewDis = 0;
	float alertFov = 360;
	float alertViewDis = 10;
	Vector3 enemyPos;
	bool enemySeen = false;

	// Use this for initialization
	void Start() {

		// get the components on the object we need ( should not be null due to require component so no need to check )
		character = GetComponent<ThirdPersonCharacter>();

		targetDir = transform.forward;

		curFov = fov;
		curViewDis = viewDis;
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
			curViewDis = alertViewDis;
		}

		Transform enemyHead = Camera.main.transform;
		if(enemyHead != null) {
			Vector3 enemyDir = enemyHead.position - transform.position;
			enemyDir.y = 0;
			enemyDir.Normalize();

			//float curFov = alertFov;//enemySeen ? alertFov : fov;
			if(Vector3.Dot(transform.forward, enemyDir) >= 1.0f - (curFov / 2.0f) / 90.0f) {
				RaycastHit hit;
				if(Physics.Raycast(transform.position + new Vector3(0, 1, 0), enemyDir, out hit, curViewDis)) {
					if(hit.collider.tag == "Player") {
						enemySeen = true;
						enemyPos = enemyHead.position;
						//targetDir += enemyDir * 5;

						curFov = alertFov;
					}
				}
			}
		}

		running = false;
		if(enemySeen) {
			running = true;
			float enemyDis = (enemyPos - transform.position).magnitude;

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

			if(enemyDis < minAlarmDis) {
				if(enemyDis <= targetChangeTolerance) {
					enemySeen = false;
				}
				else {
					targetDir += (enemyPos - transform.position).normalized * 5;
				}
			}
			else {
				if(minAlarmDis <= targetChangeTolerance) {
					//enemySeen = false;
					if(minAlarm != null) {
						minAlarm.Activate();
					}
				}
				else {
					targetDir += (minAlarmPos - transform.position).normalized * 5;
				}
			}
		}

		float speed = running ? runSpeed : walkSpeed;
		targetDir.Normalize();
		character.Move(targetDir * speed, false, false, transform.position + transform.forward * 10);
	}

	public void SetTarget(Transform target) {
		this.target = target;
	}
}
