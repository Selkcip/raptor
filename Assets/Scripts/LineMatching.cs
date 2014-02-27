using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Holoville.HOTween;

public class LineMatching : Incident {

	public bool start = false;
	public int numParts = 3;
	public int numColors = 4;
	public float rotationAngle = 90f;
	public float rotationTime = 0.5f;
	public float lineThickness = 25f;//Larger the number, thinner the lines
	public int numberOfLines = 3;//How many lines need to be solved
	public int timeToSolve = 30;

	public Transform cylinderPart;
	public GameObject lineBase;
	public List<Transform> cylinderParts = new List<Transform>();
	public List<bool> cylinderMoving = new List<bool>();

	private const int MAX_COLORS = 4;
	//private float threshold = 250;

	public List<Color> colorList = new List<Color>();//{Color.red, Color.blue, Color.green, Color.yellow };
	public List<string> colorNameList = new List<string>();//{Color.red, Color.blue, Color.green, Color.yellow };

	List<List<int>> solutionList = new List<List<int>>();

	public List<int> linesToSolve = new List<int>();

	private List<Vector3> rotationList = new List<Vector3>();

	public void Start() {
		if (start)
			Activate();
	}

	// Use this for initialization
	public override void Activate() {
		colorList.Add(Color.red);
		colorNameList.Add("red");
		colorList.Add(Color.blue);
		colorNameList.Add("blue");
		colorList.Add(Color.green);
		colorNameList.Add("green");
		colorList.Add(Color.yellow);
		colorNameList.Add("yellow");
        // initialize the cylinder parts
		for(int i = 0; i < numParts; i++) {
			Transform newPart = Instantiate(cylinderPart,
				gameObject.transform.position + Vector3.Scale(transform.up, new Vector3(i * cylinderPart.renderer.bounds.size.y, i * cylinderPart.renderer.bounds.size.y, i * cylinderPart.renderer.bounds.size.y)), 
				gameObject.transform.rotation) as Transform;
			newPart.parent = gameObject.transform;
			cylinderParts.Add(newPart);
			cylinderMoving.Add(false);
		}

		//decides which lines the player has to solve
		DetermineLines();

		for (int j = 0; j < numColors; j++){ // colors
			List<int> solution = new List<int>();

            // check if this color's solution is different from the others
            bool isDifferentSolution = false;
            while (!isDifferentSolution) {
                // randomly rotate the cylinder to get a new solution
                for (int i = 0; i < numParts; i++) { // each cylinder slice
                    RandomlyRotate(i);
                    solution.Add((int)cylinderParts[i].eulerAngles.y);
                }

                if (solutionList.Count == 0)
                    isDifferentSolution = true;
                foreach (List<int> otherSolution in solutionList) {
                    for (int i = 0; i < 360 / (int)rotationAngle; i++) {
                    bool isSame = true;
                        List<int> temp = solution;
                        for (int n = 0; n < temp.Count; n++) {
                            temp[n] -= (int)90f;
                            if (temp[n] < 0)
                                temp[n] += 360;
                            if (temp[n] != otherSolution[n]) {
                                isSame = false;
                            }
                        }

                        if (isSame) { // if the new solution is the same as the other solution
                            // clear solution and form a new one
                            solution.Clear();
                            isDifferentSolution = false;
                            break;
                        }
                        else
                            isDifferentSolution = true;
                    }
                    if (!isDifferentSolution)
                            break;
                }
            }
            solutionList.Add(solution);

			//creates the "lines" for each color
			for(int i = 0; i < numParts; i++) { // each cylinder slice
				GameObject cube = (GameObject)GameObject.Instantiate(lineBase); ;//GameObject.CreatePrimitive(PrimitiveType.Cube);
				cube.transform.position = cylinderParts[i].transform.position + Vector3.Scale(transform.right, new Vector3(0.5f * cylinderParts[i].localScale.x, 0.5f * cylinderParts[i].localScale.x, 0.5f * cylinderParts[i].localScale.x));

				cube.transform.localScale = new Vector3(cylinderPart.renderer.bounds.size.x / cube.transform.renderer.bounds.size.x / lineThickness, 
					cylinderPart.renderer.bounds.size.y / cube.transform.renderer.bounds.size.y,
					cylinderPart.renderer.bounds.size.z / cube.transform.renderer.bounds.size.z / lineThickness);

				cube.transform.rotation = transform.rotation;

				cube.transform.RotateAround(cylinderParts[i].position, cylinderParts[i].up, j * rotationAngle / numColors);
				cube.transform.parent = cylinderParts[i];

				cube.renderer.material.color = colorList[j];

				if(i == 0) {
					rotationList.Add(cylinderParts[i].transform.rotation.eulerAngles);
					print(cylinderParts[i].transform.rotation.eulerAngles);
				}
				RandomlyRotate(i);
			}
		}

		//Create the top of the cylinder based on the bottom part
		Transform top = Instantiate(cylinderParts[0],
										gameObject.transform.position + Vector3.Scale(transform.up, new Vector3(cylinderParts.Count * cylinderPart.renderer.bounds.size.y, cylinderParts.Count * cylinderPart.renderer.bounds.size.y, cylinderParts.Count * cylinderPart.renderer.bounds.size.y)),
										cylinderParts[0].rotation) as Transform;
		top.parent = cylinderParts[0];

		//line to solve is always in front
		cylinderParts[0].eulerAngles = rotationList[linesToSolve[0]];
	}

