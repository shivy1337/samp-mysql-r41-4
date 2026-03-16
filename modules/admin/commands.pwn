cmd:a(playerid, params[])
{
    if(PlayerData[playerid][pAdmin] < 1) return SendClientMessage(playerid, -1, COL_RED"[ERROR] >> " COL_WHITE"You don't have permission.");
    if(isnull(params)) return SendClientMessage(playerid, -1, SERVER_MSG"/a [text]");

    SendAdminMessage(COL_ORANGE"(%d) %s %s: "COL_WHITE"%s", PlayerData[playerid][pAdmin], GetAdminRank(PlayerData[playerid][pAdmin]), PlayerData[playerid][pName], params);
    return 1;
}

cmd:fly(playerid, params[])
{
    if(PlayerData[playerid][pAdmin] < 1) return SendClientMessage(playerid, -1, SERVER_MSG"You don't have permission");

    if(!PlayerData[playerid][pFlying])
    {
        SendClientMessage(playerid, -1, SERVER_MSG"Fly mode activated.");
        SetPlayerHealth(playerid, 99999.0);
        StartFly(playerid);
        PlayerData[playerid][pFlying] = true;
        SendAdminMessage(COL_RED"[ADMIN] >> "COL_WHITE"%s activated fly.", PlayerData[playerid][pName]);
    }
    else
    {
        SendClientMessage(playerid, -1, SERVER_MSG"Fly mode deactivated.");
        SetPlayerHealth(playerid, 100.0);
        StopFly(playerid);
        PlayerData[playerid][pFlying] = false;
        SendAdminMessage(COL_RED "[ADMIN] >> "COL_WHITE" %s" " deactivated fly.", PlayerData[playerid][pName]);
    }
    return 1;
}

cmd:spawncar(playerid, params[])
{
    if(PlayerData[playerid][pAdmin] < 1) return SendClientMessage(playerid, -1, SERVER_MSG"You don't have permission.");

    new modelid;
    if(sscanf(params, "d", modelid)) return SendClientMessage(playerid, -1, SERVER_MSG"/spawncar [model id 400-611]");
    if(modelid < 400 || modelid > 611) return SendClientMessage(playerid, -1, SERVER_MSG"Model ID must be between 400 and 611.");

    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    new vehicleid = CreateVehicle(modelid, x + 3.0, y, z, a, -1, -1, -1);
    PutPlayerInVehicle(playerid, vehicleid, 0);
    gTotalVehicles++;

    va_SendClientMessage(playerid, -1, SERVER_MSG"You have spawned vehicle %d.", modelid);
    SendAdminMessage(COL_RED"[ADMIN] >> "COL_WHITE"%s spawned vehicle %d. Total vehicles: %d", PlayerData[playerid][pName], modelid, gTotalVehicles);
    return 1;
}

cmd:ah(playerid, params[])
{
    if(PlayerData[playerid][pAdmin] < 1) return SendClientMessage(playerid, -1, SERVER_MSG "You don't have permission.");
    SendClientMessage(playerid, -1, COL_RED"=== Admin Help ===");
    SendClientMessage(playerid, -1, COL_RED"Trial Admin:" COL_WHITE" /spawncar, /fly, /a, /kick");

    if(PlayerData[playerid][pAdmin] >= 2)
    SendClientMessage(playerid, -1, COL_RED"Junior Admin:" COL_WHITE" ");

    if(PlayerData[playerid][pAdmin] >= 3)
    SendClientMessage(playerid, -1, COL_RED"Moderator:" COL_WHITE" ");

    if(PlayerData[playerid][pAdmin] >= 4)
    SendClientMessage(playerid, -1, COL_RED"Senior Admin:" COL_WHITE" ");

    if(PlayerData[playerid][pAdmin] >= 5)
    SendClientMessage(playerid, -1, COL_RED"Head Admin:" COL_WHITE" ");

    if(PlayerData[playerid][pAdmin] >= 6)
    SendClientMessage(playerid, -1, COL_RED"Founder:" COL_WHITE" /setadmin");

    if(PlayerData[playerid][pAdmin] >= 7)
    SendClientMessage(playerid, -1, COL_RED"Developer:" COL_WHITE" ");

    return 1;
}

cmd:setadmin(playerid, params[])
{
    if(strcmp(PlayerData[playerid][pName], "shivy") != 0 && PlayerData[playerid][pAdmin] < 6)
        return SendClientMessage(playerid, -1, COL_RED"[ERROR] >> " COL_WHITE"You don't have permission.");

    new targetid, level, reason[64];
    if(sscanf(params, "dds[64]", targetid, level, reason)) return SendClientMessage(playerid, -1, SERVER_MSG"/setadmin [id] [level 0-7] [reason]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, -1, SERVER_MSG"Player is not connected.");
    if(level < 0 || level > 7) return SendClientMessage(playerid, -1, SERVER_MSG"Admin level must be between 0-7.");

    PlayerData[targetid][pAdmin] = level;
    SavePlayerData(targetid);

    va_SendClientMessage(targetid, -1, COL_LIGHTBLUE"Admin %s has set your admin level to %d. Reason: %s", PlayerData[playerid][pName], level, reason);
    va_SendClientMessage(playerid, -1, SERVER_MSG"You have set %s's admin level to %d. Reason: %s", PlayerData[targetid][pName], level, reason);
    SendAdminMessage(COL_RED"[ADMIN] >> %s set %s's admin level to %d. Reason: %s", PlayerData[playerid][pName], PlayerData[targetid][pName], level, reason);
    return 1;
}

forward DelayKick(playerid);
public DelayKick(playerid)
{
    Kick(playerid);
}

cmd:kick(playerid, params[])
{
    if(PlayerData[playerid][pAdmin] < 1) return SendClientMessage(playerid, -1, SERVER_MSG"You don't have permission.");

    new targetid, reason[64];
    if(sscanf(params, "ds[64]", targetid, reason)) return SendClientMessage(playerid, -1, SERVER_MSG"/kick [id] [reason]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, -1, COL_RED"Player is not connected.");
    if(targetid == playerid) return SendClientMessage(playerid, -1, COL_RED"You can't kick yourself.");
    if(PlayerData[targetid][pAdmin] >= PlayerData[playerid][pAdmin]) return SendClientMessage(playerid, -1, SERVER_MSG"You can't kick a higher or equal admin.");

    va_SendClientMessage(targetid, -1, COL_RED"You have been kicked by %s. Reason: %s", PlayerData[playerid][pName], reason);
    va_SendClientMessageToAll(-1, COL_RED"AdmBot: %s has been kicked by admin %s. Reason: %s", PlayerData[targetid][pName], PlayerData[playerid][pName], reason);
    SendAdminMessage(COL_RED"[ADMIN] >> "COL_WHITE"%s kicked %s. Reason: %s", PlayerData[playerid][pName], PlayerData[targetid][pName], reason);
    SetTimerEx("DelayKick", 100, false, "d", targetid);
    return 1;
}