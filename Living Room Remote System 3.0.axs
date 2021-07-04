PROGRAM_NAME='Living Room Remote System 3.0'
(***********************************************************)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 04/05/2006  AT: 09:00:25        *)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
(*
    $History: $
*)
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

(********************************************************************
    /* Physical Devices */ 
*********************************************************************)

//////////////Living Room

DV_Digiturk		= 5001:8:0 //Digiturk
DV_DVD 			= 5001:6:0 //DVD
DV_Apple_TV		= 5001:5:0 //Apple TV

DV_AVR 			= 0:6:0	//AVR
DV_TV_WOL		= 0:2:0	 // LG TV Wake on LAN Living Room

DV_TV 			= 5001:1:0 //TV

relay			= 5001:4:0  //relay 

//////////////Cinema Room

DV_TV_WOL_CIN		= 0:3:0	 // LG TV Wake on LAN Cinema Room

DV_TV_CIN		= 5001:1:2 //TV

DV_AVR_CIN		= 5001:2:2 //AVR
DV_TV_Plus_CIN		= 5001:3:2 //TV+
DV_Digiturk_CIN		= 5001:4:2 //Digiturk*/

(********************************************************************
    /* Panel */ 
*********************************************************************)

//////////////Living Room

DVTP_GENERAL 		= 10001:1:0
DVTP_IR 		= 10001:12:0
DVTP_AVR_TCP 		= 10001:10:0
DVTP_LGTV_RS		= 10001:6:0

//////////////Cinema Room

DVTP_GENERAL_CIN	= 10002:1:0
DVTP_IR_CIN		= 10002:12:0
DVTP_LGTV_RS_CIN	= 10002:6:0

(********************************************************************
    /* Virtual Devices */ 
*********************************************************************) 

VDV_TP_GENERAL		= 33001:1:0
VDV_TP_IR		= 33002:1:0
VDV_TP_AVR_TCP		= 33003:1:0
VDV_TP_LGTV_RS		= 33004:1:0

DEFINE_COMBINE

(VDV_TP_GENERAL,DVTP_GENERAL, DVTP_GENERAL_CIN)
(VDV_TP_IR,DVTP_IR, DVTP_IR_CIN)
(VDV_TP_LGTV_RS,DVTP_LGTV_RS, DVTP_LGTV_RS_CIN)

(VDV_TP_AVR_TCP,DVTP_AVR_TCP)

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

char AVR_IP = '192.168.1.22'

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

integer on_off //AVR CLIENT VARIABLE
integer mute_var = 0 //MUTE BUTTON VARIABLE
integer avr_switch_var = 0 //SWITCH TO AVR BUTTON VARIABLE

(****************************************
0 = off (not in netflix/netflix is closed)
1 = on (in netflix/netflix is open) 
****************************************)
integer netflix_var = 0
integer youtube_var = 0

char avr_feedback
integer avr_var = 0

char tv_feedback
integer tv_var = 0

MAC[6]             // MAC-Adress of the Computers Network-card (6 Bytes)
START[6]          // 6 x $FF, Part of the 'Magic Packet'

integer netflix_var_cin = 0
integer youtube_var_cin = 0

integer mute_var_cin = 0

MAC_CIN[6]

