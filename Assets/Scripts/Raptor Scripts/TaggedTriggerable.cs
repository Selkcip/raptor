using UnityEngine;
using System.Collections;
using System.Collections.Generic;

/*[System.Serializable]
public class Tag {
	public string name = "tag";
	public bool selected = false;

	public Tag(string name) {
		this.name = name;
	}
}

[CustomEditor(typeof(Tag))]
public class TagEditor : Editor {
}

[ExecuteInEditMode()]*/
public class TaggedTriggerable : Triggerable {
	//public List<Tag> tags;
	public List<string> tags = new List<string>();

	// Use this for initialization
	void Start () {
		/*if(Application.isEditor) {
			tags = new List<Tag>();
			foreach(string tag in UnityEditorInternal.InternalEditorUtility.tags) {
				tags.Add(new Tag(tag));
			}
		}*/
	}

	void OnTriggerEnter(Collider other) {
		if(tags.Count <= 0 || tags.Contains(other.tag) || (other.transform.parent != null && tags.Contains(other.transform.parent.tag))) {
			isTriggered = true;
		}
	}
}
