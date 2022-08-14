/*
 * CIN source file 
 */

#include <stddef.h>
#include "extcode.h"

#include <pmacu.h>

/*
 * typedefs
 */

typedef struct {
	int32 dimSize;
	LStrHandle I_Var_Value[1];
	} TD1;
typedef TD1 **TD1Hdl;

CIN MgErr CINRun(int32 *Device_Number_i32_0_, int32 *Starting_IVar_i32, int32 *Ending_IVar_i32, LStrHandle I_Var_Buffer_String, TD1Hdl I_Var_Value_Array_String);

CIN MgErr CINRun(int32 *Device_Number_i32_0_, int32 *Starting_IVar_i32, int32 *Ending_IVar_i32, LStrHandle I_Var_Buffer_String, TD1Hdl I_Var_Value_Array_String) {

	/* ENTER YOUR CODE HERE */

	char CmdString[256];
	char RespBuffer[256];
	char LongBuffer[64000];
	char *pBuff = LongBuffer;
	int32 NewSize;

	int i;

	for (i = *Starting_IVar_i32; i < *Ending_IVar_i32; i++) {

		sprintf(CmdString, "I%d", i);
		PmacGetResponseA(*Device_Number_i32_0_, RespBuffer, 256, CmdString);

		sprintf(CmdString, "I%d = %s\n", i, RespBuffer);

		strcpy(pBuff, CmdString);
		pBuff += strlen(CmdString);
	}

	NewSize = pBuff - LongBuffer;
	NumericArrayResize(uB, 1L, (UHandle *) &I_Var_Buffer_String, NewSize);
	LStrLen(*I_Var_Buffer_String) = NewSize;

	memcpy(LStrBuf(*I_Var_Buffer_String), LongBuffer, NewSize);

	return noErr;
}
