using UnityEngine;
using System.Collections;

public class IKWalker : MonoBehaviour {
	public Transform leftTarget;
	public Transform rightTarget;
	public float strideLength = 1;
	public float speed = 0;

	Animator anim;
	float rot = 0;
	Vector3 initLeftPos;
	Vector3 initRightPos;

	// Use this for initialization
	void Start () {
		anim = GetComponent<Animator>();
		initLeftPos = leftTarget.localPosition;
		initRightPos = rightTarget.localPosition;
	}
	
	// Update is called once per frame
	void Update () {
		rot += speed;
		float lRot = rot;
		Vector3 leftPos = new Vector3(0, Mathf.Max(0, Mathf.Cos(lRot) * strideLength), Mathf.Sin(lRot) * strideLength);
		leftTarget.localPosition = initLeftPos + leftPos;

		float rRot = rot+Mathf.PI;
		Vector3 rightPos = new Vector3(0, Mathf.Max(0, Mathf.Cos(rRot) * strideLength), Mathf.Sin(rRot) * strideLength);
		rightTarget.localPosition = initRightPos + rightPos;
	}

	void OnAnimatorIK() {
		if(anim != null){
			anim.SetIKPositionWeight(AvatarIKGoal.LeftFoot, 1);
			anim.SetIKRotationWeight(AvatarIKGoal.LeftFoot, 1);

			anim.SetIKPositionWeight(AvatarIKGoal.RightFoot, 1);
			anim.SetIKRotationWeight(AvatarIKGoal.RightFoot, 1);

			if(leftTarget) {
				anim.SetIKPosition(AvatarIKGoal.LeftFoot, leftTarget.position);
				anim.SetIKRotation(AvatarIKGoal.LeftFoot, leftTarget.rotation);
			}

			if(rightTarget) {
				anim.SetIKPosition(AvatarIKGoal.RightFoot, rightTarget.position);
				anim.SetIKRotation(AvatarIKGoal.RightFoot, rightTarget.rotation);
			}
		}
	}
}
