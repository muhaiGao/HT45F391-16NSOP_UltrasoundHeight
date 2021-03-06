INCLUDE HT45F391.inc
INCLUDE MEASURE.inc
INCLUDE DEFINE.asm
INCLUDE MACRO.INC
;INCLUDE BUS.INC
INCLUDE CONFIGURE.INC
;INCLUDE	UART.INC
RAMBANK		0	RAMBANK0
RAMBANK0	.SECTION	'data'
R_TEMPERATURE_L			DB		?
R_TEMPERATURE_H			DB		?
R_TEMPERATURE_BUF_L		DB		?
R_TEMPERATURE_BUF_H		DB		?
R_RES_DISCHARGE_TIME_H		DB		?
R_RES_DISCHARGE_TIME_L		DB		?
R_NTC_DISCHARGE_TIME_H		DB		?
R_NTC_DISCHARGE_TIME_L		DB		?
R_TEMPERATURE_OFFSET		DB		?
R_CNT				DB		?
R_CNT1				DB		?
R_TEMP0				DB		?
R_TEMP1				DB		?
R_TEMP2				DB		?
R_TEMP3				DB		?
R_TEMP4				DB		?
R_TEMP5				DB		?
R_BUF_L				DB		?
R_BUF_H				DB		?
F_GET_NTC			DBIT
R_SAMPLE_10			DB		?

;user	.SECTION	at 100H 'CODE'		;0F0h 
user	.SECTION	at 1F0H 'CODE';;100H 'CODE'		;0F0h 
__INI__:
;L_INI_SENSOR:
;;1:58K   0:40K
;
;L_INI_WDT:
;	MOV	A,10101111B
;	MOV	WDTC,A
;L_INI_SCF:
;	MOV	A,00000000b
;	SET	ACC.6	
;	MOV	SCFCTL,A
;	SZ	__F_SENSOR_58K
;	SET	SCFCTL.7
;
;init_int:
;	CLR	INTC0
;	CLR	INTC1
;	CLR	INTC2
;	MOV	A,00000010b;00000001b
;	MOV	INTEDGE,A
;;;--------------------------------------------
;L_INI_IO:
;	MOV	A,00100000B
;	MOV	ACERL,A
;	CLR	PAC.2
;	SET	PA.2
;;;--------------------------------------------
;init_RAM:
;r_RAM0:
;	CLR	[04H].0
;	MOV	A,START_Addr
;	MOV	MP0,A
;RAM0_rloop:
;	CLR	WDT
;	CLR	IAR0
;	XOR	A,END_Addr_B0
;	INC	MP0
;	SNZ	Z
;	JMP	RAM0_rloop
;	CLR	MP0
;
;r_RAM1:
;	SET	[04H].0
;	MOV	A,START_Addr
;	MOV	MP1,A
;RAM1_rloop:
;	CLR	WDT
;	CLR	IAR1
;	XOR	A,END_Addr_B1
;	INC	MP1
;	SNZ	Z
;	JMP	RAM1_rloop
;	CLR	MP1
;	
;	MOVF	__R_GAIN[0],GAIN_ORIGINAL
;	MOVF	__R_GAIN[1],GAIN_1MS
;	MOVF	__R_GAIN[2],GAIN_2MS
;	MOVF	__R_GAIN[3],GAIN_3MS
;	MOVF	__R_GAIN[4],GAIN_4MS
;	MOVF	__R_GAIN[5],GAIN_5MS
;	MOVF	__R_GAIN[6],GAIN_6MS
;	MOVF	__R_GAIN[7],GAIN_7MS
;	MOVF	__R_GAIN[8],GAIN_8MS
;	MOVF	__R_GAIN[9],GAIN_9MS
;	MOVF	__R_GAIN[10],GAIN_10MS
;	MOVF	__R_DISTANCE_ADJ,DISTANCE_ADJ
;	MOVF	__R_ECHO_REFERENCE_ADJ_MAX,ECHO_REFERENCE_ADJ_MAX
;	MOVF	__R_ECHO_REFERENCE_ADJ,ECHO_REFERENCE_ADJ
;	MOVF	__R_AFTERSHOCK_TIME_ADJ,AFTERSHOCK_TIME_ADJ
;	MOVF	__R_SOUND_SPEED_H,HIGH(C_SOUND_SPEED)
;	MOVF	__R_SOUND_SPEED_L,LOW(C_SOUND_SPEED)
;;;--------------------------------------------
;;; Auto-Envelope Processing Unit SET
;;;--------------------------------------------	
;init_DVCM:
;	MOV	A,10000000B		;;80H=VDD/2
;	MOV	DVCM,A
;;;--------------------------------------------
;init_SUMCMP:
;	MOV	A,10000000B
;	MOV	SUMCMP,A
;;;;--------------------------------------------
;init_AVPCTRL:
;	SET	SAVP
;	SNZ	__F_SENSOR_58K
;	jmp	$1
;	CLR	DN
;	SET	KN
;	jmp	init_AVPCTRL_exit
;$1:
;	SET	DN
;	CLR	KN
;init_AVPCTRL_exit:
;;;--------------------------------------------
;init_ENVCMP:
;	MOV	A,10001000B		;;SUM > Comparator Value 
;	MOV	ENVCMP,A	
;init_ADC:
;	MOV	A,01101000B		;ACS3-ACS0:0000/AN0,0001/AN1,0010/AN2,0011/AN3		
;	MOV	ADCR0,A			;0100/AN4,0101/AN5,0110/AN6,1000/SCF output(MUXIN),1001/DVCM
;	MOV	A,00000000B
;	MOV	ADCR1,A
;	
;init_timer:
;	MOVF	TM0AL,90h;40h;80h
;	MOVF	TM0AH,01h;0ch
;	MOVF	TM0C1,03h
;	SET	TM0C0.3
;	SET	TA0E
;	SET	EMI
;RET 

