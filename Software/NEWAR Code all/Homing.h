#pragma once
//Required include files
#include <stdio.h>	
#include <string>
#include <iostream>
#include "pubSysCls.h"	


#define TIME_TILL_TIMEOUT	10000	//The timeout used for homing(ms)

using namespace sFnd;
// Send message and wait for newline

void msgUser(const char* msg) {
	std::cout << msg;
	getchar();
}

int findPorts(SysManager* myMgr) {
	std::vector<std::string> comHubPorts;
	SysManager::FindComHubPorts(comHubPorts);
	printf("Found %d SC Hubs\n", comHubPorts.size());
	size_t portCount = 0;
	for (portCount = 0; portCount < comHubPorts.size() && portCount < NET_CONTROLLER_MAX; portCount++) {
		myMgr->ComHubPort(portCount, comHubPorts[portCount].c_str()); 	//define the first SC Hub port (port 0) to be associated 
										// with COM portnum (as seen in device manager)
	}
	if (portCount < 0) {
		printf("Unable to locate SC hub port\n");
		msgUser("Press any key to continue."); //pause so the user can see the error message; waits for user to press a keys
		return -1;  //This terminates the main program
	}
	if (portCount > 1) {
		printf("Too Many Hubs?\n");
		msgUser("Press any key to continue."); //pause so the user can see the error message; waits for user to press a keys
		return -1;  //This terminates the main program
	}
	return portCount;
}

int homeNodes(SysManager* myMgr, int port, bool rehomeNode=true) {
	IPort& myPort = myMgr->Ports(port);
	printf(" Port[%d]: state=%d, nodes=%d\n",
		myPort.NetNumber(), myPort.OpenState(), myPort.NodeCount());
	for (size_t iNode = 0; iNode < myPort.NodeCount(); iNode++) {
		// Create a shortcut reference for a node
		INode& theNode = myPort.Nodes(iNode);
		theNode.EnableReq(false);				//Ensure Node is disabled before loading config file
		myMgr->Delay(200);

		printf("   Node[%d]: type=%d\n", int(iNode), theNode.Info.NodeType());
		printf("            userID: %s\n", theNode.Info.UserID.Value());
		printf("        FW version: %s\n", theNode.Info.FirmwareVersion.Value());
		printf("          Serial #: %d\n", theNode.Info.SerialNumber.Value());
		printf("             Model: %s\n", theNode.Info.Model.Value());

		//The following statements will attempt to enable the node.  First,
		// any shutdowns or NodeStops are cleared, finally the node is enabled
		theNode.Status.AlertsClear();	//Clear Alerts on node 
		theNode.Motion.NodeStopClear();	//Clear Nodestops on Node  				
		theNode.EnableReq(true);					//Enable node 
		printf("Node \t%zi enabled\n", iNode);
		double timeout = myMgr->TimeStampMsec() + TIME_TILL_TIMEOUT;	//define a timeout in case the node is unable to enable
																	//This will loop checking on the Real time values of the node's Ready status
		while (!theNode.Motion.IsReady()) {
			if (myMgr->TimeStampMsec() > timeout) {
				printf("Error: Timed out waiting for Node %d to enable\n", iNode);
				msgUser("Press any key to continue."); //pause so the user can see the error message; waits for user to press a key
				return -2;
			}
		}
		//At this point the Node is enabled, and we will now check to see if the Node has been homed
		//Check the Node to see if it has already been homed, 
		if (theNode.Motion.Homing.HomingValid()) {
			if (theNode.Motion.Homing.WasHomed()) {
				printf("Node %d has already been homed, current position is: \t%8.0f \n", iNode, theNode.Motion.PosnMeasured.Value());
				if (!rehomeNode) return 0;
				printf("Rehoming Node... \n");
			}
			else {
				printf("Node [%d] has not been homed.  Homing Node now...\n", iNode);
			}
			//Now we will home the Node
			theNode.Motion.Homing.Initiate();

			timeout = myMgr->TimeStampMsec() + TIME_TILL_TIMEOUT;	//define a timeout in case the node is unable to enable
																	// Basic mode - Poll until disabled
			while (!theNode.Motion.Homing.WasHomed()) {
				if (myMgr->TimeStampMsec() > timeout) {
					printf("Node did not complete homing:  \n\t -Ensure Homing settings have been defined through ClearView. \n\t -Check for alerts/Shutdowns \n\t -Ensure timeout is longer than the longest possible homing move.\n");
					msgUser("Press any key to continue."); //pause so the user can see the error message; waits for user to press a key
					return -2;
				}
			}
			printf("Node completed homing\n");
		}
		else {
			printf("Node[%d] has not had homing setup through ClearView.  The node will not be homed.\n", iNode);
			msgUser("Press any key to continue.");
			return -2;
		}
	}
	return 0;
}