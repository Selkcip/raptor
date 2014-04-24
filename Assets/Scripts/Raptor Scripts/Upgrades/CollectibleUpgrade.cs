using UnityEngine;
using System.Collections;

public class CollectibleUpgrade : Collectible {

	// Use this for initialization
	void Start () {
		droppable = false;
		keyCard = false;
		value = 1;
	}
	
	// Update is called once per frame
	void Update () {
	
	}

	public void Use(GameObject user) {
		user.SendMessage("Collect", this, SendMessageOptions.DontRequireReceiver);
	}

	public virtual void Apply(RaptorInteraction player) {
		print("Make the upgrade do stuff.");
	}
}
