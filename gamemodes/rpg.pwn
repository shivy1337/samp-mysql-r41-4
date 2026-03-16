#include <a_samp>
#include <Pawn.CMD>
#include <sscanf2>
#include <a_mysql>
#include <streamer>
#include <bcrypt>
#include <fly>
#include <YSI_Coding\y_va>
#include <YSI_Data\y_iterate>

#define MYSQL_HOST "127.0.0.1"
#define MYSQL_USER "root"
#define MYSQL_PASS ""
#define MYSQL_DB   "rpg"

new MySQL:gMySQL;
new gTotalVehicles = 0;

enum E_PLAYER_DATA
{
    pID,
    pName[MAX_PLAYER_NAME],
    pPassword[65],
    pAdmin,
    bool:pLoggedIn,
    pLoginAttempts,
    bool:pFlying
}

new PlayerData[MAX_PLAYERS][E_PLAYER_DATA];

// Modules
#include "../modules/core/colors.pwn"
#include "../modules/core/utils.pwn"
#include "../modules/core/objects.pwn"
#include "../modules/core/hud.pwn"
#include "../modules/player/commands.pwn"
#include "../modules/player/auth.pwn"
#include "../modules/admin/utils.pwn"
#include "../modules/admin/commands.pwn"
#include "../modules/vehicle/engine.pwn"


main() {}

public OnGameModeInit()
{
    gMySQL = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASS, MYSQL_DB);
    if(mysql_errno(gMySQL) != 0)
    {
        printf("[MYSQL] Connection error!");
        SendRconCommand("exit");
        return 1;
    }
    printf("[MYSQL] Database connected.");
    SetGameModeText("ONY v0.1");
    AddPlayerClass(184, 1154.0610, -1767.6342, 16.5938, 1.8900, 0, 0, 0, 0, 0, 0);
    UsePlayerPedAnims();
    DisableInteriorEnterExits();
    EnableStuntBonusForAll(0);
    ManualVehicleEngineAndLights();
    LoadSpawnObjects();
    CreateHud();
    SetTimer("UpdateHUD", 1000, true);
    UpdateHUD();
    return 1;
}

public OnGameModeExit()
{
    mysql_close(gMySQL);
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    if(PlayerData[playerid][pLoggedIn])
    {
        SavePlayerData(playerid);
    }
    ResetPlayerData(playerid);
    return 1;
}

public OnPlayerConnect(playerid)
{
    ResetPlayerData(playerid);
    GetPlayerName(playerid, PlayerData[playerid][pName], MAX_PLAYER_NAME);

    new query[96];
    mysql_format(gMySQL, query, sizeof(query), "SELECT `id`,`password`,`admin` FROM `players` WHERE `name`='%e' LIMIT 1", PlayerData[playerid][pName]);
    mysql_tquery(gMySQL, query, "OnPlayerDataCheck", "d", playerid);
    return 1;
}


public OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{
    if(!PlayerData[playerid][pLoggedIn]) return 0;
    return 1;
}

public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{
    if(result == -1)
        SendClientMessage(playerid, -1, SERVER_MSG"Unknown command. Use /help.");
    return 1;
}