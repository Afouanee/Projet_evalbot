	;; RK - Evalbot (Cortex M3 de Texas Instrument)
	;; Les deux LEDs sont initialement allum�es
	;; Ce programme lis l'�tat du bouton poussoir 1 connect�e au port GPIOD broche 6
	;; Si bouton poussoir ferm� ==> fait clignoter les deux LED1&2 connect�e au port GPIOF broches 4&5.
   	
		AREA    |.text|, CODE, READONLY
 
; This register controls the clock gating logic in normal Run mode
SYSCTL_PERIPH_GPIO EQU		0x400FE108	; SYSCTL_RCGC2_R (p291 datasheet de lm3s9b92.pdf)

; The GPIODATA register is the data register
GPIO_PORTF_BASE		EQU		0x40025000	; GPIO Port F (APB) base: 0x4002.5000 (p416 datasheet de lm3s9B92.pdf)

; The GPIODATA register is the data register
GPIO_PORTD_BASE		EQU		0x40007000		; GPIO Port D (APB) base: 0x4000.7000 (p416 datasheet de lm3s9B92.pdf)
	
; The GPIODATA register is the data register
GPIO_PORTE_BASE     EQU		0x40024000

; configure the corresponding pin to be an output
; all GPIO pins are inputs by default
GPIO_O_DIR   		EQU 	0x00000400  ; GPIO Direction (p417 datasheet de lm3s9B92.pdf)

; The GPIODR2R register is the 2-mA drive control register
; By default, all GPIO pins have 2-mA drive.
GPIO_O_DR2R   		EQU 	0x00000500  ; GPIO 2-mA Drive Select (p428 datasheet de lm3s9B92.pdf)

; Digital enable register
; To use the pin as a digital input or output, the corresponding GPIODEN bit must be set.
GPIO_O_DEN  		EQU 	0x0000051C  ; GPIO Digital Enable (p437 datasheet de lm3s9B92.pdf)

; Pul_up
GPIO_I_PUR   		EQU 	0x00000510  ; GPIO Pull-Up (p432 datasheet de lm3s9B92.pdf)
	
BROCHE4				EQU		0x10		; ledD

BROCHE5				EQU		0x20		; ledG

BROCHE4_5			EQU		0x30		; ledD_G
	
BROCHE1				EQU		0x01		; bumperD

BROCHE2				EQU 	0x02		; bumperG
	
BROCHE1_2			EQU		0x03		; bumperD_G
	
BROCHE6				EQU		0x40		; switch1
	
BROCHE7				EQU		0x80		; switch2
	
BROCHE6_7			EQU		0xC0		;; switch1_2


; fr�quence clignotement
DUREE   			EQU     0x1E2FFF
	

	  	ENTRY
		EXPORT	__main
			
		IMPORT	MOTEUR_INIT					; initialise les moteurs (configure les pwms + GPIO)
		
		IMPORT	MOTEUR_DROIT_ON				; activer le moteur droit
		IMPORT  MOTEUR_DROIT_OFF			; d�activer le moteur droit
		IMPORT  MOTEUR_DROIT_AVANT			; moteur droit tourne vers l'avant
		IMPORT  MOTEUR_DROIT_ARRIERE		; moteur droit tourne vers l'arri�re
		IMPORT  MOTEUR_DROIT_INVERSE		; inverse le sens de rotation du moteur droit
		
		IMPORT	MOTEUR_GAUCHE_ON			; activer le moteur gauche
		IMPORT  MOTEUR_GAUCHE_OFF			; d�activer le moteur gauche
		IMPORT  MOTEUR_GAUCHE_AVANT			; moteur gauche tourne vers l'avant
		IMPORT  MOTEUR_GAUCHE_ARRIERE		; moteur gauche tourne vers l'arri�re
		IMPORT  MOTEUR_GAUCHE_INVERSE		; inverse le sens de rotation du moteur gauche
			
			
			
__main	

		; ;; Enable the Port F & D peripheral clock 		(p291 datasheet de lm3s9B96.pdf)
		; ;;									
		ldr r6, = SYSCTL_PERIPH_GPIO  			;; RCGC2
        mov r0, #0x00000038  					;; Enable clock sur GPIO D et F o� sont branch�s les leds (0x28 == 0b101000)
		; ;;														 									      (GPIO::FEDCBA)
        str r0, [r6]
		
		; ;; "There must be a delay of 3 system clocks before any GPIO reg. access  (p413 datasheet de lm3s9B92.pdf)
		nop	   									;; tres tres important....
		nop	   
		nop	   									;; pas necessaire en simu ou en debbug step by step...
		
	
		;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^CONFIGURATION LED
		
        ldr r6, = GPIO_PORTF_BASE+GPIO_O_DIR   
        ldr r0, = BROCHE4_5
        str r0, [r6]
		
		ldr r6, = GPIO_PORTF_BASE+GPIO_O_DEN	;; Enable Digital Function 
        ldr r0, = BROCHE4_5
        str r0, [r6]
		
		ldr r6, = GPIO_PORTF_BASE+GPIO_O_DR2R	;; Choix de l'intensit� de sortie (2mA)
        ldr r0, = BROCHE4_5	
        str r0, [r6]
		
		mov r2, #0x000       					;; pour eteindre LED
     
		; allumer la led droite et gauche (BROCHE4_5)
		mov r3, #BROCHE4_5	
			
		ldr r6, = GPIO_PORTF_BASE + (BROCHE4_5<<2)  ;; @data Register = @base + (mask<<2) ==> LED1
		
		;;vvvvvvvvvvvvvvvvvvvvvvvFin configuration Bumper 
		
		
		;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^CONFIGURATION Bumper

		ldr r7, = GPIO_PORTE_BASE+GPIO_I_PUR	;; Pul_up 
        ldr r0, = BROCHE1_2
        str r0, [r7]
		
		ldr r7, = GPIO_PORTE_BASE+GPIO_O_DEN	;; Enable Digital Function 
        ldr r0, = BROCHE1_2
        str r0, [r7]     
		
		ldr r7, = GPIO_PORTE_BASE + (BROCHE1_2<<2)  ;; @data Register = @base + (mask<<2) ==> Bumper
		
		;vvvvvvvvvvvvvvvvvvvvvvvFin configuration Bumper 
		
		
		;;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^CONFIGURATION Switcher
		
		ldr r7, = GPIO_PORTD_BASE+GPIO_I_PUR	;; Pul_up 
        ldr r0, = BROCHE6_7
        str r0, [r7]
		
		ldr r7, = GPIO_PORTD_BASE+GPIO_O_DEN	;; Enable Digital Function 
        ldr r0, = BROCHE6_7
        str r0, [r7]     
		
		ldr r7, = GPIO_PORTD_BASE + (BROCHE6_7<<2)  ;; @data Register = @base + (mask<<2) ==> Switcher
		
		;;vvvvvvvvvvvvvvvvvvvvvvvFin configuration Switcher
		
		
		;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^CLIGNOTTEMENT

		str r3, [r6]  							;; Allume LED1&2 portF broche 4&5 : 00110000 (contenu de r3)
		
		; Configure les PWM + GPIO
		BL	MOTEUR_INIT	   		   
		
		; Activer les deux moteurs droit et gauche
		BL	MOTEUR_DROIT_ON
		BL	MOTEUR_GAUCHE_ON						
		
