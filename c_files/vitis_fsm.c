#include <stdio.h>
#include "comblock.h"
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"


int main()
{
	u32 n;
	n = 11; //[001011]

	int clock, time, i, state;
	clock = 0b0;
	time = 100;
	i = 0;
	state = 0;

	cbWrite(XPAR_COMBLOCK_0_AXIL_BASEADDR, CB_OREG1, 1);
	cbWrite(XPAR_COMBLOCK_0_AXIL_BASEADDR, CB_OREG3, 1);
	cbWrite(XPAR_COMBLOCK_0_AXIL_BASEADDR, CB_OREG0, 0b0);
	cbWrite(XPAR_COMBLOCK_0_AXIL_BASEADDR, CB_OREG0, 0b1);
	cbWrite(XPAR_COMBLOCK_0_AXIL_BASEADDR, CB_OREG1, 0);
	cbWrite(XPAR_COMBLOCK_0_AXIL_BASEADDR, CB_OREG3, 0);
	cbWrite(XPAR_COMBLOCK_0_AXIL_BASEADDR, CB_OREG0, 0b0);
	cbWrite(XPAR_COMBLOCK_0_AXIL_BASEADDR, CB_OREG0, 0b1);
	cbWrite(XPAR_COMBLOCK_0_AXIL_BASEADDR, CB_OREG4, 0);
	cbWrite(XPAR_COMBLOCK_0_AXIL_BASEADDR, CB_OREG2, n);

	while ((i<=time) && (state != 4)){

		if (clock == 0b0)
		{
			clock = 0b1;
		} else {
			clock = 0b0;
		}
		cbWrite(XPAR_COMBLOCK_0_AXIL_BASEADDR, CB_OREG0, clock);

		xil_printf("\n---> TIME = %U \n", i);
		xil_printf("a_out    : %U \n", cbRead(XPAR_COMBLOCK_0_AXIL_BASEADDR, CB_IREG0));
		xil_printf("ack_out  : %U \n", cbRead(XPAR_COMBLOCK_0_AXIL_BASEADDR, CB_IREG1)&1);
		xil_printf("next_out : %U \n", cbRead(XPAR_COMBLOCK_0_AXIL_BASEADDR, CB_IREG2)&1);
		xil_printf("out_state: %U \n", cbRead(XPAR_COMBLOCK_0_AXIL_BASEADDR, CB_IREG3));
		state = cbRead(XPAR_COMBLOCK_0_AXIL_BASEADDR, CB_IREG3);
		i = i+1;
	}

    cleanup_platform();
    return 0;
}