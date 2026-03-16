#define DIALOG_REGISTER     1
#define DIALOG_LOGIN        2
#define MAX_LOGIN_ATTEMPTS  3

ResetPlayerData(playerid)
{
    new emptyData[E_PLAYER_DATA];
    PlayerData[playerid] = emptyData;
}

SavePlayerData(playerid)
{
    if(!PlayerData[playerid][pLoggedIn]) return 0;

    new query[128];
    mysql_format(gMySQL, query, sizeof(query), "UPDATE `players` SET `admin`=%d WHERE `id`=%d",
        PlayerData[playerid][pAdmin],
        PlayerData[playerid][pID]
    );
    mysql_tquery(gMySQL, query);
    return 1;
}

forward OnPlayerDataCheck(playerid);
public OnPlayerDataCheck(playerid)
{
    if(cache_num_rows() > 0)
    {
        cache_get_value_name_int(0, "id", PlayerData[playerid][pID]);
        cache_get_value_name(0, "password", PlayerData[playerid][pPassword], 65);
        cache_get_value_name_int(0, "admin", PlayerData[playerid][pAdmin]);

        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Account found. Enter your password:", "Login", "Quit");
    }
    else
    {
        ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Register", "Account not found. Choose a password:", "Register", "Quit");
    }
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case DIALOG_REGISTER:
        {
            if(!response) return Kick(playerid);

            if(strlen(inputtext) < 4)
            {
                ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Register", "Password too short! Minimum 4 characters.\nChoose a password:", "Register", "Quit");
                return 1;
            }

            bcrypt_hash(inputtext, 12, "OnPlayerRegister", "d", playerid);
            return 1;
        }
        case DIALOG_LOGIN:
        {
            if(!response) return Kick(playerid);

            bcrypt_check(inputtext, PlayerData[playerid][pPassword], "OnPlayerLogin", "d", playerid);
            return 1;
        }
        case DIALOG_HUD:
        {
            HandleHUDDialog(playerid, response, listitem);
            return 1;
        }
    }
    return 1;
}

forward OnPlayerRegister(playerid);
public OnPlayerRegister(playerid)
{
    new hash[65];
    bcrypt_get_hash(hash);

    new query[256];
    mysql_format(gMySQL, query, sizeof(query), "INSERT INTO `players` (`name`, `password`) VALUES ('%e', '%e')", PlayerData[playerid][pName], hash);
    mysql_tquery(gMySQL, query, "OnPlayerInsert", "d", playerid);
    return 1;
}

forward OnPlayerInsert(playerid);
public OnPlayerInsert(playerid)
{
    PlayerData[playerid][pID] = cache_insert_id();
    PlayerData[playerid][pLoggedIn] = true;

    SendClientMessage(playerid, -1, SERVER_MSG"You have successfully registered!");
    SpawnPlayer(playerid);
    TextDrawShowForPlayer(playerid, tdTime);
    TextDrawShowForPlayer(playerid, tdDate);
    TextDrawShowForPlayer(playerid, tdLogo);
    CreatePlayerHud(playerid);
    if(PlayerData[playerid][pAdmin] >= 6)
    {
        TextDrawShowForPlayer(playerid, tdTick);
        TextDrawShowForPlayer(playerid, tdQueries);
    }
    return 1;
}

forward OnPlayerLogin(playerid);
public OnPlayerLogin(playerid)
{
    if(!bcrypt_is_equal())
    {
        PlayerData[playerid][pLoginAttempts]++;

        if(PlayerData[playerid][pLoginAttempts] >= MAX_LOGIN_ATTEMPTS)
        {
            SendClientMessage(playerid, -1, COL_RED"Too many attempts. You have been disconnected.");
            Kick(playerid);
            return 1;
        }

        va_SendClientMessage(playerid, -1, COL_RED"Wrong password! Attempts remaining: %d/%d", MAX_LOGIN_ATTEMPTS - PlayerData[playerid][pLoginAttempts], MAX_LOGIN_ATTEMPTS);
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Wrong password. Try again:", "Login", "Quit");
        return 1;
    }

    PlayerData[playerid][pLoggedIn] = true;
    SendClientMessage(playerid, -1, SERVER_MSG"You have successfully logged in!");
    SpawnPlayer(playerid);
    TextDrawShowForPlayer(playerid, tdTime);
    TextDrawShowForPlayer(playerid, tdDate);
    TextDrawShowForPlayer(playerid, tdLogo);
    CreatePlayerHud(playerid);
    if(PlayerData[playerid][pAdmin] >= 6)
    {
        TextDrawShowForPlayer(playerid, tdTick);
        TextDrawShowForPlayer(playerid, tdQueries);
    }
    return 1;
}
