//  today date = 5-10-19
//  uploading this to drive
#include <a_samp>
#include <Dini>
#include <zcmd>
#include <sscanf2>
#include <streamer>
#include <GetVehicleColor>
#include "../include/gl_common.inc"

// NEW
new Rskin[] = {72, 66, 47, 2, 9, 21, 22, 23, 29};
new spawn_at_hospital[MAX_PLAYERS];
new in_class_selection[MAX_PLAYERS];
new Rscreen[] = {0, 1};
new screen;
new RscreenTimer[MAX_PLAYERS];
new total_vehicles_from_file = 0;


// DEFINES = dialog
#define DIALOG_REGISTER 1
#define DIALOG_LOGIN 2

//define = job
new policeofficer[MAX_PLAYERS];

//define = keys
#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

//checkpoints
new garagecp;
new garagecpin[MAX_PLAYERS];

//pickups
new garagepickup;
new ingaragepickup;


main()
{
	print("\n----------------------------------");
	print("welcome to Los Santos 5(singleplayer features)");
	print("----------------------------------\n");
}


public OnGameModeInit()
{
	SetGameModeText("FreeRoam RP Cops Race");
	UsePlayerPedAnims();
	DisableInteriorEnterExits();
	
	garagepickup = CreatePickup(1273, 1, 2032.4200,-1280.1359,20.9698, -1);
    CreateDynamic3DTextLabel("Bahamas Garage\nPrice = 86000",0x00FF3FFF,2032.4200,-1280.1359,20.9698+0.5,10.0);
	

	

	// Loading Vehicles....
	total_vehicles_from_file += LoadStaticVehiclesFromFile("vehicles/ls_airport.txt");
    total_vehicles_from_file += LoadStaticVehiclesFromFile("vehicles/ls_gen_inner.txt");
    total_vehicles_from_file += LoadStaticVehiclesFromFile("vehicles/ls_gen_outer.txt");
    total_vehicles_from_file += LoadStaticVehiclesFromFile("vehicles/ls_law.txt");
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    in_class_selection[playerid] = 2;
	policeofficer[playerid] = 0;
	new file[128], pname[MAX_PLAYER_NAME];
	GetPlayerName(playerid, pname, sizeof(pname));
    format(file, sizeof(file), "\\UserData\\%s.ini", pname);
   	if(!dini_Exists(file))
{
	ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Register", "Enter password below", "Register", "");
}
	else
{
    ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Enter password below", "Login", "");
}


	RequestClasss(playerid);
	
	
    return 1;
}

forward RequestClasss(playerid);
public RequestClasss(playerid)
{
	in_class_selection[playerid] = 2;
	screen = Rscreen[random(sizeof(Rscreen))];
	switch(screen)
   	{
      case 0:
      {
    	SetPlayerPos(playerid, 1066.30,-1327.60,26.19);
    	SetPlayerCameraPos(playerid, 1066.30,-1327.60,26.19);
	    SetPlayerCameraLookAt(playerid, 1064.15,-1328.97,26.13);
      }
      case 1:
      {
        SetPlayerPos(playerid, 281.20,-2103.10,24.77);
    	SetPlayerCameraPos(playerid, 281.20,-2102.10,24.77);
    	SetPlayerCameraLookAt(playerid, 285.50,-2099.91,24.77);
      }
    }
    return 1;
}

public OnPlayerConnect(playerid)
{
	new strinng[128], Pname[MAX_PLAYER_NAME], score_timer[MAX_PLAYERS];
	score_timer[playerid] = SetTimer("set_score", 1000, true);
	RscreenTimer[playerid] = SetTimer("RequestClasss", 4000, true);
	GetPlayerName(playerid, Pname, sizeof(Pname));
	format(strinng, sizeof(strinng), " %s has joined the server", Pname);
	SendClientMessageToAll(0x663366FF, strinng);
	spawn_at_hospital[playerid] = 34;
	return 1;
}

forward set_score(playerid);

public set_score(playerid)
{
	SetPlayerScore(playerid, GetPlayerMoney(playerid));
}

