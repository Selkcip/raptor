using UnityEngine;
using System.Collections;

public class Indicator : MonoBehaviour {
	public Texture2D texture;
	public Vector2 scale = new Vector2(1,1);
	public float rotation = 0;
	public Color tint = Color.white;
	public float lifeTime = 1;
	public bool dontDestroy = true;
	public Transform target;
	public Vector3 pos;

	float life = 0;
	Vector3 dir;
	float rot = 0;

	public static Indicator New(Texture2D texture, Vector3 pos) {
		Indicator indicator = Camera.main.gameObject.AddComponent<Indicator>();
		indicator.texture = texture;
		indicator.pos = pos;
		return indicator;
	}

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		if(!dontDestroy) {
			life += Time.deltaTime;
			tint.a = 1 - life / lifeTime;
			if(life >= lifeTime) {
				Destroy(this);
			}
		}

		if(target != null) {
			pos = target.position;
		}

		dir = (pos - transform.position).normalized;
		dir = transform.InverseTransformDirection(dir);
		//Debug.DrawRay(transform.position, dir, Color.yellow);
		dir = Vector3.Cross(Vector3.forward, dir);
		//Debug.DrawRay(transform.position, dir, Color.blue);
		dir = Vector3.Cross(Vector3.forward, dir);
		//Debug.DrawRay(transform.position, dir, Color.magenta);
		rot = Mathf.Rad2Deg * Mathf.Atan2(dir.y, -dir.x);// +90;// +rotation;
	}

	void OnGUI() {
		GUI.color = tint;

		float width = texture.width * scale.x;
		float height = texture.height * scale.y;

		Vector2 screenCenter = new Vector2(Screen.width / 2, Screen.height / 2);
		float x = screenCenter.x - width/2;
		float y = screenCenter.y - height/2;
		GUIUtility.RotateAroundPivot(rot, screenCenter);
		GUI.DrawTexture(new Rect(x, y, width, height), texture);
	}
}
