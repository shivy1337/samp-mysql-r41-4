static const gVehicleNames[][] = {
    "Landstalker","Bravura","Buffalo","Linerunner","Perennial","Sentinel","Dumper","Firetruck","Trashmaster",
    "Stretch","Manana","Infernus","Voodoo","Pony","Mule","Cheetah","Ambulance","Leviathan","Moonbeam",
    "Esperanto","Taxi","Washington","Bobcat","Mr Whoopee","BF Injection","Hunter","Premier","Enforcer",
    "Securicar","Banshee","Predator","Bus","Rhino","Barracks","Hotknife","Trailer","Previon","Coach",
    "Cabbie","Stallion","Rumpo","RC Bandit","Romero","Packer","Monster","Admiral","Squalo","Seasparrow",
    "Pizzaboy","Tram","Trailer","Turismo","Speeder","Reefer","Tropic","Flatbed","Yankee","Caddy",
    "Solair","Berkley's RC Van","Skimmer","PCJ-600","Faggio","Freeway","RC Baron","RC Raider","Glendale",
    "Oceanic","Sanchez","Sparrow","Patriot","Quad","Coastguard","Dinghy","Hermes","Sabre","Rustler",
    "ZR-350","Walton","Regina","Comet","BMX","Burrito","Camper","Marquis","Baggage","Dozer",
    "Maverick","News Chopper","Rancher","FBI Rancher","Virgo","Greenwood","Jetmax","Hotring Racer",
    "Sandking","Blista Compact","Police Maverick","Boxville","Benson","Mesa","RC Goblin","Hotring Racer",
    "Hotring Racer","Bloodring Banger","Rancher","Super GT","Elegant","Journey","Bike","Mountain Bike",
    "Beagle","Cropduster","Stuntplane","Tanker","Roadtrain","Nebula","Majestic","Buccaneer","Shamal",
    "Hydra","FCR-900","NRG-500","HPV1000","Cement Truck","Tow Truck","Fortune","Cadrona","FBI Truck",
    "Willard","Forklift","Tractor","Combine","Feltzer","Remington","Slamvan","Blade","Freight",
    "Streak","Vortex","Vincent","Bullet","Clover","Sadler","Firetruck","Hustler","Intruder","Primo",
    "Cargobob","Tampa","Sunrise","Merit","Utility","Nevada","Yosemite","Windsor","Monster","Monster",
    "Uranus","Jester","Sultan","Stratum","Elegy","Raindance","RC Tiger","Flash","Tahoma","Savanna",
    "Bandito","Freight","Trailer","Kart","Mower","Dune","Sweeper","Broadway","Tornado","AT-400",
    "DFT-30","Huntley","Stafford","BF-400","Newsvan","Tug","Trailer","Emperor","Wayfarer","Euros",
    "Hotdog","Club","Trailer","Trailer","Andromada","Dodo","RC Cam","Launch","Police Car","Police Car",
    "Police Car","Police Ranger","Picador","S.W.A.T.","Alpha","Phoenix","Glendale","Sadler",
    "Luggage Trailer","Luggage Trailer","Stair Trailer","Boxville","Farm Plow","Utility Trailer"
};

GetVehicleName(vehicleid, name[], len = sizeof(name))
{
    new modelid = GetVehicleModel(vehicleid);
    if(modelid < 400 || modelid > 611) return format(name, len, "Unknown");
    return format(name, len, "%s", gVehicleNames[modelid - 400]);
}


ToggleVehicleEngine(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(!vehicleid) return SendClientMessage(playerid, -1, COL_RED"[ERROR] >> "COL_WHITE"You are not in a vehicle.");
    if(GetPlayerVehicleSeat(playerid) != 0) return SendClientMessage(playerid, -1, COL_RED"[ERROR] >> "COL_WHITE"You are not the driver.");

    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

    new vehname[32];
    GetVehicleName(vehicleid, vehname);

    if(engine == VEHICLE_PARAMS_OFF || engine == VEHICLE_PARAMS_UNSET)
    {
        SetVehicleParamsEx(vehicleid, VEHICLE_PARAMS_ON, lights, alarm, doors, bonnet, boot, objective);
        va_SendClientMessage(playerid, -1, COL_WHITE"You started the engine of %s.", vehname);
        SendNearbyMessage(playerid, 20.0, COL_GREY"* %s started the engine of %s.", PlayerData[playerid][pName], vehname);
    }
    else
    {
        SetVehicleParamsEx(vehicleid, VEHICLE_PARAMS_OFF, lights, alarm, doors, bonnet, boot, objective);
        va_SendClientMessage(playerid, -1, COL_WHITE"You stopped the engine of %s.", vehname);
        SendNearbyMessage(playerid, 20.0, COL_GREY"* %s stopped the engine of %s.", PlayerData[playerid][pName], vehname);
    }
    return 1;
}

cmd:engine(playerid, params[])
{
    return ToggleVehicleEngine(playerid);
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(newkeys & KEY_SECONDARY_ATTACK)
    {
        if(PlayerData[playerid][pFlying])
        {
            SetPlayerHealth(playerid, 100.0);
            StopFly(playerid);
            PlayerData[playerid][pFlying] = false;
            SendClientMessage(playerid, -1, SERVER_MSG"Fly mode deactivated.");
            SendAdminMessage(COL_RED"[ADMIN] >> "COL_WHITE"%s deactivated fly.", PlayerData[playerid][pName]);
        }
    }
    if(newkeys & KEY_SUBMISSION)
    {
        if(IsPlayerInAnyVehicle(playerid) && GetPlayerVehicleSeat(playerid) == 0)
        {
            ToggleVehicleEngine(playerid);
        }
    }
    return 1;
}
