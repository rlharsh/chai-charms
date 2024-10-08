// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
#macro PXLUI_GAMESPEED game_get_speed(gamespeed_fps)
#macro PXLUI_EASE_SPEED 0.2

#macro PXLUI_NAV_PADDING 2
#macro PXLUI_DEFAULT_ID "0"
#macro PXLUI_DEFAULT_LAYER "PXLUI_LAYER"

#macro PXLUI_UI_W 1280
#macro PXLUI_UI_H 720

#macro PXLUI_DEPTH_BOTTOM -9000
#macro PXLUI_DEPTH_MIDDLE -9100
#macro PXLUI_DEPTH_TOP -9200

#macro PXLUI_DEBUG true

#macro PXLUI_UI_UP "up"
#macro PXLUI_UI_DOWN "down"
#macro PXLUI_UI_LEFT "left"
#macro PXLUI_UI_RIGHT "right"

#macro PXLUI_UI_BUTTON "shoot"

enum PXLUI_ORIENTATION{
	VERTICAL,
	HORIZONTAL
}

enum PXLUI_CURVES{
	linear,
	ease_in,
	ease_out,
	elastic_in,
	elastic_out
}

global.pxlui_theme = {
	minimal:{
		container: spr_pxlui_button,
		card: spr_pxlui_button,
		scrollview: spr_pxlui_button,
		slider: spr_pxlui_button,
		button: spr_pxlui_button,
		checkbox: spr_pxlui_checkbox,
		
		color:{
			base: #55f0ff,
			secondary: c_dkgray,
			rectangle: c_black,
			selection: #f566c4,
			
			text:{
				primary: c_white,
				secondary: c_ltgray
			}	
		},
		fonts:{
			text1: "fntMonogram_12",	 
			text2: "fntMonogram_24",
		},
	},
}

global.pxlui_settings = {
	theme: "minimal",

	
	ResW : 1280,
	ResH : 720,
}
	
	

