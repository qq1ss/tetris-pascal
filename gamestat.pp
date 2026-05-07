unit gamestat;

interface
uses common_types;

procedure GameOver(var stat: TStat; SaveTextAttr: integer);
procedure GamePause();

procedure InitStat(var stat: TStat; var offset: TOffset);
procedure IncreaseStat(var stat: TStat);
procedure ShowStat(var stat: TStat);
procedure HideStat(var stat: TStat);

procedure IncreaseSpeed(var stat: TStat);
procedure ShowSpeed(var stat: TStat);
procedure HideSpeed(var stat: TStat);

implementation
uses crt, dynamicinput;

const
    MessageGameOver = 'GAME OVER';
    MessageYourScore = 'YOUR SCORE';

procedure GameOver(var stat: TStat; SaveTextAttr: integer);
var
    code: integer;
begin
    clrscr;
    TextColor(Red);
    GotoXY(CenterScreenX - length('GAME'), CenterScreenY);
    write(MessageGameOver);
    GotoXY(CenterScreenX - length('YOUR'), CenterScreenY + 1);
    write(MessageYourScore + ' ', stat.score);
    GotoXY(1, 1);
    GetKey(code);
    TextAttr := SaveTextAttr;
    clrscr;
    halt(0)
end;

procedure GamePause();
var
    code: integer;
begin
    repeat
        GetKey(code);
        delay(DelayDuration)
    until (code = KeySpace)
end;

procedure InitStat(var stat: TStat; var offset: TOffset);
begin
    stat.score := 0;
    stat.x := offset.x + (LenFieldOfBlocksX * LenBlockX) + 4;
    stat.y := offset.y + 2;
    stat.SpeedIteration := StartSpeed;
end;

procedure IncreaseStat(var stat: TStat);
begin
    stat.score := stat.score + 100;
end;

procedure ShowStat(var stat: TStat);
begin
    GotoXY(stat.x, stat.y);
    TextColor(Green);
    write('STAT: ', stat.score);
    GotoXY(1, 1);
end;

procedure HideStat(var stat: TStat);
var
    i: integer;
begin
    GotoXY(stat.x, stat.y);
    for i := 1 to StatMessageLength do
        write(' ');
    GotoXY(1, 1)
end;

procedure ShowSpeed(var stat: TStat);
begin
    GotoXY(stat.x, stat.y + 3);
    TextColor(Green);
    write('SPEED: ', stat.SpeedIteration);
    GotoXY(1, 1);
end;

procedure HideSpeed(var stat: TStat);
var
    i: integer;
begin
    GotoXY(stat.x, stat.y + 3);
    for i := 1 to length('SPEED: 50') do
        write(' ');
    GotoXY(1, 1)
end;

procedure IncreaseSpeed(var stat: TStat);
begin
    if stat.SpeedIteration > MaxSpeed then
        stat.SpeedIteration := stat.SpeedIteration - 1
end;

procedure ShowNextFigure(var stat: TStat);
begin
end;

procedure HideNextFigure(var stat: TStat);
begin
end;

end.