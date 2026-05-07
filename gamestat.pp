unit gamestat;

interface
uses common_types;

procedure GameOver(var stat: TStat);
procedure GamePause();

procedure InitStat(var stat: TStat; var offset: TOffset);
procedure IncreaseStat(var stat: TStat);
procedure ShowStat(var stat: TStat);
procedure HideStat(var stat: TStat);

procedure IncreaseSpeed(var stat: TStat);
procedure ShowSpeed(var stat: TStat);
procedure HideSpeed(var stat: TStat);

procedure ShowNextFigure(var stat: TStat; var fig: TFigure);
procedure HideNextFigure(var stat: TStat; var fig: TFigure);

implementation
uses crt, dynamicinput, tetramino, block;

const
    MessageGameOver = 'GAME OVER';
    MessageYourScore = 'YOUR SCORE';
    MessageQuit = 'PRESS ANY KEY TO QUIT';
    MessagePause = 'GAME PAUSED';

procedure GameOver(var stat: TStat);
var
    code: integer;
    len: byte;
begin
    clrscr;
    len := length('GAME');
    TextColor(Red);
    GotoXY(CenterScreenX - len, CenterScreenY);
    write(MessageGameOver);
    GotoXY(CenterScreenX - len, CenterScreenY + 2);
    write(MessageYourScore + ' ', stat.score, '!');
    GotoXY(CenterScreenX - len, ScreenHeight);
    write(MessageQuit);
    GotoXY(1, 1);
    delay(1000);
    GetKey(code);
    TextAttr := StandartTextAttr;
    clrscr;
    halt(0)
end;

procedure GamePause();
var
    code: integer;
    i: byte;
begin
    GotoXY(CenterScreenX - length('GAME'), 1);
    write(MessagePause);
    GotoXY(1, 1);
    repeat
        delay(1000);
        GetKey(code);
        if code = KeyEscape then
        begin
            TextAttr := StandartTextAttr;
            clrscr;
            halt(0)
        end
    until (code = KeySpace);
    GotoXY(CenterScreenX - length('GAME'), 1);
    for i := 1 to length(MessagePause) do
        write(' ');
    GotoXY(1, 1)
end;

procedure InitStat(var stat: TStat; var offset: TOffset);
begin
    stat.score := 0;
    stat.x := offset.x + (LenFieldOfBlocksX * LenBlockX) + 4;
    stat.y := offset.y + 2;
    stat.SpeedIteration := StartSpeed;

    TextColor(Green);
    GotoXY(stat.x, stat.y);
    write('STAT: ', stat.score);
    GotoXY(stat.x, stat.y + 3);
    write('SPEED: ');
    GotoXY(stat.x, stat.y + 6);
    write('NEXT FIGURE:');
end;

procedure IncreaseStat(var stat: TStat);
begin
    stat.score := stat.score + 100;
end;

procedure ShowStat(var stat: TStat);
begin
    GotoXY(stat.x + length('STAT: '), stat.y);
    TextColor(Green);
    write(stat.score);
    GotoXY(1, 1)
end;

procedure HideStat(var stat: TStat);
var
    i: integer;
begin
    GotoXY(stat.x  + length('STAT: '), stat.y);
    for i := 1 to StatMessageLength do
        write(' ');
    GotoXY(1, 1)
end;

procedure ShowSpeed(var stat: TStat);
begin
    TextColor(Green);
    GotoXY(stat.x + length('SPEED: '), stat.y + 3);
    write(stat.SpeedIteration);
    GotoXY(1, 1)
end;

procedure HideSpeed(var stat: TStat);
var
    i: integer;
begin
    GotoXY(stat.x + length('SPEED: '), stat.y + 3);
    for i := 1 to length('50') do
        write(' ');
    GotoXY(1, 1)
end;

procedure IncreaseSpeed(var stat: TStat);
begin
    if stat.SpeedIteration > MaxSpeed then
        stat.SpeedIteration := stat.SpeedIteration - 1
end;

procedure ShowNextFigure(var stat: TStat; var fig: TFigure);
var
    fx, fy, x, y: integer;
    rem_x: integer;
begin
    x := stat.x;
    y := stat.y + 8;
    rem_x := x;

    TextColor(FindFigureColor(fig));

    for fy := 1 to fig.active.y do
    begin
        x := rem_x;
        for fx := 1 to fig.active.x do
        begin
            if fig.all[fx, fy].exists then
                ShowBlock(x, y);
            x := x + LenBlockX
        end;
        y := y + LenBlockY
    end;
    GotoXY(1, 1)
end;

procedure HideNextFigure(var stat: TStat; var fig: TFigure);
var
    fx, fy, x, y: integer;
    rem_x: integer;
begin
    x := stat.x;
    y := stat.y + 8;
    rem_x := x;

    for fy := 1 to fig.active.y do
    begin
        x := rem_x;
        for fx := 1 to fig.active.x do
        begin
            if fig.all[fx, fy].exists then
                HideBlock(x, y);
            x := x + LenBlockX
        end;
        y := y + LenBlockY
    end;
    GotoXY(1, 1)
end;

end.