using UnityEngine;
using System.Collections;

public class SceneTransition : Triggerable {
	//public Transform cameraTarget;
	public float cameraTransitionTime = 2;
	public float transitionDelay = 10;
	public string targetScene;

	Camera main;
	bool disabledStuff = false;
	float lerpTime = 0;
	float transitionTime = 0;
	AsyncOperation sceneLoad;

	// Use this for initialization
	void Start () {
		cameraTransitionTime = Mathf.Min(cameraTransitionTime, transitionDelay);
	}
	
	// Update is called once per frame
	void Update () {
		base.Update();
		if(isTriggered){
			if(!disabledStuff) {
				disabledStuff = true;
				SimpleMouseRotator rotator = Camera.main.GetComponent<SimpleMouseRotator>();
				if(rotator != null) {
					rotator.enabled = false;
				}

				Animator animator = Camera.main.GetComponent<Animator>();
				if(animator != null) {
					animator.enabled = false;
				}

				EdgeDetectEffectNormals edge = Camera.main.GetComponent<EdgeDetectEffectNormals>();
				if(edge != null) {
					edge.enabled = false;
				}

				//Vector3 pos = Camera.main.transform.position;
				Camera.main.transform.parent = null;
				//Camera.main.transform.position = pos;
				//print(pos + " " + Camera.main.transform.position);
				Camera.main.transform.DeactivateChildren();

				GameObject hud = GameObject.Find("HUD");
				if(hud != null) {
					hud.SetActive(false);
				}

				if(targetScene != "" && targetScene != null) {
					sceneLoad = Application.LoadLevelAsync(targetScene);
					sceneLoad.allowSceneActivation = false;
				}
			}

			lerpTime += Time.deltaTime/cameraTransitionTime;

			Camera.main.transform.position = Vector3.Lerp(Camera.main.transform.position, transform.position, lerpTime);
			Camera.main.transform.rotation = Quaternion.Lerp(Camera.main.transform.rotation, transform.rotation, lerpTime);

			transitionTime += Time.deltaTime;
			if(transitionTime > transitionDelay && sceneLoad != null) {
				sceneLoad.allowSceneActivation = true;
			}
		}
	}

	void Activate(bool triggered) {

	}
}