	// Update is called once per frame
	public override void Update() {
		/*string input = Input.inputString;
		switch(input) {
			case "1":
				rotate(1);
				rotate(3);
				break;

			case "2":
				rotate(2);
				rotate(3);
				break;

			case "3":
				rotateBackwards(1);
				rotate(2);
				break;

			case "0":
				checkPuzzle();
				break;

			case "6":
				Reset();
				break;*/
			/* Debug stuff
			case "R":
				print("RED: " + (int)solutionList[0][0] + ", " +
					(int)solutionList[0][1] + ", " +
					(int)solutionList[0][2]);
				break;

			case "Y":
				print("YELLOW: " + (int)solutionList[3][0] + ", " +
					(int)solutionList[3][1] + ", " +
					(int)solutionList[3][2]);
				break;

			case "B":
				print("BLUE: " + (int)solutionList[1][0] + ", " +
					(int)solutionList[1][1] + ", " +
					(int)solutionList[1][2]);
				break;

			case "G":
				print("GREEN: " + (int)solutionList[2][0] + ", " +
					(int)solutionList[2][1] + ", " +
					(int)solutionList[2][2]);
				break;
			

			case "9":
				print("CURRENT: " + (int)cylinderParts[0].eulerAngles.y + ", " +
					(int)cylinderParts[1].eulerAngles.y + ", " +
					(int)cylinderParts[2].eulerAngles.y);
				if (linesToSolve.Count > 0)
					print("Solve: " + linesToSolve[0]);	
				break;
		}*/
	}

	public void rotate(int index) {
		if(!cylinderMoving[index]) {
			HOTween.To(cylinderParts[index], rotationTime, new TweenParms().Prop("localRotation", new Vector3(0f, rotationAngle, 0f), true).OnComplete(Completed, index));
			cylinderMoving[index] = true;
		}
	}

	public void rotateBackwards(int index) {
		if(!cylinderMoving[index]) {
			HOTween.To(cylinderParts[index], rotationTime, new TweenParms().Prop("localRotation", new Vector3(0f, -rotationAngle, 0f), true).OnComplete(Completed, index));
			cylinderMoving[index] = true;
		}
	}

	public void checkPuzzle() {
		if(linesToSolve.Count <= 0) {
			isSolved = true;
			return;
		}

		List<int> solution = solutionList[linesToSolve[0]];
		
            int angle = (int)cylinderParts[0].eulerAngles.y - solution[0];
            if (angle < 0)
                angle += 360;

			for(int i = 1; i < solution.Count; i++) {
                int secondAngle = (int)cylinderParts[i].eulerAngles.y - solution[i];
                if (secondAngle < 0)
                    secondAngle += 360;

				if(angle == secondAngle) {
					isSolved = true;
					continue;
				}
				else {
					isSolved = false;
					break;
				}
			}

		if(isSolved){
			print("cool");
			linesToSolve.RemoveAt(0);
			if(linesToSolve.Count > 0)
				FaceForward(rotationList[linesToSolve[0]]);//cylinderParts[0].localEulerAngles = rotationList[linesToSolve[0]];
			isSolved = false;
			return;
		}

		if(!isSolved) {
			isFailed = true;
			print("fucked up");
		}
	}

	void DetermineLines() {
		for(int i = 1; i < numberOfLines; i++) {
			bool sameLines = true;

			if(linesToSolve.Count <= 0) {
				linesToSolve.Add((int)(Random.value * colorList.Count));
			}

			while(sameLines) {
				int line = (int)(Random.value * colorList.Count);

				foreach(int number in linesToSolve) {
					if(number == line) {
						sameLines = true;
						break;
					}
					sameLines = false;
				}

				if(!sameLines) {
					linesToSolve.Add(line);
					break;
				}

			}
		}
	}

	void FaceForward(Vector3 rotation) {
		if(!cylinderMoving[0]) {
			HOTween.To(cylinderParts[0], rotationTime, new TweenParms().Prop("localRotation", new Vector3(0f,rotation.y,0f), false).OnComplete(Completed, 0));
			cylinderMoving[0] = true;
		}
	}

    // randomly rotates cylinder part index
    void RandomlyRotate(int index) {
        int rotationMultiplier = (int)(Random.value * (float) numColors);
        cylinderParts[index].transform.Rotate(new Vector3(0f, rotationAngle * (float)rotationMultiplier, 0f));
    }

	void Completed(TweenEvent e) {
		cylinderMoving[(int)e.parms[0]] = false;
	}

	public override void Reset() {
		linesToSolve.Clear();
		DetermineLines();

		for(int i = 1; i < cylinderParts.Count; i++) {
			RandomlyRotate(i);
		}

		cylinderParts[0].eulerAngles = rotationList[linesToSolve[0]];
	}
}