public OnPlayerDisconnect(playerid, reason)
{
    new file[128], string[128], pname[MAX_PLAYER_NAME], score_timer[MAX_PLAYERS];
    new Float:x, Float:y, Float:z, Float:Angle, Float:hp, Float:armour;
    GetPlayerName(playerid, pname, sizeof(pname));
    format(file, sizeof(file), "\\UserData\\%s.ini", pname);

    new Vfile[128], Float:VehDis, vehid;
    GetPlayerName(playerid, pname, sizeof(pname));
    policeofficer[playerid] = 0;
	KillTimer(score_timer[playerid]);
	format(Vfile, sizeof(Vfile), "\\UserGarages\\%s.ini", pname);
	vehid = dini_Int(Vfile, "VehicleID");
	VehDis = GetVehicleDistanceFromPoint(vehid, 2032.4796,-1289.7238,20.9456);

    if(in_class_selection[playerid] == 5)
 {
	GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, Angle);
    GetPlayerHealth(playerid, hp);
    GetPlayerArmour(playerid, armour);
    dini_FloatSet(file, "posX", x);
    dini_FloatSet(file, "posY", y);
    dini_FloatSet(file, "posZ", z);
    dini_FloatSet(file, "Fangle", Angle);
    dini_IntSet(file, "Money", GetPlayerMoney(playerid));
    dini_FloatSet(file, "pHealth", hp);
    dini_FloatSet(file, "pArmour", armour);
    dini_IntSet(file, "pSkin", GetPlayerSkin(playerid));
    dini_IntSet(file, "Wantedlvl", GetPlayerWantedLevel(playerid));
    format(string, sizeof(string), "%s have left the server", pname);
	SendClientMessageToAll(0x663366FF, string);
    if(VehDis < 0.5)
    DestroyVehicle(vehid);
 }
	else
{
  //do nothing
}
	return 1;
}

public OnPlayerSpawn(playerid)
{
    in_class_selection[playerid] = 5;
    KillTimer(RscreenTimer[playerid]);
	if(spawn_at_hospital[playerid] == 1)
    {
	SetPlayerPos(playerid, 2027.7700,-1420.5200,16.9922);
	demotepoliceofficer(playerid);
	SetPlayerFacingAngle(playerid, 137);
	SetCameraBehindPlayer(playerid);
	SendClientMessage(playerid, 0xFFFFFFFF, "Jefferson Hospital");
	}
	

	return 0;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	spawn_at_hospital[playerid] = 1;
	SetPlayerWantedLevel(killerid, GetPlayerWantedLevel(killerid) + 2);
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/mycommand", cmdtext, true, 10) == 0)
	{
		// Do something here
		return 1;
	}
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

forward promoteplayertopolice(playerid);
public promoteplayertopolice(playerid)
{
	if(policeofficer[playerid] == 1) return 0;
	policeofficer[playerid] = 1;
	SetPlayerColor(playerid, 0x3333FFFF);
	SendClientMessage(playerid, 0x3333FFFF, "-------You joined police job!-------");
	return 1;
}

forward demotepoliceofficer(playerid);
public demotepoliceofficer(playerid)
{
	policeofficer[playerid] = 0;
	SetPlayerColor(playerid, 0xFFFFFFFF);
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	new vehicleid = GetPlayerVehicleID(playerid);
    new	vehiclemodel = GetVehicleModel(vehicleid);
    new Vfile[128], pname[MAX_PLAYER_NAME];
    GetPlayerName(playerid, pname, sizeof(pname));
    format(Vfile, sizeof(Vfile), "\\UserGarages\\%s.ini", pname);
	if(oldstate == PLAYER_STATE_ONFOOT && newstate == PLAYER_STATE_DRIVER || PLAYER_STATE_PASSENGER)
	if(vehiclemodel == 596)
	{
	if(policeofficer[playerid] == 1) return 0;
	SendClientMessage(playerid, 0x3333FFFF, "-----Press 2 to start police job------");
    }
   	if(oldstate == PLAYER_STATE_ONFOOT && newstate == PLAYER_STATE_DRIVER)
	{
       new owned;
	   owned = dini_Int(Vfile, "GarageOwned");
	   if(owned == 1)
	   garagecp = CreateDynamicCP(2032.6796,-1289.7238,20.9456,4, 0,-1,-1,100.0);
	}
   	if(newstate == PLAYER_STATE_ONFOOT)
   	DestroyDynamicCP(garagecp);
	return 1;
}

public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
   if(checkpointid == garagecp)
   {
   GameTextForPlayer(playerid, "press space to save vehicle", 5000, 6);
   garagecpin[playerid] = 1;
   }
   return 1;
}