SBR_USER_INIT:
	
;	CLR		PAC0
;	SET		PA0
;	CLR		ACE0
;	SET		PAPU0
	
	set		PAC3
	clr		ACE3
	
;	clr		pac2
;	set		PAPU2
;	CLR		pa2

	clr		ACE2
	
	set		pac6
	CLR		ACE6
	SET		PAPU6
;	set		pa6
;	set		pbc2
	;set		pbc0
	set		pac3
	
	clr		pac4
;	set		PAPU4
	SET		pa4
	clr		ACE4
	MOVF	R_SAMPLE_10,0
	
	RET
	
;;1.02ms	
SBR_INIT_TM1:
	MOVF	TM1AL,255 ;255				;255
	MOVF	TM1AH,0
;	MOVF	TM1C0,01000000B         ;内部时钟源 16/64 = 0.25M    4us +1  250*4 =1 ms 
;	MOVF	TM1C0,11000001B	
	MOVF	TM1C0,00110000B
;	MOVF	TM1C1,01101000B	
	MOVF	TM1C1,11000001B			;计数模式	32KZ    31.25us
	RET

	


SBR_GET_TEMPERATURE:
	CLR	R_TEMP0
	CLR	R_TEMP1
	CLR	R_TEMP2
	CLR	WDT
	MOVF	R_CNT1,8;2	
L_GET_TEMPERATURE_LOOP:
	CLR	R_TEMP4
	CLR	R_TEMP3
	CLR	PAC.7
	CLR	PAC.1
	CLR	ACE7
	CLR	ACE1
	SET	PA.7
	SET	PA.1
	MOVF	R_CNT,15
$0:
	CALL	__SBR_DELAY_1MS
	SDZ	R_CNT
	JMP	$0
L_START_DISCHARGE:
	SZ	F_GET_NTC
	JMP	$0
	SET	PAC.1
	CLR	PA.7
	JMP	$1
$0:
	SET	PAC.7
	CLR	PA.1
$1:
	SET	T1ON
	SNZ	F_GET_NTC
	JMP	L_DISCHARGE_NTC
	JMP	L_DISCHARGE_RES
	
L_DISCHARGE_NTC:
	CLR	WDT
	SNZ	PA.1
	JMP	L_DISCHARGE_FINISHED	
	SNZ	TA1F
	JMP	L_DISCHARGE_NTC
	CLR	TA1F
	INC	R_TEMP4
	JMP	L_DISCHARGE_NTC
	
L_DISCHARGE_RES:
	CLR	WDT
	SNZ	PA.7	;;Vol=0.1VDD , Voh=0.9VDD
	JMP	L_DISCHARGE_FINISHED	
	SNZ	TA1F
	JMP	L_DISCHARGE_RES
	CLR	TA1F
	INC	R_TEMP4
	JMP	L_DISCHARGE_RES
	
