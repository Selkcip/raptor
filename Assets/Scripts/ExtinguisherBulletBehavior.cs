using UnityEngine;
using System.Collections;
using Holoville.HOTween;

public class ExtinguisherBulletBehavior : MonoBehaviour {

	int counter = 0;

	// Use this for initialization
	void Start () {
		Sequence newSeq = new Sequence(new SequenceParms().OnComplete(DeleteObject));
		newSeq.Insert(0f, HOTween.To(transform, 3f, "localScale", new Vector3(0.2f, 0.2f, 0.2f), true));
		newSeq.Insert(7.0f, HOTween.To(transform, 5.0f, "localScale", new Vector3(0f, 0f, 0f)));
		newSeq.Play();
	}

	void DeleteObject() {
		Destroy(gameObject);
	}

	void OnTriggerEnter(Collider other) {
		if(other.gameObject.tag == "Fire") {
			if(other.gameObject.GetComponent<Fire>() != null && other.gameObject.GetComponent<Fire>().onFire) {
				other.gameObject.GetComponent<Fire>().health -= 1;
			}
		}
	}

	void OnCollisionEnter(Collision other) {
		rigidbody.isKinematic = true;
		if(other.gameObject.tag == "pipeLeak") {
			//other.gameObject.GetComponent<PipeEmitters>().DisableLeak(other.gameObject.GetComponent<ExplosionPipe>().index);
			//other.gameObject.GetComponent<ExplosionPipe>().Seal();
		}
		this.audio.Play();

	}
}
