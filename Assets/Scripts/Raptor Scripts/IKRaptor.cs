using UnityEngine;
using System.Collections;

public class IKRaptor : MonoBehaviour {
	public Transform rig;
	public Transform handL;
	public Transform handR;
	public Transform footL;
	public Transform footR;
	public float strideLength = 0.25f;
	float strafeStrideLength;
	public float armSwingLength = 0.1f;
	public float armSwingSpeed = 0.5f;
	public float speedScale = 0.25f;
	public Vector3 speed;
	public float slashSpeed = 1;
	public float slashSize = 1;
	public float useTime = 0.25f;

	public bool isMoving, isJumping, isPouncing, isClinging, isSlashing, isUsing, isEating, isHacking, isCrouching;
	public Vector3 clingNormal;

	Animator anim;
	bool setCling = false;
	Vector3 walkRot = new Vector3();
	Vector3 initHandL, initHandR, initFootL, initFootR, initRigPos;
	Vector3 clingHandL, clingHandR, clingFootL, clingFootR, clingHandEulers;
	Quaternion initHandLRot, initHandRRot, initFootLRot, initFootRRot, clingRot, initRigRot;

	Vector3 slashPos;
	Transform slashTarget;
	float slashRot = 0;
	int slashArm;

	Transform useTarget;
	Vector3 usePos;
	float useRot = 0;
	bool used = false;
	int useArm = 0;

	// Use this for initialization
	void Start () {
		strafeStrideLength = strideLength * 0.5f;

		anim = GetComponent<Animator>();

		initRigPos = rig.localPosition;
		initRigRot = rig.rotation;

		initHandL = handL.localPosition;
		initHandLRot = handL.localRotation;
		initHandR = handR.localPosition;
		initHandRRot = handR.localRotation;
		initFootL = footL.localPosition;
		initFootLRot = footL.localRotation;
		initFootR = footR.localPosition;
		initFootRRot = footR.localRotation;
	}

	void SetIKTarget(AvatarIKGoal goal, Transform target, float posWeight = 1, float rotWeight = 1) {
		if(anim != null) {
			anim.SetIKPositionWeight(goal, posWeight);
			anim.SetIKRotationWeight(goal, rotWeight);

			if(target) {
				anim.SetIKPosition(goal, target.position);
				anim.SetIKRotation(goal, target.rotation);
			}
		}
	}

	void OnAnimatorIK() {
		if(anim != null) {
			SetIKTarget(AvatarIKGoal.LeftHand, handL);
			SetIKTarget(AvatarIKGoal.RightHand, handR);

			SetIKTarget(AvatarIKGoal.LeftFoot, footL);
			SetIKTarget(AvatarIKGoal.RightFoot, footR);
		}
	}

	public void Slash(Vector3 pos, Transform target) {
		if(!isSlashing) {
			isSlashing = true;
			slashPos = transform.InverseTransformPoint(pos);
			slashTarget = target;
			slashRot = 0;
			slashArm = Random.Range(0, 3);
			if(slashArm == 0 || slashArm == 1) {
				SoundManager.instance.Play2DSound((AudioClip)Resources.Load("Sounds/Raptor Sounds/raptor/slash1"), SoundManager.SoundType.Sfx);
			}
			else {
				SoundManager.instance.Play2DSound((AudioClip)Resources.Load("Sounds/Raptor Sounds/raptor/slash2"), SoundManager.SoundType.Sfx);
			}
		}
	}

	public void UseObject(Vector3 pos, Transform target) {
		if(!isUsing) {
			isUsing = true;
			useTarget = target;
			usePos = transform.InverseTransformPoint(pos);
			useRot = 0;
			used = false;
			useArm = Random.Range(0, 2);
		}
	}

	public void Hack(Transform target) {

	}

	void Update() {
		anim.SetBool("isCrouching", isCrouching);
	}
	
