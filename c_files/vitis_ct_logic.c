#include <stdio.h>
#include "comblock.h"
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"


int main()
{
	u32 n;
	u32 m[5] = {1, 2, 3, 4, 5};
    init_platform();
    xil_printf("10-QUEENS PROBLEM:\n");
    n = 11; //[001011]
    //n = 20; //[010100]
    cbWrite(XPAR_COMBLOCK_0_AXIL_BASEADDR, CB_OREG1, n);
    for (int i = 0; i < 5; i++)
    {
        cbWrite(XPAR_COMBLOCK_0_AXIL_BASEADDR, CB_OREG0, 1);
        cbWrite(XPAR_COMBLOCK_0_AXIL_BASEADDR, CB_OREG2, m[i]);
        cbWrite(XPAR_COMBLOCK_0_AXIL_BASEADDR, CB_OREG0, 0);
        while (!(cbRead(XPAR_COMBLOCK_0_AXIL_BASEADDR, CB_IREG0)&1)){};
        xil_printf("Candidate: %U. Valid: %U\n", m[i], cbRead(XPAR_COMBLOCK_0_AXIL_BASEADDR, CB_IREG1));
    }
    cleanup_platform();
    return 0;
}