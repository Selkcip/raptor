using UnityEngine;
using System.Collections;

public class DoorLock : MonoBehaviour {
	public RaptorDoor door;
	public float radius = 0.25f;
	public int sides = 12;
	public float sliceOffset = 0.1f;
	public float zOff = 0;
	public Material openMat;
	public Material closedMat;

	MeshFilter mf;
	Mesh mesh;
	MeshRenderer mr;

	// Use this for initialization
	void Start () {
		mf = GetComponent<MeshFilter>();
		mesh = new Mesh();
		mesh.subMeshCount = Mathf.Max(1, door.keyCardsToUnlock);
		mf.mesh = mesh;
		mr = GetComponent<MeshRenderer>();
		mr.materials = new Material[mesh.subMeshCount];

		int sliceSubdivisions = Mathf.Max(1, Mathf.CeilToInt((float)sides/mesh.subMeshCount));

		int vertPerSlice = sliceSubdivisions*3;
		int vertCount = mesh.subMeshCount*vertPerSlice;
		Vector3[] verts = new Vector3[vertCount];
		Vector3[] norms = new Vector3[vertCount];
		Vector2[] uvs = new Vector2[vertCount];

		int[] tris = new int[vertCount];

		sliceOffset *= mesh.subMeshCount > 1 ? 1 : 0;
		float angPerSlice = 2*Mathf.PI/mesh.subMeshCount;
		float sliceAng = -angPerSlice/2;
		float xOff = Mathf.Cos(sliceAng) * sliceOffset;
		float yOff = Mathf.Sin(sliceAng) * sliceOffset;

		float angPerSub = 2*Mathf.PI/(mesh.subMeshCount*sliceSubdivisions);
		float ang = angPerSub;
		for(int v = 0; v < vertCount; v++) {
			if(v % vertPerSlice == 0) {
				sliceAng += angPerSlice;
				xOff = Mathf.Cos(sliceAng) * sliceOffset;
				yOff = Mathf.Sin(sliceAng) * sliceOffset;
			}
			if(v % 3 == 0) {
				verts[v] = new Vector3(xOff, yOff, zOff);
				ang -= angPerSub;
			}
			else {
				float x = xOff+Mathf.Cos(ang) * radius;
				float y = yOff+Mathf.Sin(ang) * radius;
				float z = zOff;
				verts[v] = new Vector3(x, y, z);
				ang += angPerSub;
			}
			norms[v] = transform.forward;
			uvs[v] = new Vector2(0, 0);
			//tris[v] = v;
		}

		mesh.vertices = verts;
		mesh.normals = norms;
		mesh.uv = uvs;
		//mesh.triangles = tris;

		for(int m = 0; m < mesh.subMeshCount; m++) {
			int[] mTri = new int[vertPerSlice];
			for(int t = 0; t < vertPerSlice; t++) {
				mTri[t] = m * vertPerSlice + t;
			}
			mesh.SetTriangles(mTri, m);
		}
	}
	
	// Update is called once per frame
	void Update () {
		Material[] mats = mr.materials;
		for(int m = 0; m < mats.Length; m++) {
			mats[m] = closedMat;
			if(!door.isLocked || door.keysUsed-1 >= m) {
				mats[m] = openMat;
			}
		}
		mr.materials = mats;
	}
}
