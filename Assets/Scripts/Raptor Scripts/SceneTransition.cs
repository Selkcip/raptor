using UnityEngine;
using System.Collections;

public class SceneTransition : Triggerable {
	//public Transform cameraTarget;
	public float cameraTransitionTime = 2;
	public float transitionDelay = 10;
	public string targetScene;

	Camera main;
	bool disabledStuff = false;
	Vector3 cameraStartPos;
	Quaternion cameraStartRot;
	float lerpTime = 0;
	float transitionTime = 0;
	AsyncOperation sceneLoad;
	ScreenOverlay screenOverlay;

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

				CameraFollowTopDown topDown = Camera.main.GetComponent<CameraFollowTopDown>();
				if(topDown != null) {
					topDown.enabled = false;
				}

				GameObject playerShip = GameObject.Find("PlayerShip");
				if(playerShip != null) {
					playerShip.rigidbody2D.isKinematic = true;

					PlayerShipController shipControl = playerShip.GetComponent<PlayerShipController>();
					if(shipControl != null) {
						shipControl.enabled = false;
					}
				}

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
				cameraStartPos = Camera.main.transform.position;
				cameraStartRot = Camera.main.transform.rotation;
				//Camera.main.transform.position = pos;
				//print(pos + " " + Camera.main.transform.position);
				Camera.main.transform.DeactivateChildren();

				GameObject hud = GameObject.Find("HUD");
				if(hud != null) {
					hud.SetActive(false);
				}

				GameObject player = GameObject.Find("Player");
				if(player != null) {
					RaptorInteraction raptor = player.GetComponent<RaptorInteraction>();
					if(raptor != null) {
						raptor.SellCollectibles();
					}
					player.SetActive(false);
				}

				if(targetScene != "" && targetScene != null) {
					sceneLoad = Application.LoadLevelAsync(targetScene);
					sceneLoad.allowSceneActivation = false;
				}

				Indicator[] indicators = GameObject.FindObjectsOfType<Indicator>();
				foreach(Indicator indicator in indicators) {
					Destroy(indicator);
				}

				/*screenOverlay = Camera.main.gameObject.AddComponent<ScreenOverlay>();
				screenOverlay.blendMode = ScreenOverlay.OverlayBlendMode.Multiply;
				screenOverlay.intensity = 1;
				screenOverlay.texture = overlay;*/
				screenOverlay = Camera.main.gameObject.GetComponent<ScreenOverlay>();
			}

			transitionTime += Time.deltaTime;

			float lerp = Mathf.Min(1, transitionTime / cameraTransitionTime);
			Camera.main.transform.position = Vector3.Lerp(cameraStartPos, transform.position, lerp);
			Camera.main.transform.rotation = Quaternion.Lerp(cameraStartRot, transform.rotation, lerp);

			if(screenOverlay != null) {
				screenOverlay.enabled = true;
				screenOverlay.intensity = 1 - transitionTime / transitionDelay;
			}

			if(transitionTime > transitionDelay && sceneLoad != null) {
				RaptorInteraction.level = targetScene;
				GameSaver.SaveGame("Save1");
				sceneLoad.allowSceneActivation = true;
			}
		}
	}

	void Activate(bool triggered) {

	}
}
