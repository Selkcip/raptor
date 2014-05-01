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
	public Vector3 speed;
	public float slashSpeed = 1;

	public bool isMoving, isJumping, isPouncing, isClinging, isSlashing, isUsing, isHacking, isCrouching;
	public Vector3 clingNormal;

	Animator anim;
	bool setCling = false;
	Vector3 walkRot = new Vector3();
	Vector3 initHandL, initHandR, initFootL, initFootR, initRigPos;
	Vector3 clingHandL, clingHandR, clingFootL, clingFootR, clingHandEulers;
	Quaternion clingRot, initRigRot;

	Vector3 slashPos;
	Transform slashTarget;
	float slashRot = 0;
	int slashArm;

	// Use this for initialization
	void Start () {
		strafeStrideLength = strideLength * 0.5f;

		anim = GetComponent<Animator>();

		initRigPos = rig.localPosition;
		initRigRot = rig.rotation;

		initHandL = handL.localPosition;
		initHandR = handR.localPosition;
		initFootL = footL.localPosition;
		initFootR = footR.localPosition;
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

	void Update() {
		anim.SetBool("isCrouching", isCrouching);
	}
	
	// Update is called once per frame
	void LateUpdate () {
		walkRot += speed;// transform.InverseTransformPoint(rigidbody.velocity);
		//rot.x *= 2;
		Vector3 lRot = walkRot;
		lRot.x *= 2;
		Vector3 rRot = lRot + Vector3.one * Mathf.PI;

		handL.localRotation = Quaternion.identity;
		handR.localRotation = Quaternion.identity;

		if(isClinging) {
			if(!setCling){
				setCling = true;

				clingHandL = transform.TransformPoint(initHandL) - clingNormal * 0.4f;
				clingHandR = transform.TransformPoint(initHandR) - clingNormal * 0.4f;

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
			/*footL.position = clingFootL;
			footL.rotation = clingRot;
			footR.position = clingFootR;
			footR.rotation = clingRot;*/
		}
		else {
			setCling = false;
			if(isPouncing) {
				//Vector3 footCenter = new Vector3(0,1,1);
				footL.localPosition = new Vector3(initFootL.x, 0, 2);
				footR.localPosition = new Vector3(initFootR.x, 0, 2);
			}
			else if(isJumping) {

			}
			else if(isMoving) {
				float scaleX = Mathf.Abs(speed.x) > 0 ? 1 : 0;
				float scaleZ = Mathf.Abs(speed.z) > 0 ? 1 : 0;
				float scaleY = scaleZ;// Mathf.Max(scaleX, scaleZ);

				handL.localPosition = initHandL + new Vector3(Mathf.Sin(rRot.x) * armSwingLength, Mathf.Cos(rRot.z) * armSwingLength, Mathf.Sin(rRot.z) * armSwingLength);
				handR.localPosition = initHandR + new Vector3(Mathf.Sin(lRot.x) * armSwingLength, Mathf.Cos(lRot.z) * armSwingLength, Mathf.Sin(lRot.z) * armSwingLength);

				footL.localPosition = initFootL + new Vector3(scaleX * Mathf.Sin(lRot.x) * strafeStrideLength, scaleY * Mathf.Max(0, Mathf.Cos(lRot.z) * strideLength), scaleZ * Mathf.Sin(lRot.z) * strideLength);
				footR.localPosition = initFootR + new Vector3(scaleX * Mathf.Sin(rRot.x) * strafeStrideLength, scaleY * Mathf.Max(0, Mathf.Cos(rRot.z) * strideLength), scaleZ * Mathf.Sin(rRot.z) * strideLength);
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
				if(slashArm == 0 || slashArm == 2) {
					handL.localPosition = Vector3.Lerp(initHandL, slashPos - Vector3.right * 0.25f, Mathf.Sin(posRot));
					handL.localEulerAngles = new Vector3(Mathf.Min(45, -90 + Mathf.Sin(rotRot) * 135), 0, Mathf.Min(45, -45 + Mathf.Sin(rotRot) * 135));
				}

				if(slashArm == 1 || slashArm == 2) {
					handR.localPosition = Vector3.Lerp(initHandR, slashPos + Vector3.right * 0.25f, Mathf.Sin(posRot));
					handR.localEulerAngles = new Vector3(Mathf.Min(45, -90 + Mathf.Sin(rotRot) * 135), 0, -Mathf.Min(45, -45 + Mathf.Sin(rotRot) * 135));
				}

				if(slashRot > PI2) {
					isSlashing = false;
					handL.localPosition = initHandL;
					handL.localEulerAngles = new Vector3(0, 0, 0);

					handR.localPosition = initHandR;
					handR.localEulerAngles = new Vector3(0, 0, 0);
				}
			}
			else if(isUsing) {

			}
			else if(isHacking) {

			}
		}
	}
}
