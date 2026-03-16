#define DIALOG_HUD 3

new bool:pHudFPS[MAX_PLAYERS] = {true, ...};
new bool:pHudAdmin[MAX_PLAYERS] = {true, ...};

ShowHUDDialog(playerid)
{
    new str[128];
    if(PlayerData[playerid][pAdmin] >= 6)
        format(str, sizeof(str), "FPS: %s%s\nAdmin HUD: %s%s",
            pHudFPS[playerid] ? (COL_GREEN) : (COL_RED),
            pHudFPS[playerid] ? ("ON") : ("OFF"),
            pHudAdmin[playerid] ? (COL_GREEN) : (COL_RED),
            pHudAdmin[playerid] ? ("ON") : ("OFF")
        );
    else
        format(str, sizeof(str), "FPS: %s%s",
            pHudFPS[playerid] ? (COL_GREEN) : (COL_RED),
            pHudFPS[playerid] ? ("ON") : ("OFF")
        );

    ShowPlayerDialog(playerid, DIALOG_HUD, DIALOG_STYLE_LIST, "HUD Settings", str, "Toggle", "Close");
}

cmd:hud(playerid, params[])
{
    ShowHUDDialog(playerid);
    return 1;
}

HandleHUDDialog(playerid, response, listitem)
{
    if(!response) return 1;

    switch(listitem)
    {
        case 0: 
        {
            pHudFPS[playerid] = !pHudFPS[playerid];
            if(pHudFPS[playerid])
                PlayerTextDrawShow(playerid, tdFPS[playerid]);
            else
                PlayerTextDrawHide(playerid, tdFPS[playerid]);

            va_SendClientMessage(playerid, -1, SERVER_MSG"FPS HUD: %s", pHudFPS[playerid] ? ("Enabled") : ("Disabled"));
        }
        case 1:
        {
            if(PlayerData[playerid][pAdmin] < 6)
                return SendClientMessage(playerid, -1, COL_RED"You need admin level 6+.");

            pHudAdmin[playerid] = !pHudAdmin[playerid];
            if(pHudAdmin[playerid])
            {
                TextDrawShowForPlayer(playerid, tdTick);
                TextDrawShowForPlayer(playerid, tdQueries);
            }
            else
            {
                TextDrawHideForPlayer(playerid, tdTick);
                TextDrawHideForPlayer(playerid, tdQueries);
            }
            va_SendClientMessage(playerid, -1, SERVER_MSG"Admin HUD: %s", pHudAdmin[playerid] ? ("Enabled") : ("Disabled"));
        }
    }
    
    ShowHUDDialog(playerid);
    return 1;
}


cmd:admins(playerid, params[])
{
    new count = 0;

    SendClientMessage(playerid, -1, COL_WHITE"--- Admins Online ---");

    foreach(new i : Player)
    {
        if(PlayerData[i][pAdmin] >= 1)
        {
            va_SendClientMessage(playerid, -1, COL_WHITE"  %s - %s (%d)", PlayerData[i][pName], GetAdminRank(PlayerData[i][pAdmin]), PlayerData[i][pAdmin]);
            count++;
        }
    }

    if(count == 0)
    {
        SendClientMessage(playerid, -1, COL_RED"  No admins online at the moment.");
    }

    va_SendClientMessage(playerid, -1, COL_WHITE"Total: "COL_RED"%d" COL_WHITE"admins online.", count);
    return 1;
}