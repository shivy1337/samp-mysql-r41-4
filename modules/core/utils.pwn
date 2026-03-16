SendNearbyMessage(playerid, Float:radius, const fmat[], {Float, _}:...)
{
    new msg[144];
    va_format(msg, sizeof(msg), fmat, va_start<3>);
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    foreach(new i : Player)
    {
        if(IsPlayerInRangeOfPoint(i, radius, x, y, z))
            SendClientMessage(i, -1, msg);
    }
    return 1;
}
