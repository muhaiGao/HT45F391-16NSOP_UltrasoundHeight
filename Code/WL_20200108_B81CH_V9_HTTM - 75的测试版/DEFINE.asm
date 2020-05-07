;
;;=====================================================================================
;;User define
;;=====================================================================================
;
;;-------------------------------------------------------------------------------------
;;LIN BUS
;;-------------------------------------------------------------------------------------
;;#define				RXC		PAC.7
;;#define				RX		PA.7
;;#define				TXC		PAC.7
;;#define				TX		PA.7
;
;
;include	MACRO.INC
;;;;HT45F39  IAP ����
;
;;address:	__R_TEMP0(L),__R_PAGE(H)
;
;SBR_WRITE_flash:
;
;L_ENABLE_IAP:
;		
;		MOVF	FC0,	11100000B	;FMOD2`FMOD0 = 110  FWENģʽ-Flash�洢��д����ʹ��ģʽ
;		SET		FWPEN				;д����ʹ�ܿ���
;
;		MOVF	FD1L,	00H
;		MOVF	FD1H,	04H
;		MOVF	FD2L,	0DH
;		MOVF	FD2H,	09H
;		MOVF	FD3L,	0C3H
;		MOVF	FD3H,	40H
;
;		
;		MOV	A,255
;	$1:	
;		CLR	WDT
;		SNZ	FWPEN
;		JMP	L_WRITE_flash00
;	
;		SDZ	ACC
;		JMP	$1
;		JMP	SBR_WRITE_flash;enable failed	;��ʱ дʧ�� ��д
;
;L_WRITE_flash00:
;;;;����ҳ����
;		MOVF	FC0,	10010000B	;FMOD2`FMOD0 = 001   ����ҳģʽ
;		SET	FWT			;����һ��д����
;
;		CLR	WDT
;		SZ	FWT
;		JMP	$-2			;�ȴ�д�������
;
;;;;д����
;SBR_WRITE_flash01:
;		MOVF	FC0,	10000000B	;FMOD2`FMOD0 = 000  д�洢��ģʽ    		
;		
;		MOVF	FARL,	ADDRESS_L
;		MOVF	FARH,	ADDRESS_H
;		MOVF	FD0L,	__R_TEML
;		MOVF	FD0H,	__R_TEMH
;
;		SET	FWT
;
;		MOV	A,255				;ʵ����300us��ʱ��
;	$00:
;		CLR	WDT
;		SNZ	FWT
;		JMP	$02
;		SDZ	ACC
;		JMP	$00
;		JMP	SBR_WRITE_flash01		;��ʱ��д
;		
;	$02:	
;		CLR	CFWEN				;д�ɹ���CFWEN �����0
;		RET
;
;;;;������
;SBR_READ_flash02��
;;��һ�ַ���
;		MOVF	FC0,	10110000B	;FMOD2`FMOD0 = 011  ���洢��ģʽ    
;		MOVF	FARL,	ADDRESS_L
;		MOVF	FARH,	ADDRESS_H
;		
;		SET	FRDEN
;		MOV	A,255
;	$03:	
;		SET	FRD
;		SNZ	FRD
;		JMP	$04
;		SDZ	ACC
;		JMP	$03
;		JMP	SBR_READ_flash02
;	$04:	
;		MOVF	__R_TEMPL,FD0L
;		MOVF	__R_TEMPH,FD0H
;		CLR	FWEN
;
;		
;
;;�ڶ��ַ���
;		MOVF	TBLP,__R_TEMP0		;ƫ����
;		MOVF	TBLH,R_PAGE
;
;		TABRDC	_R_TEMPH
;		MOVF	_R_TEMPH,TBLH
;		RET
;
;
;
