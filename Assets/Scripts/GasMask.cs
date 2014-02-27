using UnityEngine;
using System.Collections;
using Holoville.HOTween; 

public class GasMask : EquipableObject {

	public bool isEquipped = false;
	public float timer = 60;

	void Start () {
	
	}
	
	// Update is called once per frame
	public override void Update () {
		if(isEquipped) {
			//animate pick up
			StartCoroutine("MaskTimer");
		}
	}

	IEnumerator MaskTimer() {
		isEquipped = false;
		/*foreach(Transform child in transform) {
			if(child.renderer != null) {
				child.renderer.enabled = false;
			}
		}*/
		rigidbody.isKinematic = true;
		collider.enabled = false;
		GameObject.Find("Player").GetComponent<PlayerInteraction>().hitObject = null;
		GameObject.Find("Player").GetComponent<PlayerInteraction>().wearing = true;

		yield return new WaitForSeconds(timer);

		GameObject.Find("Player").GetComponent<PlayerInteraction>().wearing = false;

		/*foreach(Transform child in transform) {
			if(child.renderer != null) {
				child.renderer.enabled = true;
			}
		}*/
		rigidbody.isKinematic = false;
		rigidbody.AddForce(Camera.main.ViewportToScreenPoint(new Vector3(0,0,1.25f))*1.25f,ForceMode.Impulse);
		collider.enabled = true;
		transform.parent = null;

		gameObject.tag = "carry";
		//animate drop
	}

	public override void Action() {
		isEquipped = true;
		transform.parent = Camera.main.transform;
		//For the 4:3 casuals HOTween.To(transform, 1.0f, new TweenParms().Prop("localPosition", new Vector3(0f,-0.25f,0.25f), false)); 
		HOTween.To(transform, 1.0f, new TweenParms().Prop("localPosition", new Vector3(0f,-0.40f,0.3f), false));
		HOTween.To(transform, 0.5f, new TweenParms().Prop("localRotation", new Vector3(0f,180f,0f), false));
		//transform.position = transform.position + new Vector3(0f, 1f, 0f);
	}

	public override void Equip(Transform Tran) {
		transform.parent = Tran;
		transform.localPosition = new Vector3(0.6986818f, -0.4490072f, 0.9410844f);
		transform.localRotation = Quaternion.Euler(new Vector3(6.265102f, 168.7135f, 97.3195f));
	}

}
