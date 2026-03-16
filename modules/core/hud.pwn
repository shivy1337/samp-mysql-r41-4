new Text:tdTime;
new Text:tdDate;
new Text:tdLogo;
new Text:tdTick;
new Text:tdQueries;
new gQueryCount = 0;
new PlayerText:tdNameID[MAX_PLAYERS];
new PlayerText:tdFPS[MAX_PLAYERS];
new gPlayerFPS[MAX_PLAYERS];
new gPlayerDrunkLevel[MAX_PLAYERS];

CreateHud()
{
    tdTime = TextDrawCreate(595.0, 43.0, "00:00");
    TextDrawFont(tdTime, 3);
    TextDrawLetterSize(tdTime, 0.487499, 2.599998);
    TextDrawTextSize(tdTime, 400.0, 17.0);
    TextDrawSetOutline(tdTime, 1);
    TextDrawSetShadow(tdTime, 1);
    TextDrawAlignment(tdTime, 3);
    TextDrawColor(tdTime, -1);
    TextDrawBackgroundColor(tdTime, 255);
    TextDrawUseBox(tdTime, 0);
    TextDrawSetProportional(tdTime, 1);
    TextDrawSetSelectable(tdTime, 0);

    tdDate = TextDrawCreate(598.0, 23.0, "00/00/0000");
    TextDrawFont(tdDate, 3);
    TextDrawLetterSize(tdDate, 0.274999, 2.449999);
    TextDrawTextSize(tdDate, 400.0, 17.0);
    TextDrawSetOutline(tdDate, 1);
    TextDrawSetShadow(tdDate, 1);
    TextDrawAlignment(tdDate, 3);
    TextDrawColor(tdDate, -1);
    TextDrawBackgroundColor(tdDate, 255);
    TextDrawUseBox(tdDate, 0);
    TextDrawSetProportional(tdDate, 1);
    TextDrawSetSelectable(tdDate, 0);

    tdLogo = TextDrawCreate(555.0, 428.0, "rpg.github.ro");
    TextDrawFont(tdLogo, 3);
    TextDrawLetterSize(tdLogo, 0.366666, 2.0);
    TextDrawTextSize(tdLogo, 400.0, 17.0);
    TextDrawSetOutline(tdLogo, 1);
    TextDrawSetShadow(tdLogo, 2);
    TextDrawAlignment(tdLogo, 1);
    TextDrawColor(tdLogo, -3841);
    TextDrawBackgroundColor(tdLogo, 255);
    TextDrawUseBox(tdLogo, 0);
    TextDrawSetProportional(tdLogo, 1);
    TextDrawSetSelectable(tdLogo, 0);

    tdTick = TextDrawCreate(280.0, 430.0, "Ticks: ~r~~h~200");
    TextDrawFont(tdTick, 2);
    TextDrawLetterSize(tdTick, 0.183333, 1.8);
    TextDrawTextSize(tdTick, 400.0, 17.0);
    TextDrawSetOutline(tdTick, 1);
    TextDrawSetShadow(tdTick, 0);
    TextDrawAlignment(tdTick, 1);
    TextDrawColor(tdTick, -1);
    TextDrawBackgroundColor(tdTick, 255);
    TextDrawUseBox(tdTick, 0);
    TextDrawSetProportional(tdTick, 1);
    TextDrawSetSelectable(tdTick, 0);

    tdQueries = TextDrawCreate(325.0, 430.0, "Queries: ~g~0");
    TextDrawFont(tdQueries, 2);
    TextDrawLetterSize(tdQueries, 0.183333, 1.8);
    TextDrawTextSize(tdQueries, 400.0, 17.0);
    TextDrawSetOutline(tdQueries, 1);
    TextDrawSetShadow(tdQueries, 0);
    TextDrawAlignment(tdQueries, 1);
    TextDrawColor(tdQueries, -1);
    TextDrawBackgroundColor(tdQueries, 255);
    TextDrawUseBox(tdQueries, 0);
    TextDrawSetProportional(tdQueries, 1);
    TextDrawSetSelectable(tdQueries, 0);
}