(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

([VDV_TP_GENERAL,1]..[VDV_TP_GENERAL,10])

(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

IP_CLIENT_OPEN (DV_AVR.PORT,AVR_IP, 23, 1)//ip degistir

MAC="$78,$5D,$C8,$E3,$80,$82"  
START="$FF,$FF,$FF,$FF,$FF,$FF"
MAC_CIN="$64,$95,$6C,$1D,$D1,$5D"

//GENERAL WOL TV METHOD
DEFINE_FUNCTION WAKE_TV ()
{
    IP_CLIENT_OPEN (DV_TV_WOL.PORT,'255.255.255.255', 2304, 2)  // Open port with Broadcast adress and Port=2304 , UDP
	WAIT 3
	send_string DV_TV_WOL,"START,MAC,MAC,MAC,MAC,MAC,MAC,MAC,MAC,MAC,MAC,MAC,MAC,MAC,MAC,MAC,MAC" 
	WAIT 5
    IP_CLIENT_CLOSE (DV_TV_WOL.PORT)
} 

//CINEMA ROOM WOL TV METHOD
DEFINE_FUNCTION WAKE_TV_CIN()
{
    IP_CLIENT_OPEN (DV_TV_WOL_CIN.PORT,'255.255.255.255', 2304, 2)  // Open port with Broadcast adress and Port=2304 , UDP
	WAIT 3
	send_string DV_TV_WOL_CIN,"START,MAC_CIN,MAC_CIN,MAC_CIN,MAC_CIN,MAC_CIN,MAC_CIN,MAC_CIN,MAC_CIN,MAC_CIN,MAC_CIN,MAC_CIN,MAC_CIN,MAC_CIN,MAC_CIN,MAC_CIN,MAC_CIN" 
	WAIT 5
    IP_CLIENT_CLOSE (DV_TV_WOL_CIN.PORT)
}

(* System Information Strings ******************************)
(* Use this section if there is a TP in the System!        *)
(*
    SEND_COMMAND TP,"'!F',250,'1'"
    SEND_COMMAND TP,"'TEXT250-',__NAME__"
    SEND_COMMAND TP,"'!F',251,'1'"
    SEND_COMMAND TP,"'TEXT251-',__FILE__,', ',S_DATE,', ',S_TIME"
    SEND_COMMAND TP,"'!F',252,'1'"
    SEND_COMMAND TP,"'TEXT252-',__VERSION__"
    SEND_COMMAND TP,"'!F',253,'1'"
    (* Must fill this (Master Ver) *)
    SEND_COMMAND TP,'TEXT253-'
    SEND_COMMAND TP,"'!F',254,'1'"
    (* Must fill this (Panel File) *)
    SEND_COMMAND TP,'TEXT254-'
    SEND_COMMAND TP,"'!F',255,'1'"
    (* Must fill this (Dealer Info) *)
    SEND_COMMAND TP,'TEXT255-'
*)

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

    //IR BUTTONS (DIGITURK+DVD+APPLE TV)
    button_event[VDV_TP_IR, 0] //CHANNEL PORT: 12
    {
	push:
	{
	    //DIGITURK LIVING ROOM
	    IF((button.input.channel >= 4) and (button.input.channel <= 100))
	    {
		pulse[DV_Digiturk, button.input.channel-2]
	    }
	    //DVD
	    IF((button.input.channel >= 101) and (button.input.channel <= 200))
	    {
		pulse[DV_DVD, button.input.channel-100]
	    }
	    //APPLE TV
	    IF((button.input.channel >= 201) and (button.input.channel <= 300))
	    {
		pulse[DV_Apple_TV, button.input.channel-200]
	    }
	    
	}
    }
    
    //DIGITURK POWER BUTTON
    button_event[VDV_TP_IR, 3] //CHANNEL PORT: 12
    {
	push:
	{
	    pulse[DV_Digiturk, 1]
	}
    }
    
    //RS232
    DATA_EVENT[DV_TV]
    {
	ONLINE:
	{
	    SEND_COMMAND DV_TV, 'SET BAUD 9600, N, 8, 1, 485 DISABLE'
	    SEND_COMMAND DV_TV, 'HSOFF'
	    SEND_COMMAND DV_TV, 'XOFF'
	}
	STRING:
	{
	    tv_feedback = data.text
	    IF(tv_feedback == "'a 01 OK00x'")
	    {
		tv_var = 0
	    }
	    ELSE IF(tv_feedback == "'a 01 OK01x'")
	    {
		tv_var = 1
	    }
	}
    }
    
    //AVR IP CLIENT STATUS
    DATA_EVENT[DV_AVR]
    {
	ONLINE:
	{
	    on_off = 1
	}
	OFFLINE:
	{
	    on_off = 0
	    IP_CLIENT_OPEN (DV_AVR.PORT,AVR_IP, 23, 1)
	}
	STRING:
	{
	    avr_feedback = data.text
	    IF(avr_feedback == "'PWON'" || avr_feedback == "'PWONZ2ONZ2OFF'" || avr_feedback == "'PWONZ2ON'")
	    {
		avr_var = 1
	    }
	    ELSE IF(avr_feedback == "'PWSTANDBY'" || avr_feedback == "'PWSTANDBYZMOFF'")
	    {
		avr_var = 0
	    }
	}
    }

    //SIDE BAR BUTTONS
    button_event[VDV_TP_GENERAL, 0] //CHANNEL PORT: 1
    {
	push:
	{
	    ON[VDV_TP_GENERAL, button.input.channel] //BUTTON --> ON State
	    
	    WAKE_TV()
	    
	    (********************************************************************
	    /* Yeni duzende avr switch variable ve state change'i her condition da
	    belirt */ 
	    *********************************************************************)
	    
	    IF(button.input.channel == 3) //DIGITURK
	    {
		IF(netflix_var == 1 || youtube_var == 1)
		{
		    //TV Input
		    send_string DV_TV, "'mc',$20,'1',$20,'7C',$0D" //home button
		    WAIT 3
		    send_string DV_TV, "'mc',$20,'1',$20,'06',$0D" //right button
		    WAIT 5
		    send_string DV_TV, "'mc',$20,'1',$20,'06',$0D" //right button
		    WAIT 7
		    send_string DV_TV, "'mc',$20,'1',$20,'44',$0D" //enter
			    
		    //AVR 
		    IP_CLIENT_OPEN (DV_AVR.PORT,AVR_IP, 23, 1)//ip degistir
			WAIT 3
			send_string DV_AVR,"'SITV',$0D" // hdmi input --> TV (kaynak cahnge)
			WAIT 5
		    IP_CLIENT_CLOSE (DV_AVR.PORT)
		    
		    //Digiturk
		    pulse[DV_Digiturk, 17]
		    WAIT 5
		    pulse[DV_Digiturk, 18]
		    
		    //AVR SWITCH VAR CHANGE
		    avr_switch_var = 0
		    //AVR SWITCH STATE CHANGE
		    OFF[VDV_TP_AVR_TCP, 32]
		}
		ELSE
		{
		    //TV Input
		    send_string DV_TV, "'xb',$20,'1',$20,'93',$0D"
			
		    //AVR 
		    IP_CLIENT_OPEN (DV_AVR.PORT,AVR_IP, 23, 1)//ip degistir
			WAIT 3
			send_string DV_AVR,"'SITV',$0D"
			WAIT 5
		    IP_CLIENT_CLOSE (DV_AVR.PORT)
			
		    //Digiturk
		    pulse[DV_Digiturk, 17]
		    WAIT 5
		    pulse[DV_Digiturk, 18]
			
		    //AVR SWITCH VAR CHANGE
		    avr_switch_var = 0
		    //AVR SWITCH STATE CHANGE
		    OFF[VDV_TP_AVR_TCP, 32]
		}
	    }
	    
	    IF(button.input.channel == 4) //NETFLIX
	    {
		//TV Input
		send_string DV_TV, "'mc',$20,'1',$20,'7C',$0D" //home button
		WAIT 3
		send_string DV_TV, "'mc',$20,'1',$20,'44',$0D" //enter
		
		//AVR
		IP_CLIENT_OPEN (DV_AVR.PORT,AVR_IP, 23, 1)//ip degistir
		    WAIT 3
		    send_string DV_AVR,"'SITV',$0D"
		    WAIT 5
		IP_CLIENT_CLOSE (DV_AVR.PORT)
		
		WAIT 3
		
		netflix_var = 1
		
		//AVR SWITCH VAR CHANGE
		avr_switch_var = 0
		
		//AVR SWITCH STATE CHANGE
		OFF[VDV_TP_AVR_TCP, 32]
		
	    }
	    
	    IF(button.input.channel == 5) //YOUTUBE
	    {
		//TV Input
		send_string DV_TV, "'mc',$20,'1',$20,'7C',$0D" //home button
		WAIT 3
		send_string DV_TV, "'mc',$20,'1',$20,'06',$0D" //right button
		WAIT 5
		send_string DV_TV, "'mc',$20,'1',$20,'44',$0D" //enter
		
		//AVR
		IP_CLIENT_OPEN (DV_AVR.PORT,AVR_IP, 23, 1)//ip degistir
		    WAIT 3
		    send_string DV_AVR,"'SITV',$0D"
		    WAIT 5
		IP_CLIENT_CLOSE (DV_AVR.PORT)
		
		WAIT 3
		
		youtube_var = 1
		
		//AVR SWITCH VAR CHANGE
		avr_switch_var = 0
		
		//AVR SWITCH STATE CHANGE
		OFF[VDV_TP_AVR_TCP, 32]
		
	    }
	    
	    IF(button.input.channel == 6) //GAME
	    {
		IF(netflix_var == 1 || youtube_var == 1)
		{
		    //TV Input = AVR
		    send_string DV_TV, "'mc',$20,'1',$20,'7C',$0D" //home button
		    WAIT 3
		    send_string DV_TV, "'mc',$20,'1',$20,'06',$0D" //right button
		    WAIT 5
		    send_string DV_TV, "'mc',$20,'1',$20,'06',$0D" //right button
		    WAIT 7
		    send_string DV_TV, "'mc',$20,'1',$20,'06',$0D" //right button
		    WAIT 9
		    send_string DV_TV, "'mc',$20,'1',$20,'44',$0D" //enter
		    
		    //AVR
		    IP_CLIENT_OPEN (DV_AVR.PORT,AVR_IP, 23, 1)//ip degistir
			WAIT 3
			send_string DV_AVR,"'SIGAME',$0D"
			WAIT 5
		    IP_CLIENT_CLOSE (DV_AVR.PORT)
		    
		    netflix_var = 0
		    youtube_var = 0
		}
		ELSE 
		{
		    //TV Input
		    send_string DV_TV, "'xb',$20,'1',$20,'91',$0D"
		    
		    //AVR
		    IP_CLIENT_OPEN (DV_AVR.PORT,AVR_IP, 23, 1)//ip degistir
			WAIT 3
			send_string DV_AVR,"'SIGAME',$0D"
			WAIT 5
		    IP_CLIENT_CLOSE (DV_AVR.PORT)
		}
	    }
	    
	    IF(button.input.channel == 7) //APPLE TV
	    {
		IF(netflix_var == 1 || youtube_var == 1)
		{
		    //TV Input = AVR
		    send_string DV_TV, "'mc',$20,'1',$20,'7C',$0D" //home button
		    WAIT 3
		    send_string DV_TV, "'mc',$20,'1',$20,'06',$0D" //right button
		    WAIT 5
		    send_string DV_TV, "'mc',$20,'1',$20,'06',$0D" //right button
		    WAIT 7
		    send_string DV_TV, "'mc',$20,'1',$20,'06',$0D" //right button
		    WAIT 9
		    send_string DV_TV, "'mc',$20,'1',$20,'44',$0D" //enter
		    
		    //AVR
		    IP_CLIENT_OPEN (DV_AVR.PORT,AVR_IP, 23, 1)//ip degistir
			WAIT 3
			send_string DV_AVR,"'SIMPLAY',$0D"
			WAIT 5
		    IP_CLIENT_CLOSE (DV_AVR.PORT)
		    
		    //APPLE TV
		    pulse[DV_Apple_TV, 7]
		    
		    WAIT 5
		    
		    netflix_var = 0
		    youtube_var = 0
		}
		ELSE 
		{
		    //APPLE TV
		    SET_PULSE_TIME (7)
		    pulse[DV_Apple_TV, 7]
		    SET_PULSE_TIME (5)
		    
		    //TV Input
		    send_string DV_TV, "'xb',$20,'1',$20,'91',$0D"
		    
		    //AVR
		    IP_CLIENT_OPEN (DV_AVR.PORT,AVR_IP, 23, 1)//ip degistir
			WAIT 3
			send_string DV_AVR,"'SIMPLAY',$0D"
			WAIT 5
		    IP_CLIENT_CLOSE (DV_AVR.PORT)
		}
	    }
	    
	    IF(button.input.channel == 8) //DVD
	    {
		IF(netflix_var == 1 || youtube_var == 1)
		{
		    //DVD
		    //SET_PULSE_TIME (7)
		    pulse[DV_DVD, 1]
		    //SET_PULSE_TIME (5)
		    //TO[DV_DVD, 1]
		    
		    //TV Input = AVR
		    send_string DV_TV, "'mc',$20,'1',$20,'7C',$0D" //home button
		    WAIT 3
		    send_string DV_TV, "'mc',$20,'1',$20,'06',$0D" //right button
		    WAIT 5
		    send_string DV_TV, "'mc',$20,'1',$20,'06',$0D" //right button
		    WAIT 7
		    send_string DV_TV, "'mc',$20,'1',$20,'06',$0D" //right button
		    WAIT 9
		    send_string DV_TV, "'mc',$20,'1',$20,'44',$0D" //enter
		    
		    //AVR
		    IP_CLIENT_OPEN (DV_AVR.PORT,AVR_IP, 23, 1)//ip degistir
			WAIT 3
			send_string DV_AVR,"'SIBD',$0D"
			WAIT 5
		    IP_CLIENT_CLOSE (DV_AVR.PORT)
		    
		    WAIT 3
		    
		    netflix_var = 0
		    youtube_var = 0
		}
		ELSE 
		{
		    //DVD
		    SET_PULSE_TIME (7)
		    pulse[DV_DVD, 1]
		    SET_PULSE_TIME (5)
		    //TO[DV_DVD, 1]
		    
		    WAIT 3
		    
		    //TV Input
		    send_string DV_TV, "'xb',$20,'1',$20,'91',$0D"
		    
		    //AVR
		    IP_CLIENT_OPEN (DV_AVR.PORT,AVR_IP, 23, 1)//ip degistir
			WAIT 3
			send_string DV_AVR,"'SIBD',$0D"
			WAIT 5
		    IP_CLIENT_CLOSE (DV_AVR.PORT)
		}
	    }
	    
	}
    }

    //FOOTER BUTTONS
    button_event[VDV_TP_GENERAL, 0] //CHANNEL PORT: 1
    {
	push:
	{
	    ON[VDV_TP_GENERAL, button.input.channel] //BUTTON --> ON State
	    
	    IF(button.input.channel == 15) //TV Settings 
	    {
		WAKE_TV()
		send_string DV_TV, "'mc',$20,'1',$20,'43',$0D"
	    }
	    
	    IF(button.input.channel == 17) //NUMERIC BUTTON 
	    {
		WAKE_TV()
	    }
	}
	
    }

    //LIVING ROOM (HOME) BUTTONS
    button_event[VDV_TP_GENERAL, 0] //CHANNEL PORT: 1
    {
	push:
	{
	    ON[VDV_TP_GENERAL, button.input.channel] //BUTTON --> ON State
	    
	    IF(button.input.channel == 19) //SYSTEM ON
	    {
		ON[VDV_TP_GENERAL, 190]
		ON[VDV_TP_GENERAL, 19]
		
		WAIT 3
		
		IF(avr_var == 0 || tv_var == 0)
		{
		    //TV ON
		    IP_CLIENT_OPEN (DV_TV_WOL.PORT,'255.255.255.255', 2304, 2)  // Open port with Broadcast adress and Port=2304 , UDP
			WAIT 3
			send_string DV_TV_WOL,"START,MAC,MAC,MAC,MAC,MAC,MAC,MAC,MAC,MAC,MAC,MAC,MAC,MAC,MAC,MAC,MAC" 
			WAIT 5
		    IP_CLIENT_CLOSE (DV_TV_WOL.PORT)
			
		    //AVR ON
		    IP_CLIENT_OPEN (DV_AVR.PORT,AVR_IP, 23, 1)//ip degistir
			WAIT 3
			send_string DV_AVR,"'PWON',$0D"
			WAIT 5
		    IP_CLIENT_CLOSE (DV_AVR.PORT)
		}
	    }
	    
	    IF(button.input.channel == 180) //LEDS ON
	    {
		ON[VDV_TP_GENERAL, 181]
		ON[VDV_TP_GENERAL, 180]
		
		ON[relay, 1]
		ON[relay, 2]
	    }
	    
	    IF(button.input.channel == 181) //LEDS OFF
	    {
		OFF[VDV_TP_GENERAL, 180]
		OFF[VDV_TP_GENERAL, 181]
		
		OFF[relay, 1]
		OFF[relay, 2]
	    }
	    
	    IF(button.input.channel == 190) //SYSTEM OFF
	    {
		
		OFF[VDV_TP_GENERAL, 19]
		OFF[VDV_TP_GENERAL, 190]
		
		WAIT 3
		
		//TV OFF
		send_string DV_TV, "'ka',$20,'1',$20,'00',$0D"
		
		//AVR OFF
		IP_CLIENT_OPEN (DV_AVR.PORT,AVR_IP, 23, 1)//ip degistir
		    WAIT 3
		    send_string DV_AVR,"'PWSTANDBY',$0D"
		    WAIT 5
		IP_CLIENT_CLOSE (DV_AVR.PORT)
		
		WAIT 5
		
		//DVD + DIGITURK OFF
		SET_PULSE_TIME (7)
		pulse[DV_DVD, 2]
		WAIT 5
		pulse[DV_Digiturk, 1]
		SET_PULSE_TIME (5)
		
	    }
	}
	
    }

    //AVR BUTTONS
    button_event[VDV_TP_AVR_TCP, 0] //CHANNEL PORT: 10
    {
	push:
	{
	    ON[VDV_TP_AVR_TCP, button.input.channel] //BUTTON --> ON State
	    
	    IF(button.input.channel == 1) //UP
	    {
		IP_CLIENT_OPEN (DV_AVR.PORT,AVR_IP, 23, 1)//ip degistir
		    WAIT 3
		    send_string DV_AVR,"'MNCUP',$0D"
		    WAIT 5
		IP_CLIENT_CLOSE (DV_AVR.PORT)
	    }
	    
	    IF(button.input.channel == 2) //RIGHT
	    {
		IP_CLIENT_OPEN (DV_AVR.PORT,AVR_IP, 23, 1)//ip degistir
		    WAIT 3
		    send_string DV_AVR,"'MNCRT',$0D" 
		    WAIT 5
		IP_CLIENT_CLOSE (DV_AVR.PORT)
	    }
	    
	    IF(button.input.channel == 3) //DOWN
	    {
		IP_CLIENT_OPEN (DV_AVR.PORT,AVR_IP, 23, 1)//ip degistir
		    WAIT 3
		    send_string DV_AVR,"'MNCDN',$0D"
		    WAIT 5
		IP_CLIENT_CLOSE (DV_AVR.PORT)
	    }
	    
	    IF(button.input.channel == 4) //LEFT
	    {
		IP_CLIENT_OPEN (DV_AVR.PORT,AVR_IP, 23, 1)//ip degistir
		    WAIT 3
		    send_string DV_AVR,"'MNCLT',$0D"
		    WAIT 5
		IP_CLIENT_CLOSE (DV_AVR.PORT)
	    }
	    
	    IF(button.input.channel == 5) //ENTER
	    {
		IP_CLIENT_OPEN (DV_AVR.PORT,AVR_IP, 23, 1)//ip degistir
		    WAIT 3
		    send_string DV_AVR,"'MNENT',$0D"
		    WAIT 5
		IP_CLIENT_CLOSE (DV_AVR.PORT)
	    }
	    
	    IF(button.input.channel == 6) //OPTIONS
	    {
		IP_CLIENT_OPEN (DV_AVR.PORT,AVR_IP, 23, 1)//ip degistir
		    WAIT 3
		    send_string DV_AVR,"'MNOPT',$0D"
		    WAIT 5
		IP_CLIENT_CLOSE (DV_AVR.PORT)
	    }
	    
	    IF(button.input.channel == 7) //SETUP
	    {
		IP_CLIENT_OPEN (DV_AVR.PORT,AVR_IP, 23, 1)//ip degistir
		    WAIT 3
		    send_string DV_AVR,"'MNMEN ON',$0D"
		    WAIT 5
		IP_CLIENT_CLOSE (DV_AVR.PORT)
	    }
	    
	    IF(button.input.channel == 8) //INFO
	    {
		IP_CLIENT_OPEN (DV_AVR.PORT,AVR_IP, 23, 1)//ip degistir
		    WAIT 3
		    send_string DV_AVR,"'MNINF',$0D"
		    WAIT 5
		IP_CLIENT_CLOSE (DV_AVR.PORT)
	    }
	    
	    IF(button.input.channel == 9) //RETURN
	    {
		IP_CLIENT_OPEN (DV_AVR.PORT,AVR_IP, 23, 1)//ip degistir
		    WAIT 3
		    send_string DV_AVR,"'MNRTN',$0D"
		    WAIT 5
		IP_CLIENT_CLOSE (DV_AVR.PORT)
	    }
	    
	    IF(button.input.channel == 20) //MOVIE MODE
	    {
		IP_CLIENT_OPEN (DV_AVR.PORT,AVR_IP, 23, 1)//ip degistir
		    WAIT 3
		    send_string DV_AVR,"'MSMOVIE',$0D"
		    WAIT 5
		IP_CLIENT_CLOSE (DV_AVR.PORT)
	    }
	    
	    IF(button.input.channel == 21) //MUSIC MODE
	    {
		IP_CLIENT_OPEN (DV_AVR.PORT,AVR_IP, 23, 1)//ip degistir
		    WAIT 3
		    send_string DV_AVR,"'MSMUSIC',$0D"
		    WAIT 5
		IP_CLIENT_CLOSE (DV_AVR.PORT)
	    }
	    
	    IF(button.input.channel == 22) //GAME MODE
	    {
		IP_CLIENT_OPEN (DV_AVR.PORT,AVR_IP, 23, 1)//ip degistir
		    WAIT 3
		    send_string DV_AVR,"'MSGAME',$0D"
		    WAIT 5
		IP_CLIENT_CLOSE (DV_AVR.PORT)
	    }
	    
	    IF(button.input.channel == 23) //PURE MODE
	    {
		IP_CLIENT_OPEN (DV_AVR.PORT,AVR_IP, 23, 1)//ip degistir
		    WAIT 3
		    send_string DV_AVR,"'MSPURE DIRECT',$0D"
		    WAIT 5
		IP_CLIENT_CLOSE (DV_AVR.PORT)
	    }
	    
	    IF(button.input.channel == 24) //TV
	    {
		IP_CLIENT_OPEN (DV_AVR.PORT,AVR_IP, 23, 1)//ip degistir
		    WAIT 3
		    send_string DV_AVR,"'SITV',$0D"
		    WAIT 5
		IP_CLIENT_CLOSE (DV_AVR.PORT)
	    }
	    
	    IF(button.input.channel == 25) //GAME
	    {
		IP_CLIENT_OPEN (DV_AVR.PORT,AVR_IP, 23, 1)//ip degistir
		    WAIT 3
		    send_string DV_AVR,"'SIGAME',$0D"
		    WAIT 5
		IP_CLIENT_CLOSE (DV_AVR.PORT)
	    }
	    
	    IF(button.input.channel == 26) //APPLE TV
	    {
		IP_CLIENT_OPEN (DV_AVR.PORT,AVR_IP, 23, 1)//ip degistir
		    WAIT 3
		    send_string DV_AVR,"'SIMPLAY',$0D"
		    WAIT 5
		IP_CLIENT_CLOSE (DV_AVR.PORT)
	    }
	    
	    IF(button.input.channel == 27) //DVD
	    {
		IP_CLIENT_OPEN (DV_AVR.PORT,AVR_IP, 23, 1)//ip degistir
		    WAIT 3
		    send_string DV_AVR,"'SIBD',$0D"
		    WAIT 5
		IP_CLIENT_CLOSE (DV_AVR.PORT)
	    }
	    
	    IF(button.input.channel == 28) //AUX
	    {
		IP_CLIENT_OPEN (DV_AVR.PORT,AVR_IP, 23, 1)//ip degistir
		    WAIT 3
		    send_string DV_AVR,"'SIAUX1',$0D"
		    WAIT 5
		IP_CLIENT_CLOSE (DV_AVR.PORT)
	    }
	    
	    IF(button.input.channel == 30) //BLUETOOTH
	    {
		IP_CLIENT_OPEN (DV_AVR.PORT,AVR_IP, 23, 1)//ip degistir
		    WAIT 3
		    send_string DV_AVR,"'SIBT',$0D"
		    WAIT 5
		IP_CLIENT_CLOSE (DV_AVR.PORT)
	    }
	    
	}
    }
    
    //SWITCH TO AVR(TV)
    button_event[VDV_TP_AVR_TCP, 32] //CHANNEL PORT: 10
    {
	push:
	{
	    IF(avr_switch_var == 0)
	    {
		//SWITCH CODE
		send_string DV_TV, "'xb',$20,'1',$20,'91',$0D"
		
		//STATE CHANGE
		ON[VDV_TP_AVR_TCP, 32]
		
		//VARIABLE CHANGE
		avr_switch_var = 1
	    }
	    ELSE IF(avr_switch_var == 1)
	    {
		//STATE CHANGE
		OFF[VDV_TP_AVR_TCP, 32]
		
		//VARIABLE CHANGE
		avr_switch_var = 0
	    }
	}
    }
    
    //MUTE
    button_event[VDV_TP_AVR_TCP, 12] //CHANNEL PORT: 10
    {
	push:
	{
	    IF(mute_var == 0) //NOT MUTE - OFF STATE
	    {
		//MUTE CODE
		IP_CLIENT_OPEN (DV_AVR.PORT,AVR_IP, 23, 1)//ip degistir
		    WAIT 3
		    send_string DV_AVR,"'MUON',$0D"
		    WAIT 5
		IP_CLIENT_CLOSE (DV_AVR.PORT)
		
		//STATE CHANGE
		ON[VDV_TP_AVR_TCP, 12]
		
		//VARIABLE CHANGE
		mute_var = 1
	    }
	    ELSE IF(mute_var == 1) //MUTE ON - ON STATE
	    {
		//UNMUTE CODE
		IP_CLIENT_OPEN (DV_AVR.PORT,AVR_IP, 23, 1)//ip degistir
		    WAIT 3
		    send_string DV_AVR,"'MUOFF',$0D"
		    WAIT 5
		IP_CLIENT_CLOSE (DV_AVR.PORT)
		
		//STATE CHANGE
		OFF[VDV_TP_AVR_TCP, 12]
		
		//VARIABLE CHANGE
		mute_var = 0
	    }
	    
	}
    }
    
    //AVR VOLUME -
    button_event[VDV_TP_AVR_TCP, 10] //CHANNEL PORT: 10
    {
	push:
	{
	    ON[VDV_TP_LGTV_RS, button.input.channel] //BUTTON --> ON State
	    
	    WAIT 3
	    
	    //VOLUME - CODE
	    IP_CLIENT_OPEN (DV_AVR.PORT,AVR_IP, 23, 1)//ip degistir
		WAIT 3
		send_string DV_AVR,"'MVDOWN',$0D"
		WAIT 5
	    IP_CLIENT_CLOSE (DV_AVR.PORT)
	    
	    WAIT 5
		
	    //MUTE BUTTON STATE = OFF
	    OFF[VDV_TP_AVR_TCP, 12]
		
	    //MUTE VAR CHANGE
	    mute_var = 0
	    
	}
	hold[5, repeat]:
	{
	    //VOLUME - CODE
	    IP_CLIENT_OPEN (DV_AVR.PORT,AVR_IP, 23, 1)//ip degistir
		WAIT 3
		send_string DV_AVR,"'MVDOWN',$0D"
		WAIT 5
	    IP_CLIENT_CLOSE (DV_AVR.PORT)
	    
	    //MUTE BUTTON STATE = OFF
	    OFF[VDV_TP_AVR_TCP, 12]
		
	    //MUTE VAR CHANGE
	    mute_var = 0
	    
	}
    }
    
    //AVR VOLUME +
    button_event[VDV_TP_AVR_TCP, 11] //CHANNEL PORT: 10
    {
	push:
	{
	    ON[VDV_TP_LGTV_RS, button.input.channel] //BUTTON --> ON State
	    
	   WAIT 3 
	    
	    //VOLUME + CODE
	    IP_CLIENT_OPEN (DV_AVR.PORT,AVR_IP, 23, 1)//ip degistir
		WAIT 3
		send_string DV_AVR,"'MVUP',$0D"
		WAIT 5
	    IP_CLIENT_CLOSE (DV_AVR.PORT)
	    
	    WAIT 5
		
	    //MUTE BUTTON STATE = OFF
	    OFF[VDV_TP_AVR_TCP, 12]
		
	    //MUTE VAR CHANGE
	    mute_var = 0
	    
	}
	hold[5, repeat]:
	{
	    //VOLUME + CODE
	    IP_CLIENT_OPEN (DV_AVR.PORT,AVR_IP, 23, 1)//ip degistir
		WAIT 3
		send_string DV_AVR,"'MVUP',$0D"
		WAIT 5
	    IP_CLIENT_CLOSE (DV_AVR.PORT)
	    
	    WAIT 5
		
	    //MUTE BUTTON STATE = OFF
	    OFF[VDV_TP_AVR_TCP, 12]
		
	    //MUTE VAR CHANGE
	    mute_var = 0
	    
	}
    }

    //GAME+NETFLIX+YOUTUBE BUTTONS
    button_event[VDV_TP_LGTV_RS, 0] //CHANNEL PORT: 6
    {
	push:
	{
	    ON[VDV_TP_LGTV_RS, button.input.channel] //BUTTON --> ON State
	    
	    IF(button.input.channel == 1) //UP
	    {
		send_string DV_TV, "'mc',$20,'1',$20,'40',$0D"
	    }
	    
	    IF(button.input.channel == 2) //RIGHT
	    {
		send_string DV_TV, "'mc',$20,'1',$20,'06',$0D"
	    }
	    
	    IF(button.input.channel == 3) //DOWN
	    {
		send_string DV_TV, "'mc',$20,'1',$20,'41',$0D"
	    }
	    
	    IF(button.input.channel == 4) //LEFT
	    {
		send_string DV_TV, "'mc',$20,'1',$20,'07',$0D"
	    }
	    
	    //COMMON
	    IF(button.input.channel == 5) //OK
	    {
		send_string DV_TV, "'mc',$20,'1',$20,'44',$0D"
	    }
	    
	    IF(button.input.channel == 6) //HOME
	    {
		send_string DV_TV, "'mc',$20,'1',$20,'7C',$0D"
	    }
	    
	    IF(button.input.channel == 7) //BACK
	    {
		send_string DV_TV, "'mc',$20,'1',$20,'28',$0D"
	    }
	    
	}
    }
    
    //NUMERIC POPUP BUTTONS
    button_event[VDV_TP_LGTV_RS, 0] //CHANNEL PORT: 6
    {
	push:
	{
	    ON[VDV_TP_LGTV_RS, button.input.channel] //BUTTON --> ON State
	    
	    IF(button.input.channel == 11) //1
	    {
		send_string DV_TV, "'mc',$20,'1',$20,'11',$0D"
	    }
	    
	    IF(button.input.channel == 12) //2
	    {
		send_string DV_TV, "'mc',$20,'1',$20,'12',$0D"
	    }
	    
	    IF(button.input.channel == 13) //3
	    {
		send_string DV_TV, "'mc',$20,'1',$20,'13',$0D"
	    }
	    
	    IF(button.input.channel == 14) //4
	    {
		send_string DV_TV, "'mc',$20,'1',$20,'14',$0D"
	    }
	    
	    IF(button.input.channel == 15) //5
	    {
		send_string DV_TV, "'mc',$20,'1',$20,'15',$0D"
	    }
	    
	    IF(button.input.channel == 16) //6
	    {
		send_string DV_TV, "'mc',$20,'1',$20,'16',$0D"
	    }
	    
	    IF(button.input.channel == 17) //7
	    {
		send_string DV_TV, "'mc',$20,'1',$20,'17',$0D"
	    }
	    
	    IF(button.input.channel == 18) //8
	    {
		send_string DV_TV, "'mc',$20,'1',$20,'18',$0D"
	    }
	    
	    IF(button.input.channel == 19) //9
	    {
		send_string DV_TV, "'mc',$20,'1',$20,'19',$0D"
	    }
	    
	    IF(button.input.channel == 20) //0
	    {
		send_string DV_TV, "'mc',$20,'1',$20,'10',$0D"
	    }
	    
	}
    }
    
    //NUMERIC RETURN BUTTON
    button_event[VDV_TP_GENERAL, 1000] //CHANNEL PORT: 1
    {
	push:
	{
	    OFF[VDV_TP_GENERAL, 17] //NUMERIC POPOP BUTTON STATE OFF
	}
    }
    
    //TV BUTTONS
    button_event[VDV_TP_LGTV_RS, 0] //CHANNEL PORT: 6
    {
	push:
	{
	    ON[VDV_TP_LGTV_RS, button.input.channel] //BUTTON --> ON State
	    
	    IF(button.input.channel == 21) //DIGITURK
	    {
		send_string DV_TV, "'xb',$20,'1',$20,'93',$0D"
	    }
	    
	    IF(button.input.channel == 22) //AVR
	    {
		send_string DV_TV, "'xb',$20,'1',$20,'91',$0D"
	    }
	    
	    IF(button.input.channel == 23) //SETTINGS
	    {
		send_string DV_TV, "'mc',$20,'1',$20,'43',$0D"
	    }
	    
	    IF(button.input.channel == 24) //INPUTS
	    {
		send_string DV_TV, "'mc',$20,'1',$20,'0B',$0D"
	    }
	    
	    IF(button.input.channel == 25) //HDMI 1
	    {
		//TV INPUT CHANGE CODE
		send_string DV_TV, "'xb',$20,'1',$20,'90',$0D"
		
		//AVR SWITCH VAR CHANGE
		avr_switch_var = 0
		
		//AVR SWITCH STATE CHANGE
		OFF[VDV_TP_AVR_TCP, 32]
	    }
	    
	    IF(button.input.channel == 26) //HDMI 3
	    {
		//TV INPUT CHANGE CODE
		send_string DV_TV, "'xb',$20,'1',$20,'92',$0D"
		
		//AVR SWITCH VAR CHANGE
		avr_switch_var = 0
		
		//AVR SWITCH STATE CHANGE
		OFF[VDV_TP_AVR_TCP, 32]
	    }
	    
	}
    }
    
    
(********************************************************************
    /* CINEMA ROOM */ 
*********************************************************************)

    //RS232
    DATA_EVENT[DV_TV_CIN]
    {
	ONLINE:
	{
	    SEND_COMMAND DV_TV_CIN, 'SET BAUD 9600, N, 8, 1, 485 DISABLE'
	    SEND_COMMAND DV_TV_CIN, 'HSOFF'
	    SEND_COMMAND DV_TV_CIN, 'XOFF'
	}
    }
    
    //IR BUTTONS (DIGITURK+AVR+TV PLUS)
    button_event[VDV_TP_IR, 0] //CHANNEL PORT: 12
    {
	push:
	{
	    //DIGITURK CINEMA ROOM
	    IF((button.input.channel >= 301) and (button.input.channel <= 400))
	    {
		pulse[DV_Digiturk_CIN, button.input.channel-300]
	    }
	    //TV+
	    IF((button.input.channel >= 401) and (button.input.channel <= 500))
	    {
		pulse[DV_TV_Plus_CIN, button.input.channel-400]
	    }
	    //AVR (SONY)
	    IF((button.input.channel >= 501) and (button.input.channel <= 600))
	    {
		pulse[DV_AVR_CIN, button.input.channel-500]
	    }
	    
	}
    }
    
    //AVR MUTE
    
    //AVR VOLUME +
    
    //AVR VOLUME -
    
    
    //SIDE BAR BUTTONS
    button_event[VDV_TP_GENERAL, 0] //CHANNEL PORT: 1
    {
	push:
	{
	    ON[VDV_TP_GENERAL, button.input.channel] //BUTTON --> ON State
	    
	    WAKE_TV_CIN()
	    
	    IF(button.input.channel == 202) //DIGITURK
	    {
		IF(netflix_var_cin == 1 || youtube_var_cin == 1)
		{
		    //TV Input
		    send_string DV_TV_CIN, "'mc',$20,'1',$20,'0B',$0D" //inputs button
		    WAIT 3
		    send_string DV_TV_CIN, "'mc',$20,'1',$20,'44',$0D" //enter
		    
		    //AVR 
		    pulse[DV_AVR_CIN, 4]
		    
		    WAIT 5
		    
		    //Digiturk
		    pulse[DV_Digiturk_CIN, 38]
		    WAIT 7
		    pulse[DV_Digiturk_CIN, 39]
		    
		    WAIT 9
		    
		    netflix_var_cin = 0
		    youtube_var_cin = 0
		}
		ELSE
		{
		    //TV Input
		    send_string DV_TV_CIN, "'xb',$20,'1',$20,'90',$0D" 
		    
		    //AVR 
		    pulse[DV_AVR_CIN, 4] //degisim
		    
		    WAIT 3
		    
		    //Digiturk
		    pulse[DV_Digiturk_CIN, 38]
		    WAIT 5
		    pulse[DV_Digiturk_CIN, 39]
		}
	    }
	    
	    IF(button.input.channel == 203) //TV+
	    {
		IF(netflix_var_cin == 1 || youtube_var_cin == 1)
		{
		    //TV Input
		    send_string DV_TV_CIN, "'mc',$20,'1',$20,'0B',$0D" //inputs button
		    WAIT 3
		    send_string DV_TV_CIN, "'mc',$20,'1',$20,'44',$0D" //enter
		    
		    //AVR 
		    pulse[DV_AVR_CIN, 6] //degisim
		    
		    WAIT 5
		    
		    //TV+
		    pulse[DV_TV_Plus_CIN, 3]
		    
		    WAIT 7
		    
		    netflix_var_cin = 0
		    youtube_var_cin = 0
		}
		ELSE
		{
		    //TV Input
		    send_string DV_TV_CIN, "'xb',$20,'1',$20,'90',$0D"
		    
		    //AVR 
		    pulse[DV_AVR_CIN, 6] //degisim
		    
		    WAIT 3
		    
		    //TV+
		    pulse[DV_TV_Plus_CIN, 3]
		    
		}
	    }
	    
	    IF(button.input.channel == 204) //NETFLIX
	    {
		//TV Input
		send_string DV_TV_CIN, "'mc',$20,'1',$20,'7C',$0D" //home button
		WAIT 3
		send_string DV_TV_CIN, "'mc',$20,'1',$20,'44',$0D" //enter
		
		WAIT 5
		
		//AVR
		pulse[DV_AVR_CIN, 8] //degisim
		
		WAIT 7
		
		netflix_var_cin = 1
	    }
	    
	    IF(button.input.channel == 205) //YOUTUBE
	    {
		//TV Input
		send_string DV_TV_CIN, "'mc',$20,'1',$20,'7C',$0D" //home button
		WAIT 3
		send_string DV_TV_CIN, "'mc',$20,'1',$20,'06',$0D" //right button
		WAIT 5
		send_string DV_TV_CIN, "'mc',$20,'1',$20,'44',$0D" //enter
		
		WAIT 7
		
		//AVR
		pulse[DV_AVR_CIN, 8] //degisim
		
		WAIT 9
		
		youtube_var_cin = 1
	    }
	    
	    IF(button.input.channel == 206) //GAME
	    {
		IF(netflix_var_cin == 1 || youtube_var_cin == 1)
		{
		    //TV Input = AVR
		    send_string DV_TV_CIN, "'mc',$20,'1',$20,'0B',$0D" //inputs button
		    WAIT 3
		    send_string DV_TV_CIN, "'mc',$20,'1',$20,'44',$0D" //enter
		    
		    //AVR
		    pulse[DV_AVR_CIN, 9] //degisim
		    
		    WAIT 5
		    
		    netflix_var_cin = 0
		    youtube_var_cin = 0
		}
		ELSE 
		{
		    //TV Input
		    send_string DV_TV_CIN, "'xb',$20,'1',$20,'90',$0D"
		    
		    WAIT 3
		    
		    //AVR
		    pulse[DV_AVR_CIN, 9] //degisim
		}
	    }
	    
	}
    }
    
    //FOOTER BUTTONS
    button_event[VDV_TP_GENERAL, 0] //CHANNEL PORT: 1
    {
	push:
	{
	    ON[VDV_TP_GENERAL, button.input.channel] //BUTTON --> ON State
	    
	    IF(button.input.channel == 209) //TV ON
	    {
		WAKE_TV_CIN()
	    }
	    
	    IF(button.input.channel == 210) //TV OFF
	    {
		send_string DV_TV_CIN, "'ka',$20,'1',$20,'00',$0D"
	    }
	    
	    IF(button.input.channel == 211) //AVR ON
	    {
		pulse[DV_AVR_CIN, 1]
	    }
	    
	    IF(button.input.channel == 212) //AVR OFF
	    {
		pulse[DV_AVR_CIN, 2]
	    }
	    
	    IF(button.input.channel == 213) //TV SETTINGS
	    {
		send_string DV_TV_CIN, "'mc',$20,'1',$20,'43',$0D"
	    }
	    
	    IF(button.input.channel == 214) //NUMERIC 
	    {
		WAKE_TV_CIN()
	    }
	    
	}
    }
    
    //HOME BUTTONS
    button_event[VDV_TP_GENERAL, 0] //CHANNEL PORT: 1
    {
	push:
	{
	    ON[VDV_TP_GENERAL, button.input.channel] //BUTTON --> ON State
	    
	    IF(button.input.channel == 200) //SYSTEM ON
	    {
		ON[VDV_TP_GENERAL, 200]
		ON[VDV_TP_GENERAL, 201]
		
		WAIT 3
		
		//TV ON
		WAKE_TV_CIN()
		
		WAIT 5
		
		//AVR ON
		pulse[DV_AVR_CIN, 1]
	    }
	    
	    IF(button.input.channel == 201) //SYSTEM OFF
	    {
		OFF[VDV_TP_GENERAL, 201]
		OFF[VDV_TP_GENERAL, 200]
		
		WAIT 3
		
		//TV OFF
		send_string DV_TV_CIN, "'ka',$20,'1',$20,'00',$0D"
		
		WAIT 5
		
		//AVR OFF
		pulse[DV_AVR_CIN, 2]
	    }
	    
	}
    }
    
    //GAME+NETFLIX+YOUTUBE BUTTONS
    button_event[VDV_TP_LGTV_RS, 0] //CHANNEL PORT: 6
    {
	push:
	{
	    ON[VDV_TP_LGTV_RS, button.input.channel] //BUTTON --> ON State
	    
	    IF(button.input.channel == 50) //UP
	    {
		send_string DV_TV_CIN, "'mc',$20,'1',$20,'40',$0D"
	    }
	    
	    IF(button.input.channel == 53) //RIGHT
	    {
		send_string DV_TV_CIN, "'mc',$20,'1',$20,'06',$0D"
	    }
	    
	    IF(button.input.channel == 51) //DOWN
	    {
		send_string DV_TV_CIN, "'mc',$20,'1',$20,'41',$0D"
	    }
	    
	    IF(button.input.channel == 52) //LEFT
	    {
		send_string DV_TV_CIN, "'mc',$20,'1',$20,'07',$0D"
	    }
	    
	    IF(button.input.channel == 54) //OK
	    {
		send_string DV_TV_CIN, "'mc',$20,'1',$20,'44',$0D"
	    }
	    
	    IF(button.input.channel == 55) //HOME
	    {
		send_string DV_TV_CIN, "'mc',$20,'1',$20,'7C',$0D"
	    }
	    
	    IF(button.input.channel == 58) //BACK
	    {
		send_string DV_TV_CIN, "'mc',$20,'1',$20,'28',$0D"
	    }
	    
	}
    }
    
    //NUMERIC BUTTONS
    button_event[VDV_TP_LGTV_RS, 0] //CHANNEL PORT: 6
    {
	push:
	{
	    ON[VDV_TP_LGTV_RS, button.input.channel] //BUTTON --> ON State
	    
	    IF(button.input.channel == 59) //1
	    {
		send_string DV_TV_CIN, "'mc',$20,'1',$20,'11',$0D"
	    }
	    
	    IF(button.input.channel == 60) //2
	    {
		send_string DV_TV_CIN, "'mc',$20,'1',$20,'12',$0D"
	    }
	    
	    IF(button.input.channel == 61) //3
	    {
		send_string DV_TV_CIN, "'mc',$20,'1',$20,'13',$0D"
	    }
	    
	    IF(button.input.channel == 62) //4
	    {
		send_string DV_TV_CIN, "'mc',$20,'1',$20,'14',$0D"
	    }
	    
	    IF(button.input.channel == 63) //5
	    {
		send_string DV_TV_CIN, "'mc',$20,'1',$20,'15',$0D"
	    }
	    
	    IF(button.input.channel == 64) //6
	    {
		send_string DV_TV_CIN, "'mc',$20,'1',$20,'16',$0D"
	    }
	    
	    IF(button.input.channel == 65) //7
	    {
		send_string DV_TV_CIN, "'mc',$20,'1',$20,'17',$0D"
	    }
	    
	    IF(button.input.channel == 66) //8
	    {
		send_string DV_TV_CIN, "'mc',$20,'1',$20,'18',$0D"
	    }
	    
	    IF(button.input.channel == 67) //9
	    {
		send_string DV_TV_CIN, "'mc',$20,'1',$20,'19',$0D"
	    }
	    
	    IF(button.input.channel == 68) //0
	    {
		send_string DV_TV_CIN, "'mc',$20,'1',$20,'10',$0D"
	    }
	    
	}
    }
    
    //NUMERIC RETURN BUTTON
    button_event[VDV_TP_GENERAL, 2000] //CHANNEL PORT: 1
    {
	push:
	{
	    OFF[VDV_TP_GENERAL, 214] //NUMERIC POPOP BUTTON STATE OFF
	}
    }
    
    //TV BUTTONS
    button_event[VDV_TP_LGTV_RS, 0] //CHANNEL PORT: 6
    {
	push:
	{
	    ON[VDV_TP_LGTV_RS, button.input.channel] //BUTTON --> ON State
	    
	    IF(button.input.channel == 56) //SETTINGS
	    {
		send_string DV_TV_CIN, "'mc',$20,'1',$20,'43',$0D"
	    }
	    
	    IF(button.input.channel == 57) //INPUTS
	    {
		send_string DV_TV_CIN, "'mc',$20,'1',$20,'0B',$0D"
	    }
	    
	}
    }
    
(*****************************************************************)
(*                                                               *)
(*                      !!!! WARNING !!!!                        *)
(*                                                               *)
(* Due to differences in the underlying architecture of the      *)
(* X-Series masters, changing variables in the DEFINE_PROGRAM    *)
(* section of code can negatively impact program performance.    *)
(*                                                               *)
(* See “Differences in DEFINE_PROGRAM Program Execution” section *)
(* of the NX-Series Controllers WebConsole & Programming Guide   *)
(* for additional and alternate coding methodologies.            *)
(*****************************************************************)

DEFINE_PROGRAM

WAIT 600
//AVR POWER STATUS FEEDBACK
IP_CLIENT_OPEN (DV_AVR.PORT,AVR_IP, 23, 1)//ip degistir
    WAIT 3
    send_string DV_AVR,"'PW?',$0D"
    WAIT 5
IP_CLIENT_CLOSE (DV_AVR.PORT)



(*****************************************************************)
(*                       END OF PROGRAM                          *)
(*                                                               *)
(*         !!!  DO NOT PUT ANY CODE BELOW THIS COMMENT  !!!      *)
(*                                                               *)
(*****************************************************************)