L_DISCHARGE_FINISHED:
	CLR	T1ON
	MOV	A,TM1DH
	ADDM	A,R_TEMP4
	MOVF	R_TEMP3,TM1DL	;;	低字节精度为4us
	
	SNZ	TA1F
	JMP	$1
	CLR	TA1F
	INC	R_TEMP4
$1:
	MOV	A,R_TEMP3
	ADDM	A,R_TEMP0
	MOV	A,R_TEMP4
	ADCM	A,R_TEMP1
	SZ	C
	INC	R_TEMP2
	SDZ	R_CNT1
	JMP	L_GET_TEMPERATURE_LOOP
L_GET_AVG:
	CLR	C
	RRC	R_TEMP2
	RRC	R_TEMP1
	RRC	R_TEMP0
	CLR	C
	RRC	R_TEMP2
	RRC	R_TEMP1
	RRC	R_TEMP0
	CLR	C
	RRC	R_TEMP2
	RRC	R_TEMP1
	RRC	R_TEMP0
	CLR	C
	RRC	R_TEMP2
	RRC	R_TEMP1
	RRC	R_TEMP0
;	CLR	C
;	RRC	R_TEMP2
;	RRC	R_TEMP1
;	RRC	R_TEMP0

	
L_GET_TEMPERATURE_EXIT:
	RET


;;
;;测温算法:TK／RK＝TT／RT-->RT=(TT/TK)*RK
;;TK-固定阻值电阻放电时间
;;RK-固定阻值电阻
;;TT-NTC放电时间
;;RT-NTC电阻
SBR_CALC_TEMPERATURE:
L_CALC_NTC:
	MOVF	__R_TEMP8,R_TEMP1    
	MOVF	__R_TEMP9,R_TEMP0
	
	MOVF	__R_TEMP7,010H 	;100 ;100;LOW(10000)
	MOVF	__R_TEMP6,027H 	;0 ;HIGH(10000)  03E8 = 1000   单位10欧姆   10 000 = 2710 单位欧姆
	MOVF	__R_TEMP5,0
	 
	CALL	__SBR_MULTIi_3BY2
	MOVF	__R_TEMP5,__R_TEMP4
	MOVF	__R_TEMP4,__R_TEMP3
	MOVF	__R_TEMP3,__R_TEMP2
	MOVF	__R_TEMP2,__R_TEMP1
	MOVF	__R_TEMP1,__R_TEMP0
	CLR	__R_TEMP0
	CLR	__R_TEMP6
	MOVF	__R_TEMP7,R_RES_DISCHARGE_TIME_H
	MOVF	__R_TEMP8,R_RES_DISCHARGE_TIME_L
	CALL	__SBR_DIVIDE_6BY3
	

;	MOVF	R_TEMPERATURE_H,__R_TEMP4
;	MOVF	R_TEMPERATURE_L,__R_TEMP5
;	RET		;此时 4 5 为阻值 单位欧姆
;	CLR		__R_TEMP0
;	CLR		__R_TEMP1
;	CLR		__R_TEMP2
;	;3 4 5 不变
;	CLR		__R_TEMP6
;	CLR		__R_TEMP7
;	MOVF	__R_TEMP8,10 
;	CALL	__SBR_DIVIDE_6BY3     
;	RET
			
	
  
	
L_CALC_TEMPERATURE:
	CLR	R_TEMPERATURE_L
	CLR	R_TEMPERATURE_H
	MOVF	R_TEMPERATURE_OFFSET,79
	
	MOVF	TBLP,OFFSET R_T_TAB    
	TABRDL	R_TEMPERATURE_l
	MOVF    R_TEMPERATURE_H,TBLH
	MOV	A,__R_TEMP5
	SUB	A,R_TEMPERATURE_l
	MOV	A,__R_TEMP4
	SBC	A,R_TEMPERATURE_H
	SNZ	C
	JMP	$0
	MOVF	R_TEMPERATURE_OFFSET,0
	JMP	L_CALC_TEMPERATURE_EXIT
