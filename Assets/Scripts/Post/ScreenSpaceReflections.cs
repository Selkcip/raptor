using UnityEngine;

[ExecuteInEditMode]
[AddComponentMenu("Image Effects/Rendering/SSR")]
public class ScreenSpaceReflections : ImageEffectBase {
	public float reflectDistance;
	public int m_Downsampling = 2;
	public float m_Blur = 2;
	public Material mat;

	// Called by camera to apply image effect
	void OnRenderImage (RenderTexture source, RenderTexture destination) {
		camera.depthTextureMode = DepthTextureMode.DepthNormals;
		//material.SetTexture("_RampTex", textureRamp);

		m_Downsampling = Mathf.Max(1, m_Downsampling);
		RenderTexture rtRef = RenderTexture.GetTemporary(source.width / m_Downsampling, source.height / m_Downsampling, 0);

		Vector4 normal = new Vector4(1, 1, 1, 0);
		//normal = camera.worldToCameraMatrix.MultiplyVector(normal);
		mat.SetMatrix("UnProj", (camera.projectionMatrix*camera.worldToCameraMatrix).inverse);
		mat.SetMatrix("Proj", (camera.projectionMatrix * camera.worldToCameraMatrix));
		mat.SetMatrix("CamToWorld", (camera.cameraToWorldMatrix));
		mat.SetFloat("RefDis", reflectDistance);
		Graphics.Blit(source, rtRef, mat, 0);

		m_Blur = Mathf.Max(0, m_Blur);

		// Blur SSAO horizontally
		RenderTexture rtBlurX = RenderTexture.GetTemporary(source.width, source.height, 0);
		mat.SetVector("_TexelOffsetScale",
			new Vector4((float)m_Blur / source.width, 0, 0, 0));
		mat.SetTexture("_SSAO", rtRef);
		Graphics.Blit(null, rtBlurX, mat, 1);
		RenderTexture.ReleaseTemporary(rtRef); // original rtAO not needed anymore

		// Blur SSAO vertically
		RenderTexture rtBlurY = RenderTexture.GetTemporary(source.width, source.height, 0);
		mat.SetVector("_TexelOffsetScale",
			new Vector4(0, (float)m_Blur / source.height, 0, 0));
		mat.SetTexture("_SSAO", rtBlurX);
		Graphics.Blit(source, rtBlurY, mat, 1);
		RenderTexture.ReleaseTemporary(rtBlurX); // blurX RT not needed anymore

		rtRef = rtBlurY; // AO is the blurred one now

		mat.SetTexture("_REF", rtRef);
		Graphics.Blit(source, destination, mat, 2);
		RenderTexture.ReleaseTemporary(rtRef);
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