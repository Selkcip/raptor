// /* ------------------
//       ${Name} 
//       (c)3Radical 2012
//           by Mike Talbot 
//     ------------------- */
// 
using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;
using System.Linq;
using Serialization;

[AddComponentMenu("Storage/Rooms/Room")]
[DontStore]
public class SaveRoom : MonoBehaviour
{
	public static SaveRoom Current;
	
	void Awake()
	{
		Current = this;
	}
	
	public void Save()
	{
		RoomManager.SaveCurrentRoom();
	}
	
	
}