$0:	
	MOV		A,79
	ADDM	A,	TBLP     
	TABRDL	R_TEMPERATURE_l
	MOVF    R_TEMPERATURE_H,TBLH
	MOV		A,__R_TEMP5
	SUB		A,R_TEMPERATURE_l
	MOV 	A,__R_TEMP4
	SBC		A,R_TEMPERATURE_H
	SZ		C
	JMP		L_GET_TEMPERATURE
	MOVF	R_TEMPERATURE_OFFSET,79
	JMP		L_CALC_TEMPERATURE_EXIT
L_GET_TEMPERATURE:
	DEC		R_TEMPERATURE_OFFSET
	DEC		TBLP
	TABRDL	R_TEMPERATURE_l
	MOVF    R_TEMPERATURE_H,TBLH
	MOV		A,__R_TEMP5
	SUB		A,R_TEMPERATURE_l
	MOV		A,__R_TEMP4
	SBC		A,R_TEMPERATURE_H
	SZ		C
	JMP		L_GET_TEMPERATURE
;	JMP	L_CALC_TEMPERATURE_EXIT
	INC		TBLP
	INC		R_TEMPERATURE_OFFSET	;回到电阻低的值
	TABRDL	R_TEMPERATURE_l
	MOVF    R_TEMPERATURE_H,TBLH
	MOV		A,__R_TEMP5
	SUB		A,R_TEMPERATURE_l
	MOV		__R_TEMP7,A
	MOV		A,__R_TEMP4
	SBC		A,R_TEMPERATURE_H
	MOV		__R_TEMP6,A
	CLR		__R_TEMP5
	CLR		__R_TEMP8
	MOVF	__R_TEMP9,10
	CALL	__SBR_MULTIi_3BY2
	MOVF	__R_TEMP5,__R_TEMP4
	MOVF	__R_TEMP4,__R_TEMP3
	MOVF	__R_TEMP3,__R_TEMP2
	MOVF	__R_TEMP2,__R_TEMP1
	MOVF	__R_TEMP1,__R_TEMP0
	CLR		__R_TEMP0
	CLR		__R_TEMP6
	DEC		TBLP
	TABRDL	R_BUF_L
	MOVF    R_BUF_H,TBLH
	MOV		A,R_BUF_L
	SUB		A,R_TEMPERATURE_l
	MOV		__R_TEMP8,A
	MOV		A,R_BUF_H
	SBC		A,R_TEMPERATURE_H
	MOV		__R_TEMP7,A
	CALL	__SBR_DIVIDE_6BY3
	MOVF	R_TEMPERATURE_H,__R_TEMP4		
	MOVF	R_TEMPERATURE_L,__R_TEMP5
	

		
;	MOVF	R_TEMPERATURE_L,R_TEMPERATURE_OFFSET
;	MOVF	R_TEMPERATURE_H,0

IFDEF __TEMPERATURE_ACCURACY__
		;;;带小数点后面的温度值		
		MOVF	__R_TEMP7,R_TEMPERATURE_OFFSET
		CLR		__R_TEMP6
		CLR		__R_TEMP5
		
		CLR		__R_TEMP8
		MOVF	__R_TEMP9,10
		CALL	__SBR_MULTIi_3BY2
		
		MOV		A,__R_TEMP4
		SUBM	A,R_TEMPERATURE_L
		MOV		A,__R_TEMP3
		SBCM	A,R_TEMPERATURE_H
ELSE	
	MOV		A,R_TEMPERATURE_L
	SUB		A,5
	SZ		C
	DEC		R_TEMPERATURE_OFFSET
	
	MOVF	R_TEMPERATURE_L,R_TEMPERATURE_OFFSET
	MOVF	R_TEMPERATURE_H,0		
ENDIF

	RET
	
	

	
	
	
	
	
	
