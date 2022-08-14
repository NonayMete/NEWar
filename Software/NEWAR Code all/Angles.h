#pragma once
#include <stdio.h>	
#include <string>
#include <iostream>
#include <math.h>
#include "pubSysCls.h"

using namespace sFnd;

//32000 counts per rev??
// 0 degrees encoder counts
//motor 1: 7400 6.75->83.25 deg
//motor 2: 7600 4.5->85.5 deg
//motor 3: 7700 3.37->86.62 deg

#define MOTOR_COUNTS_PER_REV 32000
int motorHorizontalPositon[] = { 7400, 7600, 7700 };

//sets Motor to angle in degrees.
int setAngle(SysManager* myMgr, int motorNode, double angle, int acc=DEFAULT_ACC, int vel=DEFAULT_VEL, int portNum=0) {
	try {
		IPort& myPort = myMgr->Ports(portNum);
		INode& theNode = myPort.Nodes(motorNode);

		theNode.Motion.MoveWentDone();
		theNode.AccUnit(INode::RPM_PER_SEC);				//Set the units for Acceleration to RPM/SEC
		theNode.VelUnit(INode::RPM);						//Set the units for Velocity to RPM
		theNode.Motion.AccLimit = acc;						//Set Accel Limit (RPM)
		theNode.Motion.VelLimit = vel;						//Set Velocity Limit (RPM)

		double encMovement = (angle / 360.0) * MOTOR_COUNTS_PER_REV; //movement from 0 degrees
		int encCount = motorHorizontalPositon[motorNode]-round(encMovement);

		printf("Node: %d, Angle: %f, Curr Enc: %d, New Enc: %d\n", motorNode, angle, theNode.Motion.PosnMeasured.Value(), encCount);

		if (encCount > UPPER_ENC_LIM) printf("ERROR: Position above range, ignoring movement\n");
		if (encCount < LOWER_ENC_LIM) printf("ERROR: Position below range, ignoring movement\n");
		theNode.Motion.MovePosnStart(encCount, true);

		printf("%f\n", theNode.Motion.NodeStopDecelLim);
		//while (!theNode.Motion.MoveIsDone()) {}
		//printf("Node Angle Move Done\n");
	}
	catch(mnErr& theErr) {
		printf("ERROR\n");
		return -1;
	}
		
	
	return 0;
}