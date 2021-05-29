pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--picogolf 1.0
--by chris mingay
-- 29/07/2020 - 7820 - token saving
-- 30/07/2020 - 7606 - token saving
-- 31/07/2020 - 6384 - token saving
-- 31/07/2020 - 6482 - tree indexing
-- 31/07/2020 - 7152 - leaderboardish and app screen interface
-- 01/08/2020 - 7540 - start of putting interface and zoom
-- 01/08/2020 - 7796 - shoddy but ability to put
-- 02/08/2020 - 7710 - course -> hole and don't store data in nested tables
-- 02/08/2020 - 7713 - hole data as csv
-- 02/08/2020 - 7856 - an actual round of golf
-- 03/08/2020 - 7850 - use sprites on leaderboard, wind setting per hole
-- 03/08/2020 - 7823 - some token saving
-- 05/08/2020 - 7841 - green fringes, player and club data as csv
-- 05/08/2020 - 7893 - shot power indicator, fringe shot choices
-- 05/08/2020 - 8142 - lie affects shot power
-- 05/08/2020 - 8211 - nooooo (and can lie almost out of bounds)
-- 05/08/2020 - 7948 - more csv data and slight shot alterations
-- 05/08/2020 - 7354 - remove buggy :( but fix putting zoom
-- 06/08/2020 - 7443 - bottom bar gui, driver select gui, player skill
-- 06/08/2020 - 7249 - token saving
-- 09/08/2020 - 8030 - buggy reinstated, title screen, some other things
-- 10/08/2020 - 7717 - token saving
-- 11/08/2020 - 7836 - slight UX changes, music, and sound effects
-- 11/08/2020 - 8149 - Version 1.0 title screen animation, onscreen messages
-- 11/08/2020 - 8154 - Version 1.0.1 buggy exhaust when using Z key to accel
-- 11/08/2020 - ???? - fix message when taking lots of shots
-- 16/08/2020 - 8167 - prevent shot after ball putted and stop ball resting in mid air, perfect aim sfx
-- 16/08/2020 - 7693 - token saving
--
--  data
--
club_data="putter,0,30,0.4,0,35,wedge,1.13,60,0.4,0.004,34,9 iron,1.05,120,0.76,0.003,33,6 iron,1,150,1,0.003,33,3 iron,0.95,180,1.23,0.003,33,3 wood,0.8,210,1.4,0.001,32,driver,0.75,240,1.7,0.001,32"
fade_table_data="0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,2,2,2,2,2,2,1,1,1,0,0,0,0,0,0,3,3,3,3,3,3,1,1,1,0,0,0,0,0,0,4,4,4,2,2,2,2,2,1,1,0,0,0,0,0,5,5,5,5,5,1,1,1,1,1,0,0,0,0,0,6,6,13,13,13,13,5,5,5,5,1,1,1,0,0,7,6,6,6,6,13,13,13,5,5,5,1,1,0,0,8,8,8,8,2,2,2,2,2,2,0,0,0,0,0,9,9,9,4,4,4,4,4,4,5,5,0,0,0,0,10,10,9,9,9,4,4,4,5,5,5,5,0,0,0,11,11,11,3,3,3,3,3,3,3,0,0,0,0,0,12,12,12,12,12,3,3,1,1,1,1,1,1,0,0,13,13,13,5,5,5,5,1,1,1,1,1,0,0,0,14,14,14,13,4,4,2,2,2,2,2,1,1,0,0,15,15,6,13,13,13,5,5,5,5,5,1,1,0,0"
fairway_data="0b1111111100000000,0b1001001101101100,0b1100110011001100,0b11100111000110,0b1010010110100101"
hole_data="1031,256,384,9,11,3,5,0,1,20,.5,.8,1,0,0,.6,.26#1009,384,384,10,10,3,3,0,4,20,.01,.99,0,0,0,.05,.5,2,0,0,.5,.15#1004,550,256,8,10,3,3,0,0,0,.99,.8,0,1,0,.66,.33,6,0,0,.1,.1#1005,128,128,6,2,2,0,3,0,10,.9,.1,4,0,0,.2,.9#1045,384,256,5,10,1,4,0,3,25,.1,.1,0,0,0,.5,.5,1,0,0,.6,.5,0,1,1,.4,.7,2,0,0,.9,.8#1041,128,646,7,7,4,4,2,4,30,.3,.1,3,0,0,.7,.33,3,0,0,.7,.66,3,0,0,.9,.9#1063,256,256,8,1,3,3,2,1,25,.2,.3,0,0,0,.5,.8,2,0,0,.75,.7#1010,256,384,10,1,5,0,0,1,50,.35,.99,0,0,0,.5,.5,0,1,1,.5,.1,0,1,1,.5,.25#1023,256,512,8,1,7,2,1,5,20,.2,.1,1,0,0,.5,.15,2,0,0,.75,.25,0,0,0,.8,.4,0,1,1,.25,.45,0,0,0,.25,.5,0,1,1,.8,.6,1,0,0,.6,.8,1,0,0,.4,.9,0,0,0,.33,.8,0,0,0,.4,.9"
leaderboard_evening_data="0,128,128,9,34,128,34,14,31,128,32,14,26,128,29,14,17,128,24,14,0,128,15,14,64,128,128,10,90,128,90,9,86,128,87,9,81,128,84,9,72,128,79,9,55,128,70,9,102,128,128,2"
leaderboard_day_data="0,128,128,12, 96,128,96,3, 97,128,99,11, 100,128,103,3, 104,128,112,11, 113,128,128,3, 95,128,95,7, 92,128,92,7, 88,128,88,7, 80,128,80,7"
lie_data="1,1,1,1,1,1,1,1,.99,.98,.97,.96,.9,.8,1,.99,.98,.97,.96,.9,.8,1,.99,.98,.97,.96,.9,.8,.5,.9,.75,.65,.6,.3,.2,1,.7,.5,.45,.35,.2,.1,1,.7,.65,.55,.5,.3,.2"
player_data="player1,10,tiger,9.5,monty,9,alex,8,tubes,7,henry,6"

-- seed, width, height, fairway min, fairway max, fringe min, fringe max, 
-- max wind, max waterhazards, water size,
--		back x, back y, max bunkers, , suppress fairway, suppress rough
--[[
holes={
	"1031,256,384,9,11,3,5,0,1,20,.5,.8,1,0,0,.6,.26", -- Hole 1 par 3
	"1009,384,384,10,10,3,3,0,4,20,.01,.99,0,0,0,.05,.5,2,0,0,.5,.15", -- hole 2 par 4
	"1004,550,256,8,10,3,3,0,0,0,.99,.8,0,1,0,.66,.33,6,0,0,.1,.1", -- hole 3 par 5
	"1005,128,128,6,2,2,0,3,0,10,.9,.1,4,0,0,.2,.9", -- hole 4 par 3
	"1045,384,256,5,10,1,4,0,3,25,.1,.1,0,0,0,.5,.5,1,0,0,.6,.5,0,1,1,.4,.7,2,0,0,.9,.8", -- hole 5 par 4
	"1041,128,646,7,7,4,4,2,4,30,.3,.1,3,0,0,.7,.33,3,0,0,.7,.66,3,0,0,.9,.9", -- hole 6 par 5
	"1063,256,256,8,1,3,3,2,1,25,.2,.3,0,0,0,.5,.8,2,0,0,.75,.7", -- hole 7 par 3
	"1010,256,384,10,1,5,0,0,1,50,.35,.99,0,0,0,.5,.5,0,1,1,.5,.1,0,1,1,.5,.25", -- hole 8 par 4
	"1023,256,512,8,1,7,2,1,5,20,.2,.1,1,0,0,.5,.15,2,0,0,.75,.25,0,0,0,.8,.4,0,1,1,.25,.45,0,0,0,.25,.5,0,1,1,.8,.6,1,0,0,.6,.8,1,0,0,.4,.9,0,0,0,.33,.8,0,0,0,.4,.9" -- hole 9 par 5
}
]]--

--
-- inits
--

palt(0,false)
palt(14,true)

-- "consts"
club_putter,club_wedge,club_9_iron,club_6_iron,club_3_iron,club_3_wood,club_driver=1,2,3,4,5,6,7
lie_tee,lie_green,lie_fairway,lie_fringe,lie_rough,lie_bunker,lie_nearly_out_of_bounds,lie_water,lie_out_of_bounds,lie_hole=1,2,3,4,5,6,7,8,9,10
shot_mode_ready,shot_mode_power,shot_mode_aim,shot_mode_done=1,2,3,4
cam_mode_aim,cam_mode_shot,cam_mode_hole,cam_mode_pin=1,2,3,4

--[[
	lie_map is a 2d array relating to clubs and lies it determines the offset on shots
	lie_map[lie_X][club_x] = value between 0 and 1 indicating the range of power
	-- a value of 1 indicates a shot will be hit at 100% of the set power
	-- a value of 0.5 indicates a shot will be hit between 50% and 100% of the set power
]]
lie_map={}
fadetable_black={}

--
-- app settings
--

--app_screen_name=""
--app_next_init=nil
--app_next_update=nil
--app_next_draw=nil
--app_fade=0
app_fade_mode=2
app_timer=0

--update_func=nil
--draw_func=nil

--
-- play settings
--

-- game settings
-- TODO the below are probably not necessary, they always get set before use
--game_lie=lie_tee
--game_distance_to_pin=0
--game_aim_x,game_aim_y,game_aim_direction=0,0,0
--game_mode="aim"
--game_next_mode=nil
--game_fade=0

-- ball settings
ball_x,ball_y,ball_z,ball_r=0,0,0,.25
--ball_xs,ball_ys,ball_zs=0,0,0
--ball_shadow=0
--ball_start,ball_landing=nil,nil
--ball_carrying=false
--ball_carry=0
--ball_backspin=0
--ball_putted=false
--ball_ox,ball_oy,ball_oz=0,0,0

-- buggy settings

bug_x,bug_y,bug_z,bug_xs,bug_ys,bug_zs,bug_s,bug_d,bug_l,bug_exhaust_timer,bug_next_exhaust,bug_max_speed,bug_underwater=32,32,0,0,0,0,0,0,0,0,6,.6,false
bug_exhaust={}
bug_ripples={}


-- wind settings
--wind_d,wind_s,wind_xs,wind_ys,wind_multi,wind_max=0,0,0,0,0.0005,0
wind_multi=0.0005

clubs={}

-- title screen settings
--title_bg={
--	{0,128,128,12},
--	{96,128,128,3}
--}

-- leaderboard settings
leaderboard_colors,leaderboard_day_bg,leaderboard_evening_bg={11,3,1,9,8},{},{}

-- camera settings
cam_mode,cam_z=cam_mode_aim,2
--cam_x,cam_y,cam_z=64,64,2
--cam_x1,cam_y1,cam_x2,cam_y2=0,0,128,128
--cam_w,cam_h=128,128

--cam_zoom_out=false

-- used to translate drawing postion through the camera
--ct_x,ct_y,ct_r=0,0,0

-- course items
course_pars,course_name={3,4,5,3,4,5,3,4,5},"le strange open"
bunkers,fairways,greens,pin,rough,tee,trees,waterhazards={},{},{},{},{},{},{},{}

players={}

--
-- main logic
--

function _init()
	
	-- generate clubs
	data=split(club_data)
	for i=1,#data,6 do
		add(clubs,{name=data[i],elevation=data[i+1],range=data[i+2],power=data[i+3],backspin=data[i+4]})
	end

	-- generate players
	data=split(player_data)
	for i=1,#data,2 do
		p={
			name=data[i],
			skill=data[i+1],
			scores={0,0,0,0,0,0,0,0,0},
			shots=0,
			finished=false
		}
		add(players,p)
	end

	-- generate lie data
	data=split(lie_data)
	for i=1,#data,7 do
		d={}
		for j=0,6 do
			add(d,data[i+j])
		end
		add(lie_map,d)
	end

	-- generate fade table
	data=split(fade_table_data)
	for i=1,#data,15 do
		d={}
		for j=0,14 do
			add(d,data[i+j])
		end
		add(fadetable_black,d)
	end

	-- generate leaderboard background
	data=split(leaderboard_day_data)
	for i=1,#data,4 do
		d={}
		for j=0,3 do
			add(d,data[i+j])
		end
		add(leaderboard_day_bg,d)
	end

	data=split(leaderboard_evening_data)
	for i=1,#data,4 do
			d={}
			for j=0,3 do
				add(d,data[i+j])
			end
			add(leaderboard_evening_bg,d)
	end

	-- hole data
	if(holes==nil) holes=split(hole_data,"#")
	
	-- fairway patterns
	fairway_patterns=split(fairway_data)
	
	init_title()
	update_func,draw_func=update_title,draw_title
	
	app_fade=16
	hole_index=0

end

function goto_screen(screen)
	app_screen_name=screen
	app_fade_mode=3
	app_fade=0
	if(screen=="title")  app_next_init=init_title  app_next_update=update_title  app_next_draw=draw_title
	if(screen=="game")   app_next_init=init_game  app_next_update=update_game    app_next_draw=draw_game
	if(screen=="leaderboard")   app_next_init=init_leaderboard  app_next_update=update_leaderboard    app_next_draw=draw_leaderboard
end

function update_fade()

	if app_fade_mode==3 then
		fade_black(app_fade)
		app_fade+=1
		if app_fade>16 then
			app_fade_mode=2

			if(app_next_init!=nil) app_next_init()
			update_func = app_next_update
			draw_func = app_next_draw

		end
	elseif app_fade_mode==2 then
		if app_fade>0 then	
			app_fade-=1
		else
			app_fade_mode=1
		end
		fade_black(app_fade)
	end

end

-- kometbomb https://www.lexaloffle.com/bbs/?pid=35664
function fade_black(i)
	for c=0,15 do
		if flr(i+1)>=16 then
			pal(c,0)
		else
			pal(c,fadetable_black[c+1][flr(i+1)])
		end
	end
end

function _update60()

	app_timer+=1/60
	update_fade()
	update_func()

end

function _draw()
	cls(1)
	draw_func()
end

--
-- title logic
--

function init_title()
	music(8)
	title_ball_y=130
end

function update_title()

	if title_ball_y<128 then
		title_ball_y+=.25
		if(title_ball_y==16) goto_screen("leaderboard") 
		
	end

	if btnp(4) and title_ball_y==130 then 
		sfx(34)
		title_ball_y=-20
		music(-1)
	end

	


end

function draw_title()
	rectfill(0,0,128,64,12)
	rectfill(0,65,128,67,3)
	rectfill(0,66,128,128,11)
	sspr(0,64,58,38,0,58,58,38,false,false)
	sspr(0,64,58,38,70,58,58,38,true,false)
	ovalfill(80,84,105,89,9)
	ovalfill(81,85,104,88,10)
	spr(142,66,62)
	
	if(title_ball_y==130) ovalfill(5,121,45,123,3) sspr(64,64,42,42,5,81)
	palt(14,false)
	sspr(0,40,32,20,30,20)
	sspr(32,40,32,21,66,20)
	palt(14,true)
	spr(1,62,title_ball_y)
	if(title_ball_y<-18) cls(7)

end

--
-- game logic
--

function init_game()
	
	ball_landing=nil
	ball_resting=true
	ball_putted=false
	select_club()
	game_aim_x = ball_x+cos(game_aim_direction)*club.range
	game_aim_y = ball_y+sin(game_aim_direction)*club.range
	music(0,5000,3)
	game_mode="aim"
	putted_timer=0
	set_message("hole "..hole_index.." par "..course_pars[hole_index])
end

function update_game()

	if game_mode=="aim" or game_mode=="aim_putting" or game_mode=="putting" then update_aim()
	elseif game_mode=="drive" then update_buggy()
	elseif game_mode=="shot" then update_shot() end
	
	update_message()
	update_gui()

end

function draw_game()
	if game_mode=="aim" or game_mode=="drive" or game_mode=="putting" or game_mode=="aim_putting" then
		draw_hole()
	elseif game_mode=="shot" then
		draw_shot()
	end
	draw_gui()
	draw_message()
end

function init_leaderboard()
	
	music(hole_index<9 and (12+flr(rnd(8))) or 8,3000)
	sorted_players=sort_players(players)
	
end

function update_leaderboard()
	
	if hole_index<9 and app_fade_mode==1 then
		if(btnp(4)) then
			hole_index+=1
			music(-1,1000)
			generate_hole(hole_index)
			goto_screen("game")
		end
	end

end

function draw_leaderboard()

	if hole_index<9 or app_fade_mode==3 then
		for b in all(leaderboard_day_bg) do rectfill(0,unpack(b)) end
	else
		for b in all(leaderboard_evening_bg) do rectfill(0,unpack(b)) end

	end

	-- add up the course par
	course_par=0
	for p in all(course_pars) do course_par+=p end

	vs,hs,ox,oy,dx,dy=10,8,4,11,4,11

	rectfill(dx,dy,124,93,15)
	rect(dx,dy,124,93,4)
	line(dx,dy,124,dy,7)

	rectfill(dx+4,94,dx+8,101,5)
	rectfill(116,94,120,101,5)
	
	ox+=2
	oy+=2
	
	draw_box(ox,oy,122,oy+vs-2)
	dx=64-(#course_name * 4 * .5)
	print(course_name,dx,oy+2,1)

	dx=40
	dy=oy+10
	for i=1,9 do
		draw_box_spr(dx,dy)
		print(course_pars[i],dx+2,dy+2,1)
		dx+=hs
	end

	draw_box(dx,dy,dx+hs+2,dy+vs-2)	
	print(course_par,dx+2,dy+2,1)
	
	dy+=vs
	
	for p in all(sorted_players) do
		dx=ox
		
		draw_box(dx,dy,38,dy+vs-2)
		
		print(p.name,dx+2,dy+2,1)
		dx=40
		for i=1,9 do
		
		
			s=p.scores[i]
			draw_box_spr(dx,dy)
			c=clamp(s-course_pars[i],-2,2)
			--if(c>2) c=2
			--if(c<-2) c=-2
			if(s>0) print(s,dx+2,dy+2,leaderboard_colors[c+3])
			dx+=hs
			
		end
		
		draw_box(dx,dy,dx+hs+2,dy+vs-2)
		print(p.shots,dx+2,dy+2,1)
		dy+=vs
		
	end

	if(hole_index==9 and app_fade_mode<3) bprint("thanks for playing :)",40,117,7,0)
end

message_text=nil
message_timer=0
next_game_mode=nil
message_height=0
max_message_height=8
message_x=64
function update_message()
	if message_timer>0 then
		message_timer-=1
		if message_timer>30 then
			if (message_height<max_message_height) message_height+=0.5
		else
			if (message_height>0) message_height-=.5
		end
		message_x-=1
	else
		if(next_game_mode!=nil) game_mode=next_game_mode
		next_game_mode=nil
	end
end

function draw_message()
	if message_timer>0 then
		clip(0,32-message_height,128,message_height*2)
		rectfill(0,32-message_height,128,32+message_height,9)
		bprint(message_text,message_x,29,7,0)
		clip()
	end
end

function set_message(message,mode,timer)
	message_text=message
	message_timer=timer != nil and timer or 180
	next_game_mode=mode
	message_x=128
end

--[[
when a player finishes a hole we automatically set how many shots the other players took
this uses the provided skill level which can be between 0 and 10
a calculation determines if the player took -2 -1 0 +1 or +2 shots compared to the par for that hole
a highly skilled player is more likely to get a negative
]]--

function goto_leaderboard()

	par=course_pars[hole_index]
	for p in all(players) do

		if p.name=="player1" then
			p.scores[hole_index]=min(9,shots_this_hole)
		    p.shots+=min(9,shots_this_hole)
		else

			skill=p.skill/2
			skill+=rnd(skill)
			
			if skill>9 then
				shots=par-2
			elseif skill>7.5 then
				shots=par-1
			elseif skill>5 then
				shots=par
			elseif skill>3.5 then
				shots=par+1
			else
				shots=par+2
			end

			p.scores[hole_index]=shots
			p.shots+=shots

		end

	end
	sorted_players=sort_players(players)
	goto_screen("leaderboard")
end

function sort_players(players)
	output={}
	for i=0,81 do
		for p in all(players) do
			if(p.shots==i) add(output,p)
		end
	end
	return output
end

function draw_box_spr(x1,y1)
	 sspr(96,8,7,9,x1,y1)
end

function draw_box(x1,y1,x2,y2)
	rect(x1,y1,x2,y2,4)
	line(x1,y1,x1,y2,7)
	line(x1,y2,x2,y2,7)
end

function set_club(i)
	club_index=i
	club=clubs[club_index]
	target_power = (game_distance_to_pin / club.range)
	lie_chance = lie_map[game_lie][club_index]
	club_timer=180
	selected_club_x=0
end

function next_club()
	club_index%=7
	set_club(club_index+1)
end

function set_wind(s,d)
	--s,d=0,0
	wind_s,wind_d,wind_xs,wind_ys=s,d,cos(d/8)*s*wind_multi,sin(d/8)*s*wind_multi
end

aim_speed=0.001
function update_aim()

	if ball_resting then
		
		if(btn(0)) game_aim_direction+=aim_speed
		if(btn(1)) game_aim_direction-=aim_speed
		game_aim_x = ball_x+cos(game_aim_direction)*club.range
		game_aim_y = ball_y+sin(game_aim_direction)*club.range

		cam_zoom_out=btn(2)
		
		if(btnp(3) and game_mode!="putting") next_club()
		
		if(btnp(4) and not ball_putted) init_shot()
			
		if btnp(5) then
			cam_mode%=4
			cam_mode+=1
		end

	end
	
	update_ball()
	update_camera()

end

function draw_hole()

	if (cam_mode==cam_mode_hole or cam_mode==cam_mode_shot) and ball_resting then
		draw_hole_floor(true)
	else
		draw_hole_floor(false)
	
		draw_hole_trees()
		if(game_mode=="drive") draw_buggy()
		draw_ball()

		
		if ball_putted then
			translate(pin_x,pin_y,pin_r)
			circ(ct_x,ct_y,ct_r,0)
		end

		-- Draw the aim indicator
		if game_mode=="aim" then
			translate(game_aim_x,game_aim_y,1)
			spr(41,ct_x-1,ct_y-7)
		end
		
	end
	
end

function draw_buggy()

	fillp()                             
	for r in all(bug_ripples) do            
		zcirc(r[1],r[2],r[4],7)
	end                                 

	if bug_underwater then
		fillp(0b1010010110100101)
		zcircfill(bug_x,bug_y,3,28)
	else
		fillp()
		translate(bug_x,bug_y,1)
		for i=0,8 do
			rspr(
				i*8,
				32,
				ct_x-4,
				ct_y-4-i+bug_z*cam_z,
				bug_d,
				1
			)
		end
	end

	fillp()                                                
	for p in all(bug_exhaust) do                     
		if p[4]==99 then                               
			zcirc(p[1],p[2],1,7)
		else                       
			zcircfill(p[1],p[2],1,p[4])                    
	    end                                            
	end   
	
end
-- lie_tee,lie_green,lie_fairway,lie_fringe,lie_rough,lie_bunker,lie_nearly_out_of_bounds,lie_water,lie_out_of_bounds,lie_hole=1,2,3,4,5,6,7,8,9,10
bug_max_speeds={.6,.6,.6,.6,.3,.1,.2,.15,.2}
function update_buggy()

	for p in all(bug_exhaust) do                 
		p[2]-=0.1                          
		p[3]-=1                            
		if(p[3]<=0) del(bug_exhaust,p)           
	end                                        
                                           
	for r in all(bug_ripples) do                   
		r[4]+=0.05
		r[3]-=1                    
		if(r[3]<=0) del(bug_ripples,r)     
	end                                        


	if bug_exhaust_timer>0 then
		bug_exhaust_timer-=1
	else
		bug_exhaust_timer=5
		if bug_s>0 and (btn(2) or btn(4)) then
			px=bug_x-cos(bug_d)*2.5
			py=bug_y+sin(bug_d)*2.5
			add(bug_exhaust,{px,py-bug_z,15,bug_next_exhaust})
			if bug_underwater then
				bug_next_exhaust=99
				bug_exhaust_timer=15
			else
				bug_next_exhaust = bug_next_exhaust == 6 and 7 or 6
			end
		end
	end

	if(bug_s>bug_max_speed) bug_s*=0.99

	if btn(2) or btn(4) then
		sfx(bug_underwater and 31 or 30)
		if(bug_s<bug_max_speed) bug_s+=0.01
	else
		if bug_s>0 then
			bug_s-=btn(3) and 0.02 or 0.01
		else
			bug_s=0
		end
	end

	if(btn(0)) bug_d-=0.01
	if(btn(1)) bug_d+=0.01

	bug_xs=cos(bug_d)*bug_s
	bug_ys=0-sin(bug_d)*bug_s

	bug_x+=bug_xs
	bug_y+=bug_ys
	bug_z+=bug_zs
	
	if bug_z>=0 then
		bug_z=0
	else
		bug_zs+=0.1
	end

	bug_l=get_lie(bug_x,bug_y)
	bug_max_speed=bug_max_speeds[bug_l]

	if bug_l==lie_water then
		if bug_s>=bug_max_speed then
			bug_s*=0.96
		end

		if bug_s<bug_max_speed then
			if(not bug_underwater) sfx(33)
			bug_underwater=true
		else
			if not bug_underwater and bug_z>=0 then
				sfx(32)
				bug_z=0
				bug_zs=-.5
				add(bug_ripples,{bug_x,bug_y,45,2})
			end
		end
	else
		if(bug_underwater) bug_zs=-1 sfx(33)
		bug_underwater=false
		
	end
	
	if dbp(bug_x,bug_y,ball_x,ball_y)<35 and abs(bug_xs)<0.01 and abs(bug_ys)<0.01 then
		select_club()
		game_mode=club.name=="putter" and "putting" or "aim"
	end

	update_camera()
	
end

function generate_hole(hi)

	--par=course_pars[hi]
	shots_this_hole=0


	data=split(holes[hi])

	dims_x,dims_y=data[2],data[3]
	fairway_min,fairway_max,fringe_min,fringe_max=data[4],data[5],data[6],data[7]
	
	hole_x1=dims_x
	hole_y1=dims_y
	hole_x2=0
	hole_y2=0

	backbone={}

	wind_max=data[8]
	
	if(data[1]!="") srand(data[1])

	for di=11,#data,5 do
		add(backbone,{
			x=data[di]*data[2],
			y=data[di+1]*data[3],
			bunker_count=data[di+2],
			suppress_fairway=data[di+3]==1,
			suppress_rough=data[di+4]==1
		})
	end
	
	-- generate the hole items
	bunkers,fairways,greens,pin,rough,tee,trees,waterhazards={},{},{},{},{},{},{},{}

	for i=1,#backbone-1 do
	
		fairway={}
	
		p1=backbone[i]
		p2=backbone[i+1]
		
		dx=p2.x-p1.x
		dy=p2.y-p1.y

		hole_x1=min(p1.x,hole_x1)
		hole_x2=max(p1.x,hole_x2)
		hole_y1=min(p1.y,hole_y1)
		hole_y2=max(p1.y,hole_y2)

		hole_x1=min(p2.x,hole_x1)
		hole_x2=max(p2.x,hole_x2)
		hole_y1=min(p2.y,hole_y1)
		hole_y2=max(p2.y,hole_y2)
		
		steps=ceil(dbp(0,0,dx,dy)/10)
		
		pd=atan2(dx,dy)
		p=1
		
		for pdd=0.0625,1.0625,0.125 do
			if(pdd>=pd) break
			--p+=(p>4 and -4 or 1)
			
			p%=4
			p+=1
		end
		
		sx=dx/steps
		sy=dy/steps
		for j=1,steps do
			tx=p1.x+sx*j
			ty=p1.y+sy*j
			--f={x=tx,y=ty,p=p,pd=pd,r=fairway_min+rnd(fairway_max)}
			f={x=tx,y=ty,p=p,r=fairway_min+rnd(fairway_max)}
			if(not p1.suppress_fairway) add(fairway,f)
			if(fringe_min>0 and not p1.suppress_rough)add(rough,{x=tx,y=ty,r=f.r+fringe_min+rnd(fringe_max)})
		end
		
		add(fairways,fairway)
		
		if not p1.suppress_fairway and p1.bunker_count>0 then
			for j=1,p1.bunker_count do
				fi=ceil(rnd(steps))
				
				f=fairway[fi]
				di=atan2(dx,dy)+(rnd()<.5 and .25 or -.25)
				
				bx=f.x+cos(di)*f.r
				by=f.y+sin(di)*f.r
				br=4+rnd(6)
				
				bunker_part_count=2
				for k=1,bunker_part_count do
					add(bunkers,{x=bx,y=by,r=br+rnd(br/2)})
				end
				
			end
		end
		
	end

	p1=backbone[1]

	-- tee
	tee_x1,tee_y1,tee_x2,tee_y2=p1.x-6,p1.y-4,p1.x+6,p1.y+4
	
	--ball
	ball_x,ball_y,ball_z=p1.x,p1.y,0
	
	-- buggy
	bug_x,bug_y=ball_x,ball_y

	-- greens
	p1=backbone[#backbone]
	add(greens,{x=p1.x,y=p1.y,r=5})
	for i=1,3 do
		r=10+rnd(5)
		x=p1.x-r+rnd(r*2)
		y=p1.y-r+rnd(r*2)
		
		add(fairways[#fairways],{x=x,y=y,r=r+3,p=5})
		add(greens,{x=x,y=y,r=r})		
	end

	-- pin
	-- select a green region and
	-- plonk it in the middle
	good_pin=false
	while not good_pin do
		g=rnd(greens)
		obstacle = false
		for b in all(bunkers) do
			if pic(g.x,g.y,b.x,b.y,b.r+5) then
				obstacle=true
			end
		end
		if not obstacle then
			pin_x=g.x
			pin_y=g.y
			pin_r=.5
			good_pin = true
		else
			del(bunkers,bunkers[#bunkers])
		end
	end
	
	-- waterhazards
	for i=1,data[9] do
		add(waterhazards,{x=hole_x1+rnd(hole_x2-hole_x1),y=hole_y1+rnd(hole_y2-hole_y1),r=data[10]+rnd(data[10])})
	end

	-- trees
	ty=0
	while ty<dims_y do
		tree_row={}
		tx=0
		while tx<dims_x do
			--ox=0
			--if(ty%16==8) ox=5
			--ox = ty%16==8 and 5 or 0
			
			ax=tx+(ty%16==8 and 5 or 0)
			
			if(get_lie(ax,ty)==lie_out_of_bounds and rnd()<.7) add(tree_row,{x=ax,y=ty})

			-- before 7861

			--[[
			obstacle=false

			for r in all(rough) do
				if(pic(ax,ty,r.x,r.y,r.r+5)) obstacle=true
			end

			for fairway in all(fairways) do
				for f in all(fairway) do
					if(pic(ax,ty,f.x,f.y,f.r+5)) obstacle=true
				end
			end
			
			for g in all(greens) do
				if(pic(ax,ty,g.x,g.y,g.r)) obstacle=true
			end
			
			for w in all(waterhazards) do
				if(pic(ax,ty,w.x,w.y,w.r)) obstacle=true
			end
			
			for b in all(bunkers) do
				if(pic(ax,ty,b.x,b.y,b.r+5)) obstacle=true
			end
			
			if(not obstacle and rnd()<.7) add(tree_row,{x=ax,y=ty})
			]]--
			
			tx+=10
				
		end
		trees[ty]=tree_row
		ty+=8
	end

	
	
	
	
	set_cam_pos(ball_x,ball_y)
	set_wind(ceil(wind_max),flr(rnd(8)))
	game_distance_to_pin = flr(dbp(ball_x,ball_y,pin_x,pin_y))
	game_aim_direction = atan2(pin_x-ball_x,pin_y-ball_y)
	select_club()


end

function get_lie(x,y)

	if(pir(x,y,tee_x1,tee_y1,tee_x2,tee_y2)) return lie_tee
	
	for b in all(bunkers) do
		if(pic(x,y,b.x,b.y,b.r+1)) return lie_bunker
	end
	
	for g in all(greens) do
		if(pic(x,y,g.x,g.y,g.r)) return lie_green
	end
	
	on_fringe=false
	on_fairway=false
	for fairway in all(fairways) do
		for f in all(fairway) do
			if pic(x,y,f.x,f.y,f.r) then
				if(f.p==5) on_fringe=true
				on_fairway=true
			end
		end
		
	end
	if(on_fairway) return on_fringe and lie_fringe or lie_fairway

	closest_rough=32000
	for r in all(rough) do
		rd=dbp(r.x,r.y,x,y)
		if(rd<r.r) return lie_rough
		if(rd-r.r<closest_rough)closest_rough=rd-r.r
	end
	
	for w in all(waterhazards) do
		if(pic(x,y,w.x,w.y,w.r)) return lie_water
	end
	
	if(closest_rough<10)return lie_nearly_out_of_bounds

	return lie_out_of_bounds

end

function hit_ball(power,aim,backspin)

	shots_this_hole+=1
	cam_mode=cam_mode_aim

	--power=1
	--aim=0
	
	--aim=abs(aim)
	
	set_cam_pos(ball_x,ball_y)

	if(power>1) power=1-(power-1)
	last_shot_power=lie_chance+rnd(1-lie_chance)
	--power*=last_shot_power
	power*=last_shot_power*club.power
	
	aim = game_aim_direction - aim*0.5+rnd(aim)

	ball_start={x=ball_x,y=ball_y}
	ball_landing=nil
	ball_backspin = backspin

	ball_xs=cos(aim)*power
	ball_ys=sin(aim)*power
	ball_zs=club.elevation
	ball_z=0
	ball_carry_distance=0
	ball_resting=false
	if(ball_zs>0) ball_carrying=true

	if club_index==club_putter then
		--sfx(28)
	else
		if last_shot_power>.95 then
			sfx(21)
		elseif last_shot_power>.80 then
			sfx(22)
		else
			sfx(23)
		end
	end
	
end

putted_timer=0
function update_ball()

	
	if ball_putted then

		if(ball_x<pin_x-.1) ball_x+=.05
		if(ball_x>pin_x+.1) ball_x-=.05
		if(ball_y<pin_y-.1) ball_y+=.05
		if(ball_y>pin_y+.1) ball_y-=.05

		putted_timer+=1
		if putted_timer==180 then
			goto_leaderboard()
		end
	end
	
	
	if(ball_resting) return

	-- record old position
	ball_ox,ball_oy,ball_oz=ball_x,ball_y,ball_z

	ball_x+=ball_xs
	ball_y+=ball_ys
	ball_z+=ball_zs

	drag=1-ball_backspin

	ball_xs*=drag
	ball_ys*=drag

	if ball_z>10 then
		ball_xs += wind_xs
		ball_ys += wind_ys
	end

	ball_zs-=0.01

	-- if the ball has hit the floor
	if ball_z<=0 then

		

		ball_z=0
		game_lie=get_lie(ball_x,ball_y)

		if ball_carrying then
			ball_carrying=false
			ball_landing={x=ball_x,y=ball_y}
			ball_carry_distance=flr(dbp(ball_start.x,ball_start.y,ball_landing.x,ball_landing.y))
		end

		-- if the ball hits the floor with enough speed
		-- we perform a bounce
		if ball_zs<0-0.1 then

			sm=1

			if game_lie==lie_fairway or game_lie==lie_green or game_lie==lie_tee or game_lie==lie_fringe then

				sfx(24)
				ball_zs=0-(ball_zs*.5)
				sm=0.4

			elseif game_lie==lie_rough then

				sfx(27)
				ball_zs=0-(ball_zs*.25)
				sm=0.2

			elseif game_lie==lie_bunker then

				sfx(25)
				ball_zs=0-(ball_zs*.1)
				sm=0.2

			elseif game_lie==lie_bunker or game_lie==lie_out_of_bounds or game_lie==lie_nearly_out_of_bounds then

				sfx(25)
				ball_zs=0-(ball_zs*.2)
				sm=0.3

			elseif game_lie==lie_water then

				sfx(20)
				sm=0
				ball_zs=0
				

			end

			ball_xs*=sm
			ball_ys*=sm

			drag=1-ball_backspin*10
			ball_xs*=drag
			ball_ys*=drag

		-- the ball has not hit the floor with enough speed
		-- so we roll
		else

			ball_zs = 0
			sm=1

			if game_lie==lie_green or game_lie==lie_tee then
				sm=0.99
			elseif game_lie==lie_fairway or game_lie==lie_fringe then
				sm=0.98
			elseif game_lie==lie_rough then
				sm=0.93
			elseif game_lie==lie_bunker or game_lie==lie_nearly_out_of_bounds or game_lie==lie_out_of_bounds then
				sfx(25)
				sm=0.04
			elseif game_lie==lie_water then
				sfx(20)
				sm=0
			end

			ball_xs*=sm
			ball_ys*=sm

		end

	end

	if ball_putted==false and ball_z==0 then

		-- current ball speed
		bspd=dbp(0,0,ball_xs,ball_ys)
		-- distance from pin
		bdis=dbp(ball_x,ball_y,pin_x,pin_y)
		-- previous distance from pin
		odis=dbp(ball_ox,ball_oy,pin_x,pin_y)
		-- current ball direction
		bdir=atan2(0,0,ball_xs,ball_ys)
	
		-- if the ball hits the pin
		if bdis<ball_r+pin_r*.1 and bdis<odis then
			-- if the speed is too quick
			-- ricochet
			--if bspd>0.1 then
				-- todo maybe reinstate
				--if club_index!=club_putter then
				--	ndir=rnd()
				--	diff=abs(bdir-ndir)
				--	hdiff=(1+diff)/2
				--	nspd=bspd*hdiff
				--	ball_xs=cos(ndir)*nspd
				--	ball_ys=sin(ndir)*nspd
				--end
			-- else its putted
			--else
			if bspd<=0.1 then
				ball_xs=0
				ball_ys=0
				ball_putted=true
				ball_resting=true
				game_mode="aim_putting"
				music(-1,1500)
				sfx(26)

				if shots_this_hole == 1 then
					set_message("hole in one!")
				else
					score=shots_this_hole-course_pars[hole_index]
					if(score==-3) set_message("albatross!!")
					if(score==-2) set_message("eagle!")
					if(score==-1) set_message("birdie")
					if(score==0) set_message("par")
					if(score==1) set_message("bogey")
					if(score==2) set_message("double bogey")
					if(score>2) set_message("oof "..shots_this_hole.." shots")
				end
				
			end
		-- if the ball is hovering
		-- over the edge
		-- we pull the ball in
		elseif bdis<pin_r+ball_r*.2 then
		
			if ball_x>pin_x then
				ball_xs-=0.01
			elseif ball_x<pin_x then
				ball_xs+=0.01
			end
			
			if ball_y>pin_y then
				ball_ys-=0.01
			elseif ball_y<pin_y then
				ball_ys+=0.01
			end
		end

	end


	-- if the ball has stopped
	if abs(ball_xs)<0.01 and abs(ball_ys)<0.01 and abs(ball_zs)<0.01 and ball_z==0 and not ball_putted then
	--if dbp(0,0,ball_xs,ball_ys)<0.0001 and ball_z<=0 and abs(ball_zs)<0.01 then
		ball_xs=0
		ball_ys=0
		ball_zs=0
		ball_resting=true
		ball_landing=nil
		select_club()
	end


end

function select_club()
	game_lie=get_lie(ball_x,ball_y)
	d = flr(dbp(ball_x,ball_y,pin_x,pin_y))
	game_distance_to_pin = d
	
	if game_lie==lie_tee or game_lie==lie_fairway then
		if d>230 then set_club(club_driver)
		elseif d>200 then set_club(club_3_wood)
		elseif d>170 then set_club(club_3_iron)
		elseif d>140 then set_club(club_6_iron)
		elseif d>70 then set_club(club_9_iron)
		else set_club(club_wedge) end
		game_mode="aim"
	elseif game_lie==lie_green or game_lie==lie_fringe then
		set_club(club_putter)
		game_mode="putting"
	elseif game_lie==lie_rough or game_lie==lie_nearly_out_of_bounds then
		if d>170 then set_club(club_3_iron)
		elseif d>140 then set_club(club_6_iron)
		elseif d>110 then set_club(club_9_iron)
		else set_club(club_wedge) end
		game_mode="aim"
	elseif game_lie==lie_bunker then
		set_club(club_wedge)
		game_mode="aim"
	elseif game_lie==lie_out_of_bounds then
		ball_x=ball_start.x
		ball_y=ball_start.y
		shots_this_hole+=1	
		select_club()	
		set_message("penalty stroke")
	elseif game_lie==lie_water then
		ball_x=ball_start.x
		ball_y=ball_start.y
		select_club()
		shots_this_hole+=1
		set_message("penalty stroke")
	end

	-- if the buggy isn't close to the ball go into drive mode, else go straight into aim
	if(game_mode!="drive" and dbp(ball_x,ball_y,bug_x,bug_y)>50) game_mode="drive" club_timer=0
	--game_lie=get_lie(ball_x,ball_y)
	set_wind(ceil(rnd(wind_max)),flr(rnd(8)))
	game_aim_direction = atan2(pin_x-ball_x,pin_y-ball_y)
end

function draw_ball()

	if(ball_landing!=nil)zpset(ball_landing.x,ball_landing.y,8)
		

	sx,sy,sw,sh,dw,dh=8,0,8,8,8,8
	if ball_z<5 then
		if(cam_z>3) sx=16
	elseif ball_z<20 then
		sx=16
	else

		bt=app_timer%.2
		if bt<.05 then
			sx=24
		elseif bt<.1 then
			sx=32
		elseif bt<.15 then
			sx=40
		else
			sx=48
		end

	end

	translate(ball_x,ball_y,0)

	-- if the ball is in the air
	-- we draw a shadow
	if ball_z > 0 then

		shy = ct_y + (ball_z/2) - 3
		shx = ct_x - (ball_z/2) - 3
		
		sspr(ball_shadow == 1 and 8 or 16, 8, 8, 8, shx, shy, 8, 8)
		ball_shadow = ball_shadow == 1 and 0 or 1

	end

	if ball_resting and game_mode=="putting" and not ball_putted then
		x2=ball_x+cos(game_aim_direction)*5
		y2=ball_y+sin(game_aim_direction)*5
		zline(ball_x,ball_y,x2,y2,8)
	end
	
	-- draw the ball
	sspr(
		sx,sy,
		sw,sh,
		ct_x-3,
		ct_y-3,
		dw,
		dh
	)

end

function draw_tree(t)
	translate(t.x,t.y,10)
	circfill(ct_x,ct_y-3*cam_z,5*cam_z,0)
	if(cam_z>0.6) circfill(ct_x,ct_y-9*cam_z,2*cam_z,0)
	if(cam_z>0.6) circfill(ct_x,ct_y-3*cam_z,4*cam_z,1)
	circfill(ct_x,ct_y-5*cam_z,3*cam_z,3)
	if(cam_z>0.8) circfill(ct_x,ct_y-7*cam_z,2*cam_z,1)
	if(cam_z>1) circfill(ct_x,ct_y-9*cam_z,1*cam_z,3)
end

-- order -1 only draw if y less than buggy
-- order  0 draw all trees
-- order  1 only draw if y is greater than buggy
function draw_hole_trees()
	
	y1=cam_y1-cam_y1%8
	y2=8+cam_y2-cam_y2%8

	for y=y1,y2,8 do

		can_draw=true
		--if(order==-1 and y>bug_y) can_draw=false
		--if(order==1 and y<bug_y) can_draw=false

		if can_draw and y>cam_y1-10 and y<cam_y2+10 and trees[y]!=nil then
			for t in all(trees[y]) do
				if(circle_on_screen(t.x,t.y,10)) draw_tree(t)	
			end
		end
	end

end

function draw_hole_floor(overview)

	-- background
	if(not overview) fillp(0b101101001011010) rectfill(0,0,128,128,36)

	-- water
	wb=abs(cos(app_timer*.1))*3
	for w in all(waterhazards) do
		fillp()
		zcircfill(w.x,w.y,w.r,12)
		fillp(0b101101001011010)
		zcirc(w.x,w.y,w.r-wb,124)
	end

	fillp()
	for w in all(waterhazards) do
		zcircfill(w.x,w.y,w.r-wb-1,12)
	end

	-- rough
	for r in all(rough) do
		if circle_on_screen(r.x,r.y,r.r) then
			translate(r.x,r.y,r.r)
			circfill(ct_x,ct_y,ct_r,3)
		end
	end

	-- fairway
	fillp(0b110110010010011)
	for f in all(fairways) do
		for e in all(f) do
			if circle_on_screen(e.x,e.y,e.r) then
				fillp(fairway_patterns[e.p])
				translate(e.x,e.y,e.r)
				circfill(ct_x,ct_y,ct_r,59)
			end
		end
	end

	-- green
	fillp()
	for e in all(greens) do
		if(circle_on_screen(e.x,e.y,e.r)) zcircfill(e.x,e.y,e.r,11)
	end

	-- bunkers
	if not overview then
		for e in all(bunkers) do
			if circle_on_screen(e.x,e.y,e.r) then
				translate(e.x,e.y,e.r)
				circfill(ct_x,ct_y,ct_r+1*cam_z,9)
			end
		end

		for e in all(bunkers) do
			if circle_on_screen(e.x,e.y,e.r) then
				translate(e.x,e.y,e.r)
				circfill(ct_x,ct_y,ct_r,10)
			end
		end

	else

		for e in all(bunkers) do
			if circle_on_screen(e.x,e.y,e.r) then
				translate(e.x,e.y,e.r)
				circfill(ct_x,ct_y,ct_r+1*cam_z,10)
			end
		end

	end

	

	-- tee
	zrectfill(tee_x1,tee_y1,tee_x2, tee_y2,11)
	zrect(tee_x1,tee_y1,tee_x2, tee_y2,3)
	zpset(tee_x1+3,(tee_y1+tee_y2)/2,8)
	zpset(tee_x2-3,(tee_y1+tee_y2)/2,8)

	translate(pin_x,pin_y,pin_r)
	-- pin or overview graphics
	if not overview then
		circfill(ct_x,ct_y,ct_r,0)
		if club_index != club_putter then
			spr(40,ct_x-1,ct_y-7)
		end
		if hole_index==3 then
			translate(-3,243,1)
			spr(42,ct_x,ct_y)
		end
	else

		
		spr(38,ct_x-2,ct_y-5)

		translate(ball_x,ball_y,1)
		spr(2,ct_x-3,ct_y-3)

		translate(game_aim_x,game_aim_y,1)
		spr(39,ct_x-1,ct_y-4)

	end


end


-- framework functions

function circle_on_screen(x,y,r)
	if(x+r<cam_x1) return false
	if(x-r>cam_x2) return false
	if(y+r<cam_y1) return false
	if(y-r>cam_y2) return false
	return true
end

function set_cam(x,y,z)
	cam_x=x
	cam_y=y
	cam_z=clamp(z,0.5,2)
	cam_w=128/z
	cam_h=128/z
	set_cam_frame()
end

function set_cam_pos(x,y)
	cam_x=x
	cam_y=y
	cam_w=128/cam_z
	cam_h=128/cam_z
	set_cam_frame()
end

function move_cam_pos(x,y)
	set_cam_pos(cam_x+x,cam_y+y)
end

function move_cam_zoom(z)
	set_cam_zoom(cam_z+z)
	set_cam_frame()
end

function set_cam_zoom(z)
	cam_z=clamp(z,0.5,2)
	cam_w=128/z
	cam_h=128/z
	set_cam_frame()
end

function set_cam_frame()
	cam_x1=cam_x-cam_w*.5
	cam_y1=cam_y-cam_w*.5
	cam_x2=cam_x1+cam_w
	cam_y2=cam_y1+cam_h
end

clubs_x=-50
clubs_target_x=-50
selected_club_x=0
selected_club_target_x=4
club_timer=0

function update_gui()
	if(club_timer>0) clubs_target_x=2 club_timer-=1
	if(club_timer==0) clubs_target_x=-50
	clubs_x=ease(clubs_x,clubs_target_x,0.001)
	selected_club_x=ease(selected_club_x,selected_club_target_x,0.0001)
end

function draw_gui()

	rectfill(0,118,128,128,1)
	line(0,118,128,118,0)

	if ball_resting then

		-- draw lie indicator
		spr(47+game_lie,120,119)

		-- draw club indicator
		--spr(club.sprite,111,119)
		--bprint(club.name,126-(#club.name*4),111,103,0)
		bprint(club.name,56,120,7,0)
		bprint(game_distance_to_pin.."yds",82,120,8,0)
		draw_lie_chance()

		-- wind
		--wf=20
		wx=108
		spr(36,wx,120)
		spr(37,wx+8,120)
		if wind_s == 0 then
			spr(19,wx,120)
			print("-",wx+8,121,7)
		else
			c=app_timer%1<.5 and 7 or 8
			spr(20+wind_d,wx,120)
			print(wind_s,wx+8,121,c)
		end

	else
		draw_last_shot_power()
	end

	if game_mode!="shot" and not circle_on_screen(ball_x,ball_y,1) then

		id=atan2(ball_x-cam_x,ball_y-cam_y)
		ix=64+cos(id)*84
		iy=64+sin(id)*84
		ix=clamp(ix,0,127)
		iy=clamp(iy,0,115)
		spr(1,ix-3,iy-3)

	end

	if game_mode!="shot" and not circle_on_screen(pin_x,pin_y,1) then

		id=atan2(pin_x-cam_x,pin_y-cam_y)
		ix=64+cos(id)*84
		iy=64+sin(id)*84
		ix=clamp(ix,0,124)
		iy=clamp(iy,0,110)
		spr(38,ix,iy)

	end
	
	if(ball_landing!=nil) bprint(ball_carry_distance.."yds",30,120,12,0)
	--if(ball_landing==nil) bprint("123yds",30,120,12,0)

	if clubs_x>-30 then
		dy=62
		for c in all(clubs) do
			cc = c==club and 10 or 7
			cx = c==club and selected_club_x or 0
			bprint(c.name,clubs_x+cx,dy,cc,0)
			dy+=8
		end
	end

	

end

function draw_lie_chance()
	if lie_chance<1 then
		if lie_chance>0.9 then lc_color=11
		elseif lie_chance>0.8 then lc_color=10
		elseif lie_chance>0.75 then lc_color=9
		else lc_color=8 end
		bprint((ceil(lie_chance*100)).."-100%",0,120,lc_color,0)
	else
		bprint("100%",0,120,11,0)
	end
end

function draw_last_shot_power()
	if last_shot_power>0.9 then lc_color=11
	elseif last_shot_power>0.8 then lc_color=10
	elseif last_shot_power>0.75 then lc_color=9
	else lc_color=8 end
	bprint((ceil(last_shot_power*100)).."%",0,120,lc_color,0)
	
end

function update_camera()

	if ball_resting==false and game_mode != "aim_putting" then
		set_cam_pos(ease(cam_x,ball_x,0.05),ease(cam_y,ball_y,0.05))
		set_cam_zoom(ease(cam_z,2-(ball_z/100)*1.75,0.2))
	else

		if game_mode=="putting" or game_mode=="aim_putting" then

			x1,y1,x2,y2=nil,nil,nil,nil

			if cam_zoom_out then

				for g in all(greens) do
					if x1==nil or g.x-g.r-3<x1 then x1 = g.x-g.r-3 end
					if y1==nil or g.y-g.r-3<y1 then y1 = g.y-g.r-3 end
					if x2==nil or g.x+g.r+3>x2 then x2 = g.x+g.r+3 end
					if y2==nil or g.y+g.r+3>y2 then y2 = g.y+g.r+3 end
				end

				fx=(x1+x2)/2
				fy=(y1+y2)/2
				
				dx=x2-x1
				dy=y2-y1
			
				fz=min(128/(dx),128/(dy))
				
			else

				fx=(ball_x+pin_x)/2
				fy=(ball_y+pin_y)/2
				dx=abs(pin_x-ball_x)
				dy=abs(pin_y-ball_y)
				fz=min(128/(dx+8),128/(dy+8))
				if(fz>8)fz=8
				
			end
			
			set_cam_pos(ease(cam_x,fx,0.0003),ease(cam_y,fy,0.0003))
			cam_z=ease(cam_z,fz,0.0001)

		elseif game_mode=="drive" then

			set_cam_pos(ease(cam_x,bug_x,0.03),ease(cam_y,bug_y,0.03))
			cam_z=ease(cam_z,2,0.01)

		elseif cam_mode==cam_mode_aim then

			set_cam_pos(ease(cam_x,game_aim_x,0.03),ease(cam_y,game_aim_y,0.03))
			cam_z=ease(cam_z,cam_zoom_out and 1 or 2,0.01)

		elseif cam_mode==cam_mode_hole then

			x1=hole_x1-16
			x2=hole_x2+16
			y1=hole_y1-16
			y2=hole_y2+16

			dx=x2-x1
			dy=y2-y1

			z=min(128/dx,112/dy)

			set_cam_pos(ease(cam_x,(x1+x2)/2,0.03),ease(cam_y,(y1+y2)/2,0.03))

			cam_z=ease(cam_z,z*(cam_zoom_out and .75 or 1),0.0001)
			
		elseif cam_mode==cam_mode_pin then

			set_cam_pos(ease(cam_x,pin_x,0.03),ease(cam_y,pin_y,0.03))
			
			cam_z=ease(cam_z,cam_zoom_out and 1 or 2,0.01)

		elseif cam_mode==cam_mode_shot then

			x1=min(ball_x,game_aim_x)-32
			x2=max(ball_x,game_aim_x)+32
			y1=min(ball_y,game_aim_y)-32
			y2=max(ball_y,game_aim_y)+32

			dx=x2-x1
			dy=y2-y1

			z=min(128/dx,128/dy)

			set_cam_pos(ease(cam_x,(x1+x2)/2,0.03),ease(cam_y,(y1+y2)/2,0.03))

			cam_z=ease(cam_z,z*(cam_zoom_out and .5 or 1),0.0001)
			
		end

	end
end

-- translate x, y and r(adius) values in relation to the camera
function translate(x,y,r)
	ct_x=64+(x-cam_x)*cam_z
	ct_y=64+(y-cam_y)*cam_z
	ct_r=r*cam_z
end


-- general helper functions

-- ease - Value, Target, Rate
function ease(v,t,rate)
	return v + (t - v) * 0.1
end

-- clamp value between two numbers
function clamp(v,l,h)
	return min(h,max(v,l))
end

-- distance between points
-- using shift to allow for larger numbers
function dbp(x1,y1,x2,y2)
	dx=x2-x1
	dy=y2-y1
	return sqrt((dx >> 8) * dx + (dy >> 8) * dy) << 4
end

-- is point in circle?
function pic(x,y,cx,cy,cr)
	-- because pico8 doesnt like
	-- large numbers we do a rect
	-- check first
	if(not pir(x,y,cx-cr,cy-cr,cx+cr,cy+cr)) return false
	if(dbp(x,y,cx,cy)>cr) return false
	return true 
end

-- is point in rectangle
function pir(px,py,x1,y1,x2,y2)
	if(px<x1) return false
	if(px>x2) return false
	if(py<y1) return false
	if(py>y2) return false
	return true
end


--drawing functions

-- draw text with border, text, xpos, ypos, text colour, border  colour
function bprint(t,x,y,c1,c2)
	print(t,x,y+1,c2)
	print(t,x+2,y+1,c2)
	print(t,x+1,y,c2)
	print(t,x+1,y+2,c2)
	print(t,x+1,y+1,c1)
end

-- draw filled circle through camera
function zcircfill(x,y,r,c)	
	dx=64+(x-cam_x)*cam_z
	dy=64+(y-cam_y)*cam_z
	dr=r*cam_z
	circfill(
		dx,
		dy,
		dr,
		c
	)
end

-- draw circle outline through camera
function zcirc(x,y,r,c)
	dx=64+(x-cam_x)*cam_z
	dy=64+(y-cam_y)*cam_z
	dr=r*cam_z
	circ(
		dx,
		dy,
		dr,
		c
	)
end

-- draw line through camera
function zline(x1,y1,x2,y2,c)
	cz=cam_z
	cx=cam_x
	cy=cam_y
	line(
		64+(x1-cx)*cz,
		64+(y1-cy)*cz,
		64+(x2-cx)*cz,
		64+(y2-cy)*cz,
		c
	)
end

-- draw filled rectangle though camera
function zrectfill(x1,y1,x2,y2,c)
	cz=cam_z
	cx=cam_x
	cy=cam_y
	rectfill(
		64+(x1-cx)*cz,
		64+(y1-cy)*cz,
		64+(x2-cx)*cz,
		64+(y2-cy)*cz,
		c
	)
end

-- draw rectangle outline through camera
function zrect(x1,y1,x2,y2,c)
	cz=cam_z
	cx=cam_x
	cy=cam_y
	if cam_z>=1.5 then
		rect(
			64+(x1-cx-.5)*cz,
			64+(y1-cy-.5)*cz,
			64+(x2-cx+.5)*cz,
			64+(y2-cy+.5)*cz,
			c
		)
	end
 	rect(
		64+(x1-cx)*cz,
		64+(y1-cy)*cz,
		64+(x2-cx)*cz,
		64+(y2-cy)*cz,
		c
	)
end

-- set pixel through camera
function zpset(x,y,c)
	cz=cam_z
	cx=cam_x
	cy=cam_y
	if cam_z>=1.5 then
		zrectfill(x,y,x+.5,y+.5,c)
	else
		pset(
			64+(x-cx)*cz,
			64+(y-cy)*cz,
			c
		)
	end
end

-- rotate a sprite
-- col 14 is transparent
-- sx,sy - sprite sheet coords
-- x,y - screen coords
-- a - angle
-- w - width in tiles
function rspr(sx,sy,x,y,a,w)
	local ca,sa=cos(a),sin(a)
	local srcx,srcy
	local ddx0,ddy0=ca,sa
	local mask=shl(0xfff8,(w-1))
	w*=4
	ca*=w-0.5
	sa*=w-0.5
	local dx0,dy0=sa-ca+w,-ca-sa+w
	w=2*w-1
	for ix=0,w do
		srcx,srcy=dx0,dy0
		for iy=0,w do
			if band(bor(srcx,srcy),mask)==0 then
				local c=sget(sx+srcx,sy+srcy)
				if (c!=14) pset(x+ix,y+iy,c)
			end
			srcx-=ddy0
			srcy+=ddx0
		end
		dx0+=ddx0
		dy0+=ddy0
	end
end

function init_shot()

    game_mode="shot"

    shot_lie=game_lie
    shot_mode=shot_mode_ready
    shot_power,shot_timer,shot_set_aim,shot_set_power=0,0,0,0
    shot_gui_rough_grass={}

    -- if this shot is in the rough, we generate some grass for the shot view
    if shot_lie == lie_rough then
        for x=0,128 do
            c=11
            if(rnd()<.5) c=3
            r={x=x,y=4+rnd()*8,c=c}
            add(shot_gui_rough_grass,r)
        end
    end
end

function update_shot()

    if(game_next_mode!=nil) return

    if shot_mode == shot_mode_ready then

	if btn(5) then
		game_mode="aim"
	end

        if btnp(4) then
            shot_mode = shot_mode_power
            shot_power=-5
            shot_set_aim=-99
			shot_set_power=0
			sfx(29)
        end

    elseif shot_mode == shot_mode_power then

        shot_power+=2

        if shot_power>120 then
            if shot_set_power > 0 then
                shot_mode = shot_mode_aim
                shot_power=120
            else
                shot_mode = shot_mode_ready
                shot_power=-5
            end
        end

        if btnp(4) and shot_set_power == 0 then
            if shot_power <= 0 then
                shot_mode = shot_mode_ready
				shot_power=-5
            else
				shot_set_power=shot_power
				sfx(29)
            end
        end

    elseif shot_mode == shot_mode_aim then

        shot_power-=2

		if btnp(4) then

            shot_mode = shot_mode_done
            shot_set_aim=shot_power
            shot_timer=0
			sfx(shot_set_aim == 0 and 35 or 28)
        end

        if shot_power <-10 then
            shot_set_aim=shot_power
            shot_mode = shot_mode_done
            shot_timer=0
        end

    elseif shot_mode == shot_mode_done then
        shot_timer += 1
		if shot_timer>=30 then
			if club_index == club_putter then
				hit_ball(shot_set_power/100,abs(shot_set_aim/150),club.backspin)
			else
				hit_ball(shot_set_power/100,abs(shot_set_aim/250),club.backspin)
			end
			
			if game_lie==lie_green or game_lie==lie_fringe then
				game_mode="aim_putting"
			else
				game_mode="aim"
			end
			
        end
    end

end

function angle_line(ox,oy,d,f,t,c)
	dx1=ox+cos(d)*f	
    dy1=oy+sin(d)*f
    dx2=ox+cos(d)*t
    dy2=oy+sin(d)*t
	line(dx1,dy1,dx2,dy2,c)
end

function draw_shot()

    cls(12)

    if shot_lie == lie_tee then
        rectfill(62,64,66,128,8)
        line(62,64,62,128,2)
        circfill(63,64+30-4,8,2)
        circfill(64,64+30-4,8,8)
    end

	--br=30
	--dr=2
	circfill(64,64,30,6)
    circfill(65,63,28,7)

	l=0
    for y=34,98,10 do     
        for x=34,98,10 do
            oy=y
            
			ox=x+(l==1 and 11 or 6)
            
            dd=dbp(ox,oy,64,64)
			if dd<28 then spr(7,ox,oy) end
        end
        if l==0 then l=1 else l=0 end
	end

    circ(63.5,64,30,0)
    circ(64.5,64,30,0)
    circ(64,63.5,30,0)
    circ(64,64.5,30,0)
    circ(64,64,30,0)

    

    if shot_lie == lie_fairway or shot_lie == lie_fringe then
        rectfill(0,93,128,128,3)
        rectfill(32,93,96,128,11)
    elseif shot_lie == lie_rough then

        --ry=64+30-16
		--ry=78
        rectfill(0,78,128,128,3)
        for rg in all(shot_gui_rough_grass) do
            line(rg.x,78-rg.y,rg.x,78+rg.y,rg.c)
        end

    elseif shot_lie == lie_green then
        rectfill(0,94,128,128,11)
    elseif shot_lie == lie_bunker then
        rectfill(0,68,128,128,9)
        rectfill(0,69,128,71,10)
        rectfill(0,72,128,74,10)
        rectfill(0,78,128,96,10)


    elseif shot_lie == lie_nearly_out_of_bounds then

        rectfill(0,94,128,128,4)

    end

    -- power meter border
    for a=-5,120,2 do
        dx=64+cos(.75+a*-.005)*40
        dy=64+sin(.75+a*-.005)*40
        circfill(dx,dy,6,0)
    end

    -- power meter body
    for a=-5,120,2 do
        dx=64+cos(.75+a*-.005)*40
        dy=64+sin(.75+a*-.005)*40
        circfill(dx,dy,4,1)
    end

	angle_line(64,64,.25,37,43,2)
    --dx1=64+cos(0.25)*37
    --dy1=64+sin(0.25)*37
    --dx2=64+cos(0.25)*43
    --dy2=64+sin(0.25)*43
	--line(dx1,dy1,dx2,dy2,2)
	
	angle_line(64,64,.75,36,42,3)
    --dx1=64+cos(0.75)*36
    --dy1=64+sin(0.75)*36
    --dx2=64+cos(0.75)*42
    --dy2=64+sin(0.75)*42
	--line(dx1,dy1,dx2,dy2,3)
	
	-- target power
	if target_power < 1 then
		tp=(1-target_power)/2+.25
		angle_line(64,64,tp,37,48,8)
		--dx1=64+cos(tp)*37
		--dy1=64+sin(tp)*37
		--dx2=64+cos(tp)*48
		--dy2=64+sin(tp)*48
		--line(dx1,dy1,dx2,dy2,8)

		spr(38,64+cos(tp)*52,60+sin(tp)*52)
	end
	
    if shot_mode == shot_mode_power then

		angle_line(64,64,.75+(-.005*shot_power),36,42,10)
        --dx1=64+cos(d)*36
        --dy1=64+sin(d)*36
        --dx2=64+cos(d)*42
        --dy2=64+sin(d)*42
        --line(dx1,dy1,dx2,dy2,10)
        
    end

    if shot_mode == shot_mode_aim then

		angle_line(64,64,.75+(-.005*shot_power),36,42,11)
        --dx1=64+cos(d)*36
        --dy1=64+sin(d)*36
        --dx2=64+cos(d)*42
        --dy2=64+sin(d)*42
        --line(dx1,dy1,dx2,dy2,11)
        
    end

    if shot_set_power > 0 then

		angle_line(65,63,.75+(-.005*shot_set_power),36,42,9)
        --dx1=65+cos(d)*36
        --dy1=63+sin(d)*36
        --dx2=65+cos(d)*42
        --dy2=63+sin(d)*42
        --line(dx1,dy1,dx2,dy2,9)

    end

    if shot_set_aim >-99 then

		angle_line(64,64,.75+(-.005*shot_set_aim),36,42,11)
        --dx1=64+cos(d)*36
        --dy1=64+sin(d)*36
        --dx2=64+cos(d)*42
        --dy2=64+sin(d)*42
        --line(dx1,dy1,dx2,dy2,11)

    end

end

__gfx__
00000000eeeeeeeeeeeeeeeeee000eeeee000eeeee000eeeee000eee666eeeee0000000000000000000000000000000000000000000000000000000000000000
00000000eeeeeeeeee000eeee06760eee07770eee07670eee07770eeee66eeee0000000000000000000000000000000000000000000000000000000000000000
00000000eee0eeeee07760ee0777770e0676760e0777770e0767670eeee6eeee0000000000000000000000000000000000000000000000000000000000000000
00000000ee070eeee06770ee0676760e0777770e0767670e0777770eeee6eeee0000000000000000000000000000000000000000000000000000000000000000
00000000eee0eeeee07670ee0777770e0767670e0777770e0676760eeeeeeeee0000000000000000000000000000000000000000000000000000000000000000
00000000eeeeeeeeee000eeee06760eee07770eee07670eee07770eeeeeeeeee0000000000000000000000000000000000000000000000000000000000000000
00000000eeeeeeeeeeeeeeeeee000eeeee000eeeee000eeeee000eeeeeeeeeee0000000000000000000000000000000000000000000000000000000000000000
00000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000000000000000000000000000000000000000000000000000000000000
00000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee4444444e000000000000000000000000
00000000eeeeeeeeeeeeeeeeeeeeeeeeeeee7eeeeee7777eeeee7eeeee7777eeeeee7eeeeeeeee7eeeee7eeeee7eeeee7fffff4e000000000000000000000000
00000000ee0e0eeeeee0eeeeeeeeeeeeeeeee7eeeeeee77eeee777eeee77eeeeeee7eeeeee7ee7eeeeee7eeeeee7ee7e7fffff4e000000000000000000000000
00000000eee0eeeeee0e0eeeeeee7eeeee77777eeeee7e7eee7e7e7eee7e7eeeee77777eee7e7eeeee7e7e7eeeee7e7e7fffff4e000000000000000000000000
00000000ee0e0eeeeee0eeeeeeeeeeeeeeeee7eeeee7ee7eeeee7eeeee7ee7eeeee7eeeeee77eeeeeee777eeeeeee77e7fffff4e000000000000000000000000
00000000eeeeeeeeeeeeeeeeeeeeeeeeeeee7eeeee7eeeeeeeee7eeeeeeeee7eeeee7eeeee7777eeeeee7eeeeee7777e7fffff4e000000000000000000000000
00000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee7fffff4e000000000000000000000000
00000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee7fffff4e000000000000000000000000
e000000ee000000ee000000ee000000ee000000000000eeee00eeeeee1eeeeeeeeeeeeeee67eeeeeee000eee000000007777777e000000000000000000000000
0c5cccc00c5cccc00c5cccc00cc5ccc00cccccccccccceee0770eeee171eeeeee8777eeee00eeeeee08880ee00000000eeeeeeee000000000000000000000000
0c5cccc00c56ccc00c5cccc00cc5ccc00cccccccccccceee0770eeee101eeeeee2777eeee67eeeeee08780ee00000000eeeeeeee000000000000000000000000
0c9999c00c667cc00c5cccc00cc5ccc00cccccccccccceee080eeeee171eeeeee8777eeee00eeeeee0a0a0ee00000000eeeeeeee000000000000000000000000
0c4444c00c5667c00c677cc00c6566c00cccccccccccceee080eeeee101eeeeee2eeeeeee67eeeeee0aaa0ee00000000eeeeeeee000000000000000000000000
0c2222c00cc566c00cc567c00c5555c00cccccccccccceee080eeeeee1eeeeeee8eeeeeee00eeeeeee050eee00000000eeeeeeee000000000000000000000000
0cccccc00cccccc00cccccc00cccccc0e000000000000eeee0eeeeeeeeeeeeeee2eeeeeee67eeeeeee050eee00000000eeeeeeee000000000000000000000000
e000000ee000000ee000000ee000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee8eeeeeee00eeeeeeee0eeee00000000eeeeeeee000000000000000000000000
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
e00000eee00000eee00000eee00000eee00000eee00000eee00000eee00000eee00000eee00000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
0c776c0e0ccccc0e0ccccc0e0ccccc0e0ccccc0e0ccccc0e0424240e0ccccc0e0424240e0b333b0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
0c677c0e0c776c0e0c776c0e0c776c0e0c776c0e0c776c0e0277620e0c776c0e0277620e0300030eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
0c767c0e0c677c0e0c677c0e0c677c0e0b677b0e0c677c0e0467740e0ddddd0e0467740e0367030eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
0cc8cc0e0c767c0e0c767c0e0c767c0e0333b30e0a999a0e0276720e0ddddd0e0276720e0356030eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
0bbbbb0e0bbbbb0e0b3b3b0e0b3b3b0e03b3330e099a990e0424240e0ddddd0e0424240e0b333b0eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
e00000eee00000eee00000eee00000eee00000eee00000eee00000eee00000eee00000eee00000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
e00ee00ee002200e8888888800888800007eee0000eeee0000eeee00e00eee00e2888888eeeeeeee000000000000000000000000000000000000000000000000
e00ee00e222222228888888a0066660000eeee0000eeee0000eeee00e00eee00e2888888ee88888e000000000000000000000000000000000000000000000000
eeeeeeee222222228888888a8655556877eeee77eeeee5eeeeeeeeeeeeeeeeeee2888888ee88888e000000000000000000000000000000000000000000000000
eeeeeeee22222222888888888655556877eeee57eeeee5eeeeeee5eeeeeeeeeee2888888ee88888e000000000000000000000000000000000000000000000000
eeeeeeee2222222288888888865555687ceeee577ceee5ee7ceee5eeeeeeeeeee2888888ee88888e000000000000000000000000000000000000000000000000
eeeeeeee222222228888888a86555568cceeee77cceee5eecceeeeeeeeeeeeeee2888888ee88888e000000000000000000000000000000000000000000000000
e00ee00e222222228888888a00666600eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee2888888ee88888e000000000000000000000000000000000000000000000000
e00ee00ee002200e8888888800888800ee7eeeeeeeeeeeeeeeeeeeeeeeeeeeeee2888888eeeeeeee000000000000000000000000000000000000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000
ccccccccccccccccccccccccccccccccccccaaaaa9cccccccccccccca9cccccc0000000000000000000000000000000000000000000000000000000000000000
ccceee8ccccceeccccccccccccccccccccaa999999ccccccccccccca99cccccc0000000000000000000000000000000000000000000000000000000000000000
cee88888cccc88cccccccccccceee8cccc9999ccccccccccccccccc99ccccccc0000000000000000000000000000000000000000000000000000000000000000
c888cc88ccccccccccccccccce888888cc99cccccccccccccccccc999ccccccc0000000000000000000000000000000000000000000000000000000000000000
e88ccc888ccccccccccee8ccc888c888cc99cccccccccccccccccca9cccccccc0000000000000000000000000000000000000000000000000000000000000000
888cccc888cccccccce888ccc88ccc88cc99ccccccccccaaaacccc99cccccccc0000000000000000000000000000000000000000000000000000000000000000
88cccccc88cccccccc88ccccc88ccc88cc999ccaaaaccca999acc999cccccccc0000000000000000000000000000000000000000000000000000000000000000
888cccce88cceecccc88ccccc88ece88cc999cca9999cc99c99cc99ccccaaa9c0000000000000000000000000000000000000000000000000000000000000000
c888cee888cce88cce88ccccc888e888ccc9999cc999cc99c99cc999ccc9999c0000000000000000000000000000000000000000000000000000000000000000
cc8888888cccc88cc888cccccc88888ccccc99999c99cc99ca9cc999ccc99ccc0000000000000000000000000000000000000000000000000000000000000000
ccc888ccccccc888c888888ccccccccccccccc999c99cc99a99ccc999cc99ccc0000000000000000000000000000000000000000000000000000000000000000
cccc88cccccccc88cc88888ccccccccccccccccccc99cc99999cccc99cc99aac0000000000000000000000000000000000000000000000000000000000000000
cccc888ccccccc88ccccccccccccccccccccccccccccccccccccccccccc9999c0000000000000000000000000000000000000000000000000000000000000000
ccccc888ccccccccccccccccccccccccccccccccccccccccccccccccccc9999c0000000000000000000000000000000000000000000000000000000000000000
cccccc88cccccccccccccccccccccccccccccccccccccccccccccccccca99ccc0000000000000000000000000000000000000000000000000000000000000000
cccccc88cccccccccccccccccccccccccccccccccccccccccccccccccc999ccc0000000000000000000000000000000000000000000000000000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc99cccc0000000000000000000000000000000000000000000000000000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000
ccccc0000ccccccc0000cccccccccccccccccccccccccccccccccccccc000000eeeeeeeeeeeeeeeee000000000eeeeeeeeeeeeeeee000000277eeeee00000000
ccc00000000ccc00000000ccc0000cccc000cccc00cc0000cccccccccc000000eeeeeeeeeeeeee000000000000000eeeeeeeeeeeee000000877eeeee00000000
ccc00333300ccc00333000cc033330cc03333cc3330333133ccccccccc000000eeeeeeeeeeee0000067777777000000eeeeeeeeeee0000002eeeeeee00000000
ccc03333330ccc03333300c00333300013333003330011133ccccccccc000000eeeeeeeeee00006776777776777700000eeeeeeeee0000008eeeeeee00000000
0000033331000000033110010000111011111101111011301ccccccccc000000eeeeeeeee0006777666777666777660000eeeeeeee0000002eeeeeee00000000
00000011111000000001110000000010100001011000033000cc0000cc000000eeeeeeee006677777677777677777677000eeeeeee000000eeeeeeee00000000
333330011110033330011100333000100333303003333313330333133c000000eeeeeee00777777777777777777777777000eeeeee000000eeeeeeee00000000
3333330111103333330111033333003003333000133330033300111333000000eeeeee0067777777777777777777777777000eeeee000000eeeeeeee00000000
3333330010011333310000013331100111111110111111011110113013000000eeeee006677777777777777777777777777000eeee0000000000000000000000
333331000011111111100011111111001111111011111101113303300b000000eeee00667677776777776777776777776777000eee0000000000000000000000
111111110011111111110011111111101111111001111330333303110b000000eee006676667766677766677766677766677700eee0000000000000000000000
111111111011111111110011111111003111133300333333333100110b000000eee0067776777767777767777767777767777000ee0000000000000000000000
1111111110111111111000311111133303333333303333330111101bbb000000ee00667777777777777777777777777777777700ee0000000000000000000000
11111111100111111133333333333333303333333033333100110bbbbb000000ee006777777777777777777777777777777777000e0000000000000000000000
11111111330033333333333333333333303333331133331110103bbbbb000000e0066777777777777777777777777777777777700e0000000000000000000000
11111133333003333333333033333333303333311111111110333bbbbb000000e0066777777677777677777677777677777677700e0000000000000000000000
33333333333303333333333033333333300111111111111110333bbbbb000000e006777777666777666777666777666777666770000000000000000000000000
033333333333033333333330003333331100111111111111033bbbbbbb0000000066777777767777767777767777767777767777000000000000000000000000
03333333333303333333331000333111111011111111113333bbbbbbbb0000000066777777777777777777777777777777777777000000000000000000000000
033333333333003333311111000111111110111111333333bbbbbbbbbb0000000066777777777777777777777777777777777777000000000000000000000000
0333333333310001111111111001111111101113333333bbbbbbbbbbbb0000000066777777777777777777777777777777777777000000000000000000000000
00333333331110011111111110011111111333333333bbbbbbbbbbbbbb0000000066777776777767777767777767777767777767000000000000000000000000
0003333111111100111111111001111111033333333bbbbbbbbbbbbbbb0000000066777766677666777666777666777666777666000000000000000000000000
00001111111111101111111100111111103333333bbbbbbbbbbbbbbbbb0000000066777776777767777767777767777767777767000000000000000000000000
10001111111111101111111000111100333333bbbbbbbbbbbbbbbbbbbb0000000066777777777777777777777777777777777777000000000000000000000000
100011111111111011111100000003333333bbbbbbbbbbbbbbbbbbbbbb0000000006677777777777777777777777777777777777000000000000000000000000
100011111111110111100003333333333bbbbbbbbbbbbbbbbbbbbbbbbb000000e0066777777777777777777777777777777777700e0000000000000000000000
1000111111111000000033333333333bbbbbbbbbbbbbbbbbbbbbbbbbbb000000e0066777777677777677777677777677777677700e0000000000000000000000
00011111111100333333333333333bbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000e0006677776667776667776667776667776667700e0000000000000000000000
0011111111003333333333333333bbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000ee00667777767777767777767777767777767700ee0000000000000000000000
011111100003333333333333333bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000ee00066777777777777777777777777777777700ee0000000000000000000000
0000000333333333333333333bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000eee006667777777777777777777777777777700eee0000000000000000000000
333333333333333333333bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000eee000666777777777777777777777777777600eee0000000000000000000000
33333333333333333bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000eeee0006667777677777677777677777677600eeee0000000000000000000000
33333333333333bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000eeeee00066677666777666777666777666600eeeee0000000000000000000000
333333333333bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000eeeeee000666776777776777776777776600eeeeee0000000000000000000000
33333333bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000eeeeeee0006777777777777777777777600eeeeeee0000000000000000000000
333bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000eeeeeeee00007667777777777777777000eeeeeeee0000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000eeeeeeeee000006666777777777660000eeeeeeeee0000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000eeeeeeeeeee00000066666666600000eeeeeeeeeee0000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000eeeeeeeeeeeee0000000000000000eeeeeeeeeeeee0000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000eeeeeeeeeeeeeeee0000000000eeeeeeeeeeeeeeee0000000000000000000000
__label__
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888eeeeee888888888888888888888888888888888888888888888888888888888888888888888888ff8ff8888228822888222822888888822888888228888
8888ee888ee88888888888888888888888888888888888888888888888888888888888888888888888ff888ff888222222888222822888882282888888222888
888eee8e8ee88888e88888888888888888888888888888888888888888888888888888888888888888ff888ff888282282888222888888228882888888288888
888eee8e8ee8888eee8888888888888888888888888888888888888888888888888888888888888888ff888ff888222222888888222888228882888822288888
888eee8e8ee88888e88888888888888888888888888888888888888888888888888888888888888888ff888ff888822228888228222888882282888222288888
888eee888ee888888888888888888888888888888888888888888888888888888888888888888888888ff8ff8888828828888228222888888822888222888888
888eeeeeeee888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111eee1e1111ee1eee1eee1eee11111ccc1ccc1c1111cc1ccc11111eee1ee11ee1111116661666161116111111166611171ccc1ccc11111eee1e1e1eee1ee1
11111e111e111e111e1111e11e1111111c111c1c1c111c111c1111111e1e1e1e1e1e111116161616161116111111111611711c111c1c111111e11e1e1e111e1e
11111ee11e111eee1ee111e11ee111111cc11ccc1c111ccc1cc111111eee1e1e1e1e111116611666161116111111116117111ccc1c1c111111e11eee1ee11e1e
11111e111e11111e1e1111e11e1111111c111c1c1c11111c1c1111111e1e1e1e1e1e11111616161616111611111116171171111c1c1c111111e11e1e1e111e1e
11111eee1eee1ee11eee1eee1e1111111c111c1c1ccc1cc11ccc11111e1e1e1e1eee111116661616166616661171161771171ccc1ccc111111e11e1e1eee1e1e
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111777111111111111111111111111111111
1111111111bb1bbb1bbb11711ccc111116661666161116111111161611111ccc1111166616661611161111111616111777711171111111111111111111111111
111111111b111b1b1b1b1711111c11111616161616111611111116161111111c11111616161616111611111116161117711c1117111111111111111111111111
111111111bbb1bbb1bb117111ccc111116611666161116111111116117771ccc11111661166616111611111116661771171c1117111111111111111111111111
11111111111b1b111b1b17111c11117116161616161116111111161611111c11117116161616161116111111111611111c111117111111111111111111111111
111111111bb11b111b1b11711ccc171116661616166616661171161611111ccc171116661616166616661171166611111ccc1171111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111eee1e1111ee1eee111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111e111e111e111e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111ee11e111eee1ee1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111e111e11111e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111eee1eee1ee11eee111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111118888811111111111111111111111111111111111111111111111111111111111111111111111
111111111eee1eee111111661666166616661111166617171111888781111ccc1ccc11111eee1e1e1eee1ee11111111111111111111111111111111111111111
1111111111e11e1111111611161616661611111111611117111188788111111c1c11111111e11e1e1e111e1e1111111111111111111111111111111111111111
1111111111e11ee1111116111666161616611111116111711111878881111ccc1ccc111111e11eee1ee11e1e1111111111111111111111111111111111111111
1111111111e11e11111116161616161616111111116117111111887881111c11111c111111e11e1e1e111e1e1111111111111111111111111111111111111111
111111111eee1e11111116661616161616661171116117171171888781c11ccc1ccc111111e11e1e1eee1e1e1111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111bb1bbb1bbb11711ccc111116661666161116111111161611111ccc111116661666161116111111161611111ccc117111111111111111111111
1111111111111b111b1b1b1b1711111c11111616161616111611111116161111111c11111616161616111611111116161111111c111711111111111111111111
1111111111111bbb1bbb1bb1171111cc1111166116661611161111111161177711cc1111166116661611161111111666177711cc111711111111111111111111
111111111111111b1b111b1b1711111c11711616161616111611111116161111111c11711616161616111611111111161111111c111711111111111111111111
1111111111111bb11b111b1b11711ccc171116661616166616661171161611111ccc171116661616166616661171166611111ccc117111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111eee1e1111ee1eee11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111e111e111e111e1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111ee11e111eee1ee111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111e111e11111e1e1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111eee1eee1ee11eee11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111bb1bbb1bbb11711c1c111116661666161116111111161611111ccc111116661666161116111111161611111ccc117111111111111111111111
1111111111111b111b1b1b1b17111c1c11111616161616111611111116161111111c11111616161616111611111116161111111c111711111111111111111111
1111111111111bbb1bbb1bb117111ccc1111166116661611161111111161177711cc1111166116661611161111111666177711cc111711111111111111111111
111111111111111b1b111b1b1711111c11711616161616111611111116161111111c11711616161616111611111111161111111c111711111111111111111111
1111111111111bb11b111b1b1171111c171116661616166616661171161611111ccc171116661616166616661171166611111ccc117111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111eee1ee11ee1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111e111e1e1e1e111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111ee11e1e1e1e111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111e111e1e1e1e111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111eee1e1e1eee111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111eee1ee11ee11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111e111e1e1e1e1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111ee11e1e1e1e1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111e111e1e1e1e1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111eee1e1e1eee1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111bbb1bbb1b111bbb11711ccc11111ccc1ccc1c1111cc1ccc1171111111111111111111111111111111111111111111111111111111111111111111111111
11111b1b1b1b1b1111b117111c1c11111c111c1c1c111c111c111117111111111111111111111111111111111111111111111111111111111111111111111111
11111bbb1bbb1b1111b117111c1c11111cc11ccc1c111ccc1cc11117111111111111111111111111111111111111111111111111111111111111111111111111
11111b111b1b1b1111b117111c1c11711c111c1c1c11111c1c111117111111111111111111111111111111111111111111111111111111111111111111111111
11111b111b1b1bbb11b111711ccc17111c111c1c1ccc1cc11ccc1171111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111bbb11bb1bbb1bbb11711c111c1c11111c111c1c11111ccc1171111111111111111111111111111111111111111111111111111111111111111111111111
11111b1b1b111b1111b117111c111c1c11111c111c1c11111c1c1117111111111111111111111111111111111111111111111111111111111111111111111111
11111bbb1bbb1bb111b117111ccc1ccc11111ccc1ccc11111ccc1117111111111111111111111111111111111111111111111111111111111111111111111111
11111b11111b1b1111b117111c1c111c11711c1c111c11711c1c1117111111111111111111111111111111111111111111111111111111111111111111111111
11111b111bb11bbb11b111711ccc111c17111ccc111c17111ccc1171111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1111166616661666166616611666117111bb1bbb1bbb1bbb11711cc11171111111111c1c11111c1c111111111166166616661111166611111ccc11111ccc1111
111116161616161611611616116117111b1111b11b1b11b1171111c11117111111111c1c11c11c1c111111111611161616661111111611111c1c11111c1c1111
111116611666166111611616116117111bbb11b11bbb11b1171111c1111711111111111111111111111111111611166616161111116111111c1c11111c1c1111
11111616161116161161161611611711111b11b11b1b11b1171111c1111711111111111111c11111111111111611161616161111161111711c1c11711c1c1171
111116661611161616661616116111711bb111b11b1b11b111711ccc117111711171111111111111117111711166161616161171166617111ccc17111ccc1711
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111116661666166616661661166611711c1c1c111ccc1ccc11111c1c111111111166166616661666111116111666166611111ccc11111ccc11111ccc11111ccc
111116161616161611611616116117111c1c1c1111c11c1111c11c1c111111111611161616661611111116111161161111111c1c1111111c11111c1c11111c1c
1111166116661661116116161161171111111c1111c11cc111111111111111111611166616161661111116111161166111111c1c1111111c11111ccc11111c1c
1111161616111616116116161161171111111c1111c11c1111c11111111111111616161616161611111116111161161111711c1c1171111c11711c1c11711c1c
1111166616111616166616161161117111111ccc1ccc1ccc11111111117111711666161616161666117116661666166617111ccc1711111c17111ccc17111ccc
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1ee11ee111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1ee11e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
82888222822882228888828282228222888282888222828288888888888888888888888888888888888882228222828282228882822282288222822288866688
82888828828282888888828288828882882882888282828288888888888888888888888888888888888888828882828282828828828288288282888288888888
82888828828282288888822282228882882882228282822288888888888888888888888888888888888882228822822282828828822288288222822288822288
82888828828282888888888282888882882882828282888288888888888888888888888888888888888882888882888282828828828288288882828888888888
82228222828282228888888282228882828882228222888288888888888888888888888888888888888882228222888282228288822282228882822288822288
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

__sfx__
012100000061600616006160161601616016160061600616006160061600616006160061600616006160061600616006160061600616006160161601616016160161600616016160061600616006160061600616
01040000335222c5212451100500005000050000500005000050000500335122c5112451124500175000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
010300003c720377113c721377110070007700007003c740377113c741377113c70000700007003c730377113c721377113c70037700277003c720377113c721377111870013700187003c720377113c72137711
000c00000c073000003f0130000124675006033f0130000024605000000c0730000024675000000c073000000c003000000c07300000246750c0030c003000000c003000000c0730000024675000000c07300000
010c0000345503455034550345500c0003410034100321003455134551325503255031550315502f5502f5502f5522f5522f5522f552137001370013700137002d5502d5502d5502d1002f5502f5522f5522f100
010c0000315503155031555321003255032550315513155131100311002d5502d5503655036550345503455034552345523455234552345423454234542345123451234512345120000000000000000000000000
010c0000315503155031555321003255032550315513155131100311002d5502d5500000000000285502855028552285522855228552000000000000000000000000000000000000000000000000000000000000
010c00000c073000003c71300001246750c0033c7130000024605000000c0730000024675000000c0733c70000000000010c07300000246750c0033c713000010c003000000c0730000024675000003c71324675
010c000009030090300901009010090320903209012090120901009010100301003215032150320b0300b0300b0300b0300b0300b0300b0320b0320b0320b0320b0300b0300b0100b0100b0320b0320b0120b012
010c00000d0300d0300d0300d0300d0300d0300d0300d0300d0300d0300d0300d0300d0300d0300b0300b0300b0300b0300b0300b0300b0320b0320b0320b0320b0320b0320b0320b03217031170310b0310b030
010c00000d0300d0300d0100d0100d0320d0320d0120d0120d0100d01009030090321203212032100301003010030100301003010030100321003210032100321003010030100101001004030040301701117011
010f00000c033000000c03300000306350c0330c0030c0130c0330000000000000003063500000000000000000000000000c03300000306350c03300000000000c033000000c0030c01330635000000000000000
010f00000873000700087300c7000c70008730087300070008730087300070008730007000070000700007000c70000700087300c7000c7000873008030070000873008730007000873000700007000070000700
010f00000c730007000c7300c7000c7000c7300c730007000c7300c730007000c730007000070000700007000c700007000c7300c7000c7000c7300c730007000c7300c730007000c73000700007000070000700
010f0000240402404024040240402403024030240202402024022240222402224022240122401224002240021a0301a0301a0301a0301a0301a0301a0201a0201a0221a0221a0221a0221a0221a0220000024000
010f00001c0301c0301c0301c0301c0301c0301c0301c0301c0221c0221c0221c0221c0221c0221c0221c0221c0121c0121c0121c0121c0121c0121c0121c0121c0121c0121c0121c0121c0121c0121c0121c012
010f0000240402404024040240402403024030240202402024022240222402224022240122401224002240021a0301a0301a0301a0301a0301a0301a0201a0201a0221a0221a0121a0121f0411f0421f0421f042
010f00000873000700087300c7000c70008730087300070008730087300070008730007000070000700007000c70000700077300c7000c7000773007730007000773007730007000773007000007000070000700
010f00000073000700007300c7000c70000730007300070000730007300070000730007000070000700007000c70000700007300c7000c7000073000730007000073000730007000073007000007000070000700
010f00000073000700007300c7000c70000730007300070000730007300070000730007000070000700007000073000730000000c7000c7000070000700007000070000700007000070007000007000070000700
01050000306103c6513062124611186110c6110060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600
01080000306500c050180412403130021300113001130011300003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0108000030650180502f041240312f021300112f01130011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010800003065018050390413703129021340111801112011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01140000180230c0000c0000c0000c0000c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000000c22300500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
010700001802324101240200000000000180100000000000180002400100000180040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000000c05300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011500003c7353c7003c7030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010300003c73500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010100001172211712117221171211722117121172211712117221171211722117121172211712117221171211722117121172211712117221171211722117121172211712117221171211722117121172211712
010100000021700217002070020700207002070020700207002170021700207002070020700217002170021700217002070020700207002170020700207002170021700217002070021700207002070021700217
01010000106500c6500b6500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00020000290402b0500007017670380701467026070126601a05010640150300f6200a02009020066200562004620000100461004610046100461004610046100461003610036100361002610026100261001610
01050000241143c7513062124111187110c11124111186110c12124125186250c41524415184150c4151800000000000000000000000000000000000000000000000000000000000000000000000000000000000
010b000030740377203c7603c7403c720000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010f00000c0001010113201183010c4011030113201181010c0011010113201183010c4011030113201181010c0011010113201183010c4011030113201181010c0011010113201183010c401103011320118101
__music__
00 00404344
00 00014344
00 00424344
00 00424344
00 00024344
00 00424344
00 00424344
02 00424344
01 04030844
00 06030944
00 04030844
02 05070a44
01 0b0c4344
00 0b0d4344
00 0b0c0e44
00 0b0d0f44
00 0b0c1044
00 0b0d0f44
00 0b115044
00 0b125044
00 0b115044
02 0b136844