public OnPlayerLeaveDynamicCP(playerid, checkpointid)
{
   if(checkpointid == garagecp)
   {
   garagecpin[playerid] = 0;
   }

   return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 0;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
     new Vfile[128], pname[MAX_PLAYER_NAME];
     GetPlayerName(playerid, pname, sizeof(pname));
     format(Vfile, sizeof(Vfile), "\\UserGarages\\%s.ini", pname);
     new owned;
     owned = dini_Bool(Vfile, "GarageOwned");
	 if(pickupid == garagepickup)
	{
     if(owned == 1) return 0;
	 ingaragepickup = 1;
	 GameTextForPlayer(playerid, "press LALT to purchase Garage!", 5000, 3);
    }
    
	 return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	new pname[MAX_PLAYER_NAME];
	new Vfile[128];
    new vehicleid = GetPlayerVehicleID(playerid);
    new	vehiclemodel = GetVehicleModel(vehicleid);
    GetPlayerName(playerid, pname, sizeof(pname));
    format(Vfile, sizeof(Vfile), "\\UserGarages\\%s.ini", pname);
	if(vehiclemodel == 596)
	{
	   if(PRESSED(KEY_SUBMISSION))
	   {
	      if(GetPlayerWantedLevel(playerid) > 0)
          SendClientMessage(playerid, 0x3333FFFF, "Criminals can not start this job");
	      else
	      promoteplayertopolice(playerid);
	   }
	}

	if(PRESSED(KEY_WALK))
	{
	  if(ingaragepickup == 1)
	  {
		new owned;
		owned = dini_Bool(Vfile, "GarageOwned");
		if(owned == 1) return GameTextForPlayer(playerid, "Garage already purchased!", 4000, 3);
		new moni;
	    moni = GetPlayerMoney(playerid);
	    if(moni > 86000)
		{
		if(!dini_Exists(Vfile))
		{
		dini_Create(Vfile);
		GivePlayerMoney(playerid, -86000);
	    dini_BoolSet(Vfile, "GarageOwned", 1);
        GameTextForPlayer(playerid, "Garage Purchased!", 5000, 6);
        }
	    }
	    else return GameTextForPlayer(playerid, "Not enough Money!", 3000, 6);
	  }
	}
	  


	if(PRESSED(KEY_HANDBRAKE))
	{
	   new owned;
	   owned = dini_Int(Vfile, "GarageOwned");
	   if(owned == 1)
	   savevehicleingarage(playerid);
    }
       
	return 1;
}

