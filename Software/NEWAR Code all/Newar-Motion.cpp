//Required include files
#include <stdio.h>	
#include <string>
#include <iostream>
#include <chrono>
#include <ctime>

//ClearPath SDK
#include "pubSysCls.h"

#define UPPER_ENC_LIM		8000
#define LOWER_ENC_LIM		0

#define ACC_LIM_RPM_PER_SEC	2000
#define DEFAULT_ACC			200

#define VEL_LIM_RPM			500
#define DEFAULT_VEL			50

#define DEFAULT_DELAY		100


#include "Homing.h"
#include "Angles.h"
#include "Parsing.h"

int main(int argc, char* argv[]) {
	if (argc < 2) {
		printf("No Input File Given\n");
		return -1;
	}
	//msgUser("Motion Example starting. Press Enter to continue.");
	SysManager* myMgr = SysManager::Instance();							//Create System Manager myMgr

	try {

		if (findPorts(myMgr) != 1) {
			printf("No ClearPath Found, is control-box/motors on and usb plugged in?\n");
			return -1;
		}

		myMgr->PortsOpen(1); //Open the port

		if (homeNodes(myMgr, 0, true) != 0) {
			printf("Some kind of error occured when homing, are all motors enabled and on?\n");
			return -1;
		}

		IPort& myPort = myMgr->Ports(0);

		printf(" Port[%d]: state=%d, nodes=%d\n",
			myPort.NetNumber(), myPort.OpenState(), myPort.NodeCount());

		///////////////////////////////////////////////////////////////////////////////////////

		//Loop through angle file
		printf("about to parse file\n");
		vector<vector<string>> content = parseFile(argv[1], true);
		unsigned int accel = DEFAULT_ACC;
		unsigned int vel = DEFAULT_VEL;
		unsigned int delay = DEFAULT_DELAY;
		printf("done parsing file\n");


		auto start = std::chrono::system_clock::now();

		for (int i = 0; i < content.size(); i++) { //loop through each line in file
			auto current = std::chrono::system_clock::now();
			std::chrono::duration<double> elapsed_current = current - start;
			printf("Running Line: %d (", i);
			for (int j = 0; j < content[i].size(); j++) {
				printf("%s,", content[i][j]);
			}
			printf(") Time: %f\n", elapsed_current.count());
	
			if (content[i].size() < 3) continue; //incorrect line, skip
		
			
			if (content[i].size() > 3) accel = stoi(content[i][3]);
			if (accel > ACC_LIM_RPM_PER_SEC) accel = ACC_LIM_RPM_PER_SEC;
			if (content[i].size() > 4) vel = stoi(content[i][4]);
			if (vel > VEL_LIM_RPM) vel = VEL_LIM_RPM;
			if (content[i].size() > 5) delay = stoi(content[i][5]);

			setAngle(myMgr, 0, stod(content[i][0]), accel, vel);
			setAngle(myMgr, 1, stod(content[i][1]), accel, vel);
			setAngle(myMgr, 2, stod(content[i][2]), accel, vel);
			
			while (!myPort.Nodes(0).Motion.MoveIsDone() 
				|| !myPort.Nodes(1).Motion.MoveIsDone() 
				|| !myPort.Nodes(2).Motion.MoveIsDone()) {
				myMgr->Delay(1);
			}
			

			auto end = std::chrono::system_clock::now();
			std::chrono::duration<double> elapsed_seconds = end - start;

			if (elapsed_seconds.count() * 1000 < delay) {
				myMgr->Delay(delay-(1000*elapsed_seconds.count()));
			}
		}

		//////////////////////////////////////////////////////////////////////////////////////
		printf("Disabling nodes, and closing port\n");
		for (size_t iNode = 0; iNode < myPort.NodeCount(); iNode++) { //Disable Nodes
			myPort.Nodes(iNode).EnableReq(false);
		}
	}
	catch (mnErr& theErr)
	{
		printf("Failed to disable Nodes n\n");
		//This statement will print the address of the error, the error code (defined by the mnErr class), 
		//as well as the corresponding error message.
		printf("Caught error: addr=%d, err=0x%08x\nmsg=%s\n", theErr.TheAddr, theErr.ErrorCode, theErr.ErrorMsg);
		msgUser("Press any key to continue."); //pause so the user can see the error message; waits for user to press a key
		return 0;  //This terminates the main program
	}

	// Close down the ports
	myMgr->PortsClose();
	//msgUser("Press any key to continue."); //pause so the user can see the error message; waits for user to press a key
	return 0;			//End program
}