forward UpdateHUD();
public UpdateHUD()
{
    new str[32];

    // Time - every call
    new hour, minute, second;
    gettime(hour, minute, second);
    format(str, sizeof(str), "%02d:%02d", hour, minute);
    TextDrawSetString(tdTime, str);

    // Date - only at midnight or first call
    static lastDay = -1;
    new year, month, day;
    getdate(year, month, day);
    if(day != lastDay)
    {
        format(str, sizeof(str), "%02d/%02d/%d", day, month, year);
        TextDrawSetString(tdDate, str);
        lastDay = day;
    }

    // Admin stats
    format(str, sizeof(str), "Ticks: ~r~~h~%d", GetServerTickRate());
    TextDrawSetString(tdTick, str);
    format(str, sizeof(str), "Queries: ~g~%d", gQueryCount);
    TextDrawSetString(tdQueries, str);

    UpdateAllFPS();
    return 1;
}

CreatePlayerHud(playerid)
{
    new str[32];
    format(str, sizeof(str), "%s(ID: %d)", PlayerData[playerid][pName], playerid);
    
    tdNameID[playerid] = CreatePlayerTextDraw(playerid, 640.0, 412.0, str);
    PlayerTextDrawFont(playerid, tdNameID[playerid], 1);
    PlayerTextDrawLetterSize(playerid, tdNameID[playerid], 0.229167, 2.0);
    PlayerTextDrawTextSize(playerid, tdNameID[playerid], 400.0, 17.0);
    PlayerTextDrawSetOutline(playerid, tdNameID[playerid], 1);
    PlayerTextDrawSetShadow(playerid, tdNameID[playerid], 2);
    PlayerTextDrawAlignment(playerid, tdNameID[playerid], 3);
    PlayerTextDrawColor(playerid, tdNameID[playerid], -3841);
    PlayerTextDrawBackgroundColor(playerid, tdNameID[playerid], 255);
    PlayerTextDrawUseBox(playerid, tdNameID[playerid], 0);
    PlayerTextDrawSetProportional(playerid, tdNameID[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, tdNameID[playerid], 0);
    PlayerTextDrawShow(playerid, tdNameID[playerid]);

    tdFPS[playerid] = CreatePlayerTextDraw(playerid, 59.0, 430.0, "FPS: ~y~0");
    PlayerTextDrawFont(playerid, tdFPS[playerid], 2);
    PlayerTextDrawLetterSize(playerid, tdFPS[playerid], 0.183333, 1.8);
    PlayerTextDrawTextSize(playerid, tdFPS[playerid], 400.0, 17.0);
    PlayerTextDrawSetOutline(playerid, tdFPS[playerid], 1);
    PlayerTextDrawSetShadow(playerid, tdFPS[playerid], 0);
    PlayerTextDrawAlignment(playerid, tdFPS[playerid], 1);
    PlayerTextDrawColor(playerid, tdFPS[playerid], -1);
    PlayerTextDrawBackgroundColor(playerid, tdFPS[playerid], 255);
    PlayerTextDrawUseBox(playerid, tdFPS[playerid], 0);
    PlayerTextDrawSetProportional(playerid, tdFPS[playerid], 1);
    PlayerTextDrawSetSelectable(playerid, tdFPS[playerid], 0);
    PlayerTextDrawShow(playerid, tdFPS[playerid]);

    SetPlayerDrunkLevel(playerid, 2000);
    gPlayerDrunkLevel[playerid] = 0;
    gPlayerFPS[playerid] = 0;
}

UpdateAllFPS()
{
    new str[16];
    foreach(new i : Player)
    {
        new drunklevel = GetPlayerDrunkLevel(i);
        if(drunklevel < 100)
        {
            SetPlayerDrunkLevel(i, 2000);
        }
        else if(gPlayerDrunkLevel[i] != drunklevel)
        {
            gPlayerFPS[i] = gPlayerDrunkLevel[i] - drunklevel;
            gPlayerDrunkLevel[i] = drunklevel;

            if(gPlayerFPS[i] > 0 && gPlayerFPS[i] < 300)
            {
                format(str, sizeof(str), "FPS: ~y~%d", gPlayerFPS[i]);
                PlayerTextDrawSetString(i, tdFPS[i], str);
            }
        }
    }
}