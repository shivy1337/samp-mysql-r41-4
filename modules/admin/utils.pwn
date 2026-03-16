SendAdminMessage(const fmat[], {Float, _}:...)
{
    new msg[192];
    va_format(msg, sizeof(msg), fmat, va_start<1>);
    foreach(new i : Player)
    {
        if(PlayerData[i][pAdmin] >= 1)
        {
            SendClientMessage(i, -1, msg);
        }
    }
    return 1;
}

GetAdminRank(level)
{
    new rank[20];
    switch(level)
    {
        case 1: rank = "Trial Admin";
        case 2: rank = "Junior Mod";
        case 3: rank = "Moderator";
        case 4: rank = "Senior Admin";
        case 5: rank = "Head Admin";
        case 6: rank = "Founder";
        case 7: rank = "Developer";
        default: rank = "Player";
    }
    return rank;
}