	// Update is called once per frame
	void LateUpdate () {
		walkRot += speed * speedScale;// transform.InverseTransformPoint(rigidbody.velocity);
		//rot.x *= 2;
		Vector3 lRot = walkRot;
		lRot.x *= 2;
		Vector3 rRot = lRot + Vector3.one * Mathf.PI;

		handL.localRotation = initHandLRot;
		handR.localRotation = initHandRRot;
		footL.localRotation = initFootLRot;
		footR.localRotation = initFootRRot;

		if(isClinging) {
			if(!setCling){
				setCling = true;

				clingHandL = transform.TransformPoint(initHandL) + Vector3.up - clingNormal * 0.4f;
				clingHandR = transform.TransformPoint(initHandR) + Vector3.up - clingNormal * 0.4f;

				clingFootL = transform.TransformPoint(new Vector3(initFootL.x, 0, 2));
				clingFootR = transform.TransformPoint(new Vector3(initFootR.x, 0, 2));

				clingRot = Quaternion.LookRotation(-clingNormal);

				float xz = Mathf.Sqrt(clingNormal.x * clingNormal.x + clingNormal.z * clingNormal.z);
				float clingAng = Mathf.Atan2(xz, clingNormal.y) * Mathf.Rad2Deg;

				clingHandEulers.x = Mathf.Max(-90, Mathf.Min(90, clingHandEulers.x-clingAng));
			}

			handL.localEulerAngles = clingHandEulers;
			handR.localEulerAngles = clingHandEulers;

			handL.position = clingHandL;
			handR.position = clingHandR;

			footL.localPosition = new Vector3(initFootL.x, -0.5f, 1);
			footL.localEulerAngles = new Vector3(45, 0, 0);
			footR.localPosition = new Vector3(initFootR.x, -0.5f, 1);
			footR.localEulerAngles = footL.localEulerAngles;
		}
		else {
			setCling = false;
			if(isPouncing) {
				//Vector3 footCenter = new Vector3(0,1,1);
				footL.localPosition = new Vector3(initFootL.x, -0.5f, 1);
				footL.localEulerAngles = new Vector3(45, 0, 0);
				footR.localPosition = new Vector3(initFootR.x, -0.5f, 1);
				footR.localEulerAngles = footL.localEulerAngles;
			}
			else if(isJumping) {
				footL.localPosition = new Vector3(initFootL.x, -1, 0.5f);
				footL.localEulerAngles = new Vector3(90, 0, 0);
				footR.localPosition = new Vector3(initFootR.x, -1, 0.5f);
				footR.localEulerAngles = footL.localEulerAngles;
			}
			else if(isMoving) {
				float scaleX = Mathf.Abs(speed.x) > 0 ? 1 : 0;
				float scaleZ = Mathf.Abs(speed.z) > 0 ? 1 : 0;
				float scaleY = scaleZ;// Mathf.Max(scaleX, scaleZ);

				footL.localPosition = initFootL + new Vector3(scaleX * Mathf.Sin(lRot.x) * strafeStrideLength, scaleY * Mathf.Max(0, Mathf.Cos(lRot.z) * strideLength), scaleZ * Mathf.Sin(lRot.z) * strideLength);
				footR.localPosition = initFootR + new Vector3(scaleX * Mathf.Sin(rRot.x) * strafeStrideLength, scaleY * Mathf.Max(0, Mathf.Cos(rRot.z) * strideLength), scaleZ * Mathf.Sin(rRot.z) * strideLength);

				lRot *= armSwingSpeed;
				rRot *= armSwingSpeed;
				handL.localPosition = initHandL + new Vector3(Mathf.Sin(rRot.x) * armSwingLength, Mathf.Cos(rRot.z) * armSwingLength, Mathf.Sin(rRot.z) * armSwingLength);
				handR.localPosition = initHandR + new Vector3(Mathf.Sin(lRot.x) * armSwingLength, Mathf.Cos(lRot.z) * armSwingLength, Mathf.Sin(lRot.z) * armSwingLength);
			}
			else {
				handL.localPosition = initHandL + new Vector3(0, Mathf.Cos(rRot.z) * armSwingLength * 0.25f, 0);
				handR.localPosition = initHandR + new Vector3(0, Mathf.Cos(lRot.z) * armSwingLength * 0.25f, 0);

				footL.localPosition = Vector3.Lerp(footL.localPosition, initFootL, 0.5f);
				footR.localPosition = Vector3.Lerp(footR.localPosition, initFootR, 0.5f);
			}

			float PI2 = Mathf.PI;
			if(isSlashing) {
				slashRot += PI2* Time.deltaTime / slashSpeed;

				float posRot = slashRot;
				float rotRot = slashRot;
				float sin = Mathf.Sin(posRot);
				float handRot = (Mathf.Atan2(slashPos.z, slashPos.y)*Mathf.Rad2Deg)-90;
				Vector3 locaPos = new Vector3();
				if(slashArm == 0 || slashArm == 2) {
					Vector3 diff = slashPos - initHandL;
					Vector3 up = Vector3.Cross(diff, Vector3.right).normalized;
					Vector3 left = Vector3.Cross(diff, up).normalized;
					locaPos = initHandL + diff * sin + left * Mathf.Sin(posRot * 2) * slashSize + up * Mathf.Sin(posRot * 2) * slashSize;
					handL.localPosition = locaPos;
					handL.localEulerAngles = new Vector3(handRot - (Mathf.Sin(rotRot) * 45), 0, (Mathf.Sin(rotRot) * 45));
				}

				if(slashArm == 1 || slashArm == 2) {
					Vector3 diff = slashPos - initHandR;
					Vector3 up = Vector3.Cross(diff, Vector3.right).normalized;
					Vector3 left = -Vector3.Cross(diff, up).normalized;
					locaPos = initHandR + diff * sin + left * Mathf.Sin(posRot * 2) * slashSize + up * Mathf.Sin(posRot * 2) * slashSize;
					handR.localPosition = locaPos;
					handR.localEulerAngles = new Vector3(handRot - (Mathf.Sin(rotRot) * 45), 0, 0);
				}

				if(slashRot > PI2) {
					isSlashing = false;
					handL.localPosition = initHandL;
					handL.localEulerAngles = new Vector3(0, 0, 0);

					handR.localPosition = initHandR;
					handR.localEulerAngles = new Vector3(0, 0, 0);
				}
			}
			else if(isHacking) {

			}
			else if(isEating) {

			}
			else if(isUsing) {
				if(useTarget != null) {
					useRot += 2 * Mathf.PI * Time.deltaTime / useTime;
					useRot = Mathf.Min(2 * Mathf.PI, useRot);
					float sin = Mathf.Sin(useRot);
					//Vector3 usePos = transform.InverseTransformPoint(useTarget.position + Vector3.up*2);
					if(useArm == 0) {
						handR.localPosition = Vector3.Lerp(initHandR, usePos, sin);
					}
					else {
						handL.localPosition = Vector3.Lerp(initHandL, usePos, sin);
					}

					if(!used && useRot >= Mathf.PI) {
						useTarget.SendMessageUpwards("Use", gameObject, SendMessageOptions.DontRequireReceiver);
						used = true;
					}
					else if(useRot >= 2 * Mathf.PI) {
						isUsing = false;
					}
				}
				else {
					handL.localPosition = Vector3.Lerp(handL.localPosition, initHandL, 0.1f);
					handR.localPosition = Vector3.Lerp(handR.localPosition, initHandR, 0.1f);
				}
			}
		}
	}
}
