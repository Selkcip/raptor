using UnityEngine;
using System.Collections;

public class DockTrigger : TaggedTriggerable {
	public string targetScene;

	SceneTransition transition;

	void OnTriggerEnter2D(Collider2D other) {
		if(tags.Count <= 0 || tags.Contains(other.tag) || (other.transform.parent != null && tags.Contains(other.transform.parent.tag))) {
			transition = GameObject.FindObjectOfType<SceneTransition>();
			transition.targetScene = targetScene;
			transition.triggerList.Add(this);

			other.transform.parent = transform;

			isTriggered = true;
		}
	}
}