; D�marrage de l'evalbot
ReadState_ini

		BL	MOTEUR_GAUCHE_OFF	   
		BL	MOTEUR_DROIT_OFF

		
		ldr r8, = GPIO_PORTD_BASE + (BROCHE6<<2)
		ldr r8, [r8]
		CMP r8, #0x00
		BEQ salutation_fan
		
		ldr r8, = GPIO_PORTD_BASE + (BROCHE7<<2)
		ldr r8, [r8]
		CMP r8, #0x00
		BEQ ReadState	; Passer en mode course
		
		
		mov r4, #0 		;Initialisation du compteur 
		
		B ReadState_ini	

		
salutation_fan

		BL	MOTEUR_DROIT_ON
		BL	MOTEUR_GAUCHE_ON
		
		BL	MOTEUR_GAUCHE_AVANT
		BL	MOTEUR_DROIT_ARRIERE
		
		
		ldr r9, = GPIO_PORTF_BASE + (BROCHE4_5<<2)
		str r2, [r9]							;; eteint la led1_2
		ldr r1, = DUREE 						;; pour la duree de la boucle d'attente1 (wait_ini)

wait_led_off_ini	

		subs r1, #1
        bne wait_led_off_ini
		
        str r3, [r9]  							;; allume la led1_2
		ldr r1, = DUREE							;; pour la duree de la boucle d'attente2 (wait2)

wait_led_on_ini
		
		subs r1, #1
		bne wait_led_on_ini
		
		adds r4, r4, #1							;; Incr�mentation du compteur
		CMP r4, #9								;; V�rification si le compteur a atteint la valeur maximale
		
		BEQ ReadState_ini 						;; Si oui, retourner au programme initial
		
		b salutation_fan
	
		
; Mode course		
ReadState

		BL	MOTEUR_DROIT_ON
		BL	MOTEUR_GAUCHE_ON	

		BL	MOTEUR_DROIT_AVANT	   
		BL	MOTEUR_GAUCHE_AVANT

		ldr r8, = GPIO_PORTE_BASE + (BROCHE1<<2)
		ldr r8, [r8]
		CMP r8, #0x00
		BEQ bumper_droit
		
		ldr r9, = GPIO_PORTE_BASE + (BROCHE2<<2)
		ldr r9, [r9]
		CMP r9, #0x00
		BEQ bumper_gauche
		
		mov r4, #0 		;Initialisation du compteur 
		
		B ReadState

; Bumper Droit activer				
bumper_droit

		BL	MOTEUR_GAUCHE_ARRIERE
		ldr r9, = GPIO_PORTF_BASE + (BROCHE4<<2)
		str r2, [r9]							;; eteint la led1
		ldr r1, = DUREE 						;; pour la duree de la boucle d'attente1 (wait1)

		
wait_led_off_droit	
		
		subs r1, #1
        bne wait_led_off_droit
		
        str r3, [r9]  							;; allume la led1
		
		adds r4, r4, #1							;; Incr�mentation du compteur

		CMP r4, #1								;; V�rification si le compteur a atteint la valeur maximale
		
		BEQ ReadState 							;; Si oui, terminer le programme
		
		b bumper_droit
		
		
bumper_gauche

		BL	MOTEUR_DROIT_ARRIERE
		ldr r8, = GPIO_PORTF_BASE + (BROCHE5<<2)
		str r2, [r8]
		ldr r1, = DUREE 						;; pour la duree de la boucle d'attente1 (wait1)

		
wait_led_off_gauche

		subs r1, #1
        bne wait_led_off_gauche
				
        str r3, [r8]  							;; Allume LED1&2 portF broche 4&5 : 00110000 (contenu de r3)
        ldr r1, = DUREE							;; pour la duree de la boucle d'attente2 (wait2)
		
		adds r4, r4, #1							; Incr�mentation du compteur
		
		CMP r4, #1								; V�rification si le compteur a atteint la valeur maximale
		BEQ ReadState 							; Si oui, terminer le programme
		
		b bumper_gauche
		
		nop
		END 