forward savevehicleingarage(playerid);
public savevehicleingarage(playerid)
{
	new color1, color2;

	new vehid = GetPlayerVehicleID(playerid);
    new oldvehid, vid;
    new	vehiclemodel = GetVehicleModel(vehid);
    new Vfile[128], pname[MAX_PLAYER_NAME];
    new spoiler, hood, roof, nitro, sideskirt, wheels;
    GetPlayerName(playerid, pname, sizeof(pname));
	
	//getting components
	spoiler = GetVehicleComponentInSlot(vehid, CARMODTYPE_SPOILER);
	hood = GetVehicleComponentInSlot(vehid, CARMODTYPE_HOOD);
	roof = GetVehicleComponentInSlot(vehid, CARMODTYPE_ROOF);
	nitro = GetVehicleComponentInSlot(vehid, CARMODTYPE_NITRO);
	sideskirt = GetVehicleComponentInSlot(vehid, CARMODTYPE_SIDESKIRT);
	wheels = GetVehicleComponentInSlot(vehid, CARMODTYPE_WHEELS);
	
    format(Vfile, sizeof(Vfile), "\\UserGarages\\%s.ini", pname);
    oldvehid = dini_Int(Vfile, "VehicleID");
    if(garagecpin[playerid] == 1)
    {
	   dini_Create(Vfile);
	   dini_IntSet(Vfile, "VehicleModel", vehiclemodel);
       GetVehicleColor(vehid, color1, color2);
       dini_IntSet(Vfile, "VehicleColor1", color1);
       dini_IntSet(Vfile, "VehicleColor2", color2);
       dini_IntSet(Vfile, "Vehiclespoiler", spoiler);
       dini_IntSet(Vfile, "Vehiclehood", hood);
       dini_IntSet(Vfile, "Vehicleroof", roof);
       dini_IntSet(Vfile, "Vehiclenitro", nitro);
       dini_IntSet(Vfile, "Vehiclesideskirt", sideskirt);
       dini_IntSet(Vfile, "Vehiclewheels", wheels);
	   SendClientMessage(playerid, 0x3333FFFF, "vehicle saved!");
	   RemovePlayerFromVehicle(playerid);
	   SetVehicleToRespawn(vehid);
	   DestroyVehicle(oldvehid);
	   vid = CreateVehicle(vehiclemodel, 2032.4796,-1289.7238,20.9456, 90, color1, color2, 10000);
       dini_IntSet(Vfile, "VehicleID", vid);
       AddVehicleComponent(vid, spoiler);
       AddVehicleComponent(vid, hood);
       AddVehicleComponent(vid, roof);
       AddVehicleComponent(vid, nitro);
       AddVehicleComponent(vid, wheels);
       AddVehicleComponent(vid, sideskirt);
       AddVehicleComponent(vid, wheels);
	   SetPlayerPos(playerid, 2026.4796,-1289.7238,20.9456);
	   SetPlayerFacingAngle(playerid, 270);
	   SetCameraBehindPlayer(playerid);
    }
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
   	new Vfile[128], pname[MAX_PLAYER_NAME];
	GetPlayerName(forplayerid, pname, sizeof(pname));
	new spoiler, hood, roof, nitro, sideskirt, wheels;
    format(Vfile, sizeof(Vfile), "\\UserGarages\\%s.ini", pname);
    if(vehicleid == dini_Int(Vfile, "VehicleID"))
    {
          spoiler = dini_Int(Vfile, "Vehiclespoiler");
          hood = dini_Int(Vfile, "Vehiclehood");
          roof = dini_Int(Vfile, "Vehicleroof");
          nitro = dini_Int(Vfile, "Vehiclenitro");
          sideskirt = dini_Int(Vfile, "Vehiclesideskirt");
          wheels = dini_Int(Vfile, "Vehiclewheels");
          AddVehicleComponent(vehicleid, spoiler);
          AddVehicleComponent(vehicleid, hood);
          AddVehicleComponent(vehicleid, roof);
          AddVehicleComponent(vehicleid, nitro);
          AddVehicleComponent(vehicleid, wheels);
          AddVehicleComponent(vehicleid, sideskirt);
          AddVehicleComponent(vehicleid, wheels);
    }
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
    new Vfile[128], pname[MAX_PLAYER_NAME];
	GetPlayerName(forplayerid, pname, sizeof(pname));
	new spoiler, hood, roof, nitro, sideskirt, wheels;
    format(Vfile, sizeof(Vfile), "\\UserGarages\\%s.ini", pname);
    if(vehicleid == dini_Int(Vfile, "VehicleID"))
    {
          spoiler = dini_Int(Vfile, "Vehiclespoiler");
          hood = dini_Int(Vfile, "Vehiclehood");
          roof = dini_Int(Vfile, "Vehicleroof");
          nitro = dini_Int(Vfile, "Vehiclenitro");
          sideskirt = dini_Int(Vfile, "Vehiclesideskirt");
          wheels = dini_Int(Vfile, "Vehiclewheels");
          AddVehicleComponent(vehicleid, spoiler);
          AddVehicleComponent(vehicleid, hood);
          AddVehicleComponent(vehicleid, roof);
          AddVehicleComponent(vehicleid, nitro);
          AddVehicleComponent(vehicleid, wheels);
          AddVehicleComponent(vehicleid, sideskirt);
          AddVehicleComponent(vehicleid, wheels);
    }
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
   	new file[128], pname[MAX_PLAYER_NAME], loginmsg[128];
    new Float:x, Float:y, Float:z, Float:Angle, Float:hp, Float:armour;
    GetPlayerName(playerid, pname, sizeof(pname));
    format(file, sizeof(file), "\\UserData\\%s.ini", pname);
	new Vfile[128], vid, Float:VehDis;
	new vehiclemodel, vehid;
	new color1, color2;
    new spoiler, hood, roof, nitro, sideskirt, wheels;
    format(Vfile, sizeof(Vfile), "\\UserGarages\\%s.ini", pname);
	switch(dialogid)
{
	    case DIALOG_REGISTER:
    	{
           if(response)
           {
           dini_Create(file);
           // next
           dini_Set(file, "password", inputtext);
           dini_FloatSet(file, "posX", 0);
		   dini_FloatSet(file, "posY", 0);
		   dini_FloatSet(file, "posZ", 0);
		   dini_FloatSet(file, "Fangle", 0);
		   dini_IntSet(file, "Money", 0);
		   dini_FloatSet(file, "pHealth", 100);
		   dini_FloatSet(file, "pArmour", 0);
           dini_IntSet(file, "pSkin", GetPlayerSkin(playerid));
           dini_IntSet(file, "Wantedlvl", 0);
		   SetSpawnInfo( playerid, 0, Rskin[random(sizeof(Rskin))], 1682.7000,-2244.8999,13.5454, 180, 26, 36, 28, 150, 0, 0 );
           SpawnPlayer(playerid);
    	   SetPlayerHealth(playerid, 100);
           GivePlayerMoney(playerid, 3000);
	       SetCameraBehindPlayer(playerid);
           SendClientMessage(playerid, 0xFF0066FF, "You have Registered to our server, have a lot of fun!");
           }
        }

       case DIALOG_LOGIN:
       {// if 0 start
      	  if(response)
          {// if 1 start
		  if(!strlen(inputtext)) return SendClientMessage(playerid, 0xFF0066FF, "incorrect password!"),ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Enter password below", "Login", "");
          if(strcmp(inputtext, dini_Get(file, "password"), false) == 0)
            {// if 2 start
              x = dini_Float(file, "posX");
              y = dini_Float(file, "posY");
              z = dini_Float(file, "posZ");
              Angle = dini_Float(file, "Fangle");
              hp = dini_Float(file, "pHealth");
              armour = dini_Float(file, "pArmour");
              SetSpawnInfo( playerid, 0, dini_Int(file, "pSkin"), x, y, z, Angle, 26, 36, 28, 150, 0, 0 );
              SpawnPlayer(playerid);
              SetPlayerHealth(playerid, hp);
              SetPlayerArmour(playerid, armour);
              SetCameraBehindPlayer(playerid);
              GivePlayerMoney(playerid, dini_Int(file,"Money"));
              SetPlayerWantedLevel(playerid, dini_Int(file,"Wantedlvl"));
              format(loginmsg, sizeof(loginmsg), "Welcome back %s!, Have a lot of fun!", pname);
              SendClientMessage(playerid, 0xFF0066FF, loginmsg);
              if(dini_Exists(Vfile))
              {//if 3 start
                  vehid = dini_Int(Vfile, "VehicleID");
                  VehDis = GetVehicleDistanceFromPoint(vehid, 2032.4796,-1289.7238,20.9456);
                  if(VehDis < 0.5)
                  {//if 4 start
				     vehiclemodel = dini_Int(Vfile, "Vehiclemodel");
                     color1 = dini_Int(Vfile, "VehicleColor1");
                     color2 = dini_Int(Vfile, "VehicleColor2");
				     spoiler = dini_Int(Vfile, "Vehiclespoiler");
			         hood = dini_Int(Vfile, "Vehiclehood");
                     roof = dini_Int(Vfile, "Vehicleroof");
                     nitro = dini_Int(Vfile, "Vehiclenitro");
                     sideskirt = dini_Int(Vfile, "Vehiclesideskirt");
                     wheels = dini_Int(Vfile, "Vehiclewheels");
		             vid = CreateVehicle(vehiclemodel, 2032.4796,-1289.7238,20.9456, 90, color1, color2, 10000);
                     dini_IntSet(Vfile, "VehicleID",vid);
                     AddVehicleComponent(vid, spoiler);
                     AddVehicleComponent(vid, hood);
                     AddVehicleComponent(vid, roof);
                     AddVehicleComponent(vid, nitro);
                     AddVehicleComponent(vid, wheels);
                     AddVehicleComponent(vid, sideskirt);
                     AddVehicleComponent(vid, wheels);
                  }//if 4 end
              }//if 3 end
            }//if 2 end
          }//if 1 end
		  else
          {
           SendClientMessage(playerid, 0xFF0066FF, "incorrect password!");
           ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Enter password below", "Login", "");
          }
       }//if 0 end
       default: return 0;

}

	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

CMD:gstar(playerid, params[])
{
   SetPlayerWantedLevel(playerid, 2 + GetPlayerWantedLevel(playerid));
   PlayCrimeReportForPlayer(playerid, playerid, 16);
   demotepoliceofficer(playerid);
   return 1;
}

CMD:rstar(playerid, params[])
{
   SetPlayerWantedLevel(playerid, 0);
   return 1;
}

CMD:removestar(playerid, params[])
{
  new star, cstar;
  cstar = GetPlayerWantedLevel(playerid);
  if(sscanf(params, "d", star))
  SendClientMessage(playerid, 0xFFFFFFFF, "STUPID");
  if(cstar >= 0)
  if(star <= cstar)
  SetPlayerWantedLevel(playerid, cstar - star);
  return 1;
}

CMD:addobject(playerid, params[])
{
  // doomd1:
new myobject1 = CreateObject(18647,0,0,-1000,0,0,0,100);
AttachObjectToVehicle(myobject1, GetPlayerVehicleID(playerid), 0.005032,3.225001,-0.114999,0.000000,0.000000,-90.179985);

// doomd1:
new myobject2 = CreateObject(18653,0,0,-1000,0,0,0,100);
AttachObjectToVehicle(myobject2, GetPlayerVehicleID(playerid), 0.750000,-1.950000,-0.709999,0.000000,35.100006,89.099983);

// doomd1:
new myobject3 = CreateObject(18653,0,0,-1000,0,0,0,100);
AttachObjectToVehicle(myobject3, GetPlayerVehicleID(playerid), -0.824999,-1.950000,-0.709999,0.000000,35.100006,89.099983);

// doomd1:
new myobject4 = CreateObject(18653,0,0,-1000,0,0,0,100);
AttachObjectToVehicle(myobject4, GetPlayerVehicleID(playerid), -0.799999,0.750000,-0.709999,0.000000,35.100006,269.999877);

// doomd1:
new myobject5 = CreateObject(18653,0,0,-1000,0,0,0,100);
AttachObjectToVehicle(myobject5, GetPlayerVehicleID(playerid), 0.775000,0.750000,-0.709999,0.000000,35.100006,269.999877);

// doomd1:
new myobject6 = CreateObject(19122,0,0,-1000,0,0,0,100);
AttachObjectToVehicle(myobject6, GetPlayerVehicleID(playerid), 0.974999,1.800000,0.000000,0.000000,0.000000,0.000000);

// doomd1:
new myobject7 = CreateObject(19122,0,0,-1000,0,0,0,100);
AttachObjectToVehicle(myobject7, GetPlayerVehicleID(playerid), 0.974999,1.800000,0.824999,0.000000,0.000000,0.000000);

// doomd1:
new myobject = CreateObject(19122,0,0,-1000,0,0,0,100);
AttachObjectToVehicle(myobject, GetPlayerVehicleID(playerid), -0.974999,1.800000,0.824999,0.000000,0.000000,0.000000);

// doomd1:
new myobject8 = CreateObject(19122,0,0,-1000,0,0,0,100);
AttachObjectToVehicle(myobject8, GetPlayerVehicleID(playerid), -0.974999,1.800000,-0.074999,0.000000,0.000000,0.000000);

// :
new myobject9 = CreateObject(18647,0,0,-1000,0,0,0,100);
AttachObjectToVehicle(myobject9, GetPlayerVehicleID(playerid), 0.005032,3.225001,-0.114999,0.000000,0.000000,-90.179985);

// :
new myobject10 = CreateObject(18653,0,0,-1000,0,0,0,100);
AttachObjectToVehicle(myobject10, GetPlayerVehicleID(playerid), 0.750000,-1.950000,-0.709999,0.000000,35.100006,89.099983);

// :
new myobject99 = CreateObject(18653,0,0,-1000,0,0,0,100);
AttachObjectToVehicle(myobject99, GetPlayerVehicleID(playerid), -0.824999,-1.950000,-0.709999,0.000000,35.100006,89.099983);

// :
new myobject55 = CreateObject(18653,0,0,-1000,0,0,0,100);
AttachObjectToVehicle(myobject55, GetPlayerVehicleID(playerid), -0.799999,0.750000,-0.709999,0.000000,35.100006,269.999877);

// :
new myobject44 = CreateObject(18653,0,0,-1000,0,0,0,100);
AttachObjectToVehicle(myobject44, GetPlayerVehicleID(playerid), 0.775000,0.750000,-0.709999,0.000000,35.100006,269.999877);

// :
new myobject256 = CreateObject(19122,0,0,-1000,0,0,0,100);
AttachObjectToVehicle(myobject256, GetPlayerVehicleID(playerid), 0.974999,1.800000,0.000000,0.000000,0.000000,0.000000);

// :
new myobject33 = CreateObject(19122,0,0,-1000,0,0,0,100);
AttachObjectToVehicle(myobject33, GetPlayerVehicleID(playerid), 0.974999,1.800000,0.824999,0.000000,0.000000,0.000000);

// :
new myobject22 = CreateObject(19122,0,0,-1000,0,0,0,100);
AttachObjectToVehicle(myobject22, GetPlayerVehicleID(playerid), -0.974999,1.800000,0.824999,0.000000,0.000000,0.000000);

// :
new myobject23 = CreateObject(19122,0,0,-1000,0,0,0,100);
AttachObjectToVehicle(myobject23, GetPlayerVehicleID(playerid), -0.974999,1.800000,-0.074999,0.000000,0.000000,0.000000);

// :
new myobject24 = CreateObject(970,0,0,-1000,0,0,0,100);
AttachObjectToVehicle(myobject24, GetPlayerVehicleID(playerid), 1.049999,-0.225000,0.000000,0.000000,0.000000,90.719963);

// :
new myobject66 = CreateObject(970,0,0,-1000,0,0,0,100);
AttachObjectToVehicle(myobject66, GetPlayerVehicleID(playerid), 1.049999,-0.225000,0.674999,0.000000,0.000000,90.719963);

// :
new myobject67 = CreateObject(970,0,0,-1000,0,0,0,100);
AttachObjectToVehicle(myobject67, GetPlayerVehicleID(playerid), -1.179999,-1.810000,-0.374999,0.000000,179.819885,90.719963);

// :
new myobject56 = CreateObject(970,0,0,-1000,0,0,0,100);
AttachObjectToVehicle(myobject56, GetPlayerVehicleID(playerid), 1.204999,-1.810000,-0.374999,0.000000,179.819885,90.719963);

// :
new myobject45 = CreateObject(19279,0,0,-1000,0,0,0,100);
AttachObjectToVehicle(myobject45, GetPlayerVehicleID(playerid), 0.450000,0.974999,0.674999,0.000000,0.000000,0.000000);
}
