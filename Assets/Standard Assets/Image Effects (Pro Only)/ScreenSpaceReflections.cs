using UnityEngine;

[ExecuteInEditMode]
[AddComponentMenu("Image Effects/Rendering/SSR")]
public class ScreenSpaceReflections : ImageEffectBase {
	public float reflectDistance;
	public Material mat;

	// Called by camera to apply image effect
	void OnRenderImage (RenderTexture source, RenderTexture destination) {
		camera.depthTextureMode = DepthTextureMode.DepthNormals;
		//material.SetTexture("_RampTex", textureRamp);

		Vector4 normal = new Vector4(1, 1, 1, 0);
		//normal = camera.worldToCameraMatrix.MultiplyVector(normal);
		mat.SetMatrix("UnProj", (camera.projectionMatrix*camera.worldToCameraMatrix).inverse);
		mat.SetMatrix("Proj", (camera.projectionMatrix * camera.worldToCameraMatrix));
		mat.SetMatrix("CamToWorld", (camera.cameraToWorldMatrix));
		mat.SetFloat("RefDis", reflectDistance);
		Graphics.Blit(source, destination, mat);
	}

	void OnDrawGizmos() {
		//Debug.Log("hello");
		Vector3 normal = new Vector3(0, 1, 0);// camera.cameraToWorldMatrix.MultiplyVector(new Vector3(0, 0, 1));
		normal = camera.worldToCameraMatrix.MultiplyVector(normal);
		normal = camera.cameraToWorldMatrix.MultiplyVector(normal);
		//Debug.Log(normal);
		//Debug.DrawRay(new Vector3(0, 0, 0), normal);
		//Debug.DrawLine(new Vector3(0, 0, 0), new Vector3(0, 100, 0));
	}
}