;	ADDM	A,TBLP
;	TABRDL	R_TEMPERATURE_l
;	MOVF    R_TEMPERATURE_H,TBLH
;	DEC		TBLP   ;指针减一  把前一个数据读回来  相减  除以十  之后乘 余数 结果和读回来的温度值相加 
;	TABRDL	R_TEMPERATURE_BUF_l
;	MOVF    R_TEMPERATURE_BUF_H,TBLH
;	MOV		A,R_TEMPERATURE_BUF_l
;	SUB		A,R_TEMPERATURE_l
;	MOV		R_TEMPERATURE_BUF_l,A
;	MOV		A,R_TEMPERATURE_BUF_H
;	SBC		A,R_TEMPERATURE_H
;	MOV		R_TEMPERATURE_BUF_H,A
;	;;;除以10   再乘以算的的余数
;	CLR		__R_TEMP5
;	MOVF	__R_TEMP6,R_TEMPERATURE_BUF_H
;	MOVF	__R_TEMP7,R_TEMPERATURE_BUF_L
;	
;	MOVF	__R_TEMP8,__R_TEMP1
;	MOVF	__R_TEMP9,__R_TEMP2
;	CALL	__SBR_MULTIi_3BY2
;	
;	MOVF	__R_TEMP5,__R_TEMP4
;	MOVF	__R_TEMP4,__R_TEMP3
;	MOVF	__R_TEMP3,__R_TEMP2
;	MOVF	__R_TEMP2,__R_TEMP1
;	MOVF	__R_TEMP1,__R_TEMP0
;;	MOVF	__R_TEMP5,R_TEMPERATURE_BUF_L	
;;	MOVF	__R_TEMP4,R_TEMPERATURE_BUF_H
;;	CLR	__R_TEMP3
;;	CLR	__R_TEMP2	
;;	CLR	__R_TEMP1
;	CLR	__R_TEMP0
;	CLR	__R_TEMP6
;	CLR	__R_TEMP7
;	MOVF	__R_TEMP8,10
;	CALL	__SBR_DIVIDE_6BY3	
;	MOV		A,__R_TEMP2
;	ADDM	A,R_TEMPERATURE_L
;	MOV		A,__R_TEMP1
;	ADCM	A,R_TEMPERATURE_H
;	
;	CLR		__R_TEMP0
;	CLR		__R_TEMP1
;	CLR		__R_TEMP2
;	CLR		__R_TEMP3
;	MOVF	__R_TEMP4,R_TEMPERATURE_H		
;	MOVF	__R_TEMP5,R_TEMPERATURE_L
;	
;	CLR	__R_TEMP6
;	CLR	__R_TEMP7
;	MOVF	__R_TEMP8,10
;	CALL	__SBR_DIVIDE_6BY3
;;	RET	
;	MOVF	R_TEMPERATURE_L,__R_TEMP5
;	MOVF	R_TEMPERATURE_H,__R_TEMP4
L_CALC_TEMPERATURE_EXIT:
	IFDEF __TEMPERATURE_ACCURACY__
	MOVF	R_TEMPERATURE_L,0
	MOVF	R_TEMPERATURE_H,0
	MOVF	__R_TEMP7,R_TEMPERATURE_OFFSET
	CLR		__R_TEMP6
	CLR		__R_TEMP5
		
	CLR		__R_TEMP8
	MOVF	__R_TEMP9,10
	CALL	__SBR_MULTIi_3BY2
		
	MOV		A,__R_TEMP4
	SUBM	A,R_TEMPERATURE_L
	MOV		A,__R_TEMP3
	SBCM	A,R_TEMPERATURE_H
	ELSE
	MOVF	R_TEMPERATURE_L,R_TEMPERATURE_OFFSET
	MOVF	R_TEMPERATURE_H,0
;	MOVF	__R_TEMP8,R_TEMPERATURE_H
;	MOVF	__R_TEMP9,R_TEMPERATURE_L
	ENDIF
	RET
	
	
;
;SBR_GET_AD:
;	CLR	ADOFF
;L_AD_START:
;	CLR	WDT
;	CLR	START
;	NOP
;	SET	START
;	NOP
;	CLR	START
;L_POLLING:
;	SZ	EOCB
;	JMP	L_POLLING
;	MOV	A,ADR
;	RET

	
PUBLIC SBR_GET_TEMPERATURE	
PUBLIC __INI__
PUBLIC SBR_INIT_TM1
PUBLIC SBR_CALC_TEMPERATURE

PUBLIC R_TEMP0
PUBLIC R_TEMP1
PUBLIC R_TEMP2
PUBLIC R_RES_DISCHARGE_TIME_H
PUBLIC R_RES_DISCHARGE_TIME_L
PUBLIC R_TEMPERATURE_L
PUBLIC R_TEMPERATURE_H	
PUBLIC R_TEMPERATURE_BUF_L
PUBLIC R_TEMPERATURE_BUF_H
PUBLIC F_GET_NTC

PUBLIC SBR_USER_INIT

end

