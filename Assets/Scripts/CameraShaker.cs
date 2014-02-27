using UnityEngine;
using System.Collections;

public class CameraShaker : MonoBehaviour {

	private float decay;
	private float intensity;

	// Use this for initialization
	void Start () {
	}

	public void Shake() {

		intensity = 0.1f;
		decay = 0.005f;
		StartCoroutine("Shaking");
		SoundManager.instance.Play3DSound((AudioClip)Resources.Load("Sounds/ExplosionAndWeapons/ScreenShakeExplosion"), SoundManager.SoundType.Sfx, this.gameObject);
	}

	IEnumerator Shaking() {
		while(intensity > 0) {
			transform.position = transform.position + Random.insideUnitSphere * intensity;
			transform.rotation = new Quaternion(transform.rotation.x + Random.Range(-intensity, intensity) * 0.2f,
												 transform.rotation.y + Random.Range(-intensity, intensity) * 0.2f,
												 transform.rotation.z + Random.Range(-intensity, intensity) * 0.2f,
												 transform.rotation.w + Random.Range(-intensity, intensity) * 0.2f);
			intensity -= decay;
			yield return null;
		}
	}

	// Update is called once per frame
	/*void Update () {
		if(Input.GetKeyDown(KeyCode.T)) Shake();
	}*/
}
