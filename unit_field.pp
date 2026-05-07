unit unit_field;

interface
uses common_types;

procedure InitField(var field: TField; var offset:TOffset);
procedure ShowField(var field: TField; var offset: TOffset);
procedure HideField(var field: TField; var offset: TOffset);
procedure CheckAndDelLines(var field: TField; var stat: TStat);
procedure ShowBorders(var offset: TOffset);

implementation
uses crt, block, gamestat;

type
    TLine = array [1..LenFieldOfBlocksX] of TBlock;

procedure InitField(var field: TField; var offset: TOffset);
var
    x, y: byte;
begin
    offset.x :=
        (ScreenWidth div 2) - ((LenFieldOfBlocksX * LenBlockX) div 2);
    offset.y :=
        (ScreenHeight div 2) - ((LenFieldOfBlocksY * LenBlockY) div 2);
    for y := 1 to LenFieldOfBlocksY do
    begin
        for x := 1 to LenFieldOfBlocksX do
        begin
           field[x, y].exists := false;
           field[x, y].color := Black
        end
    end;
end;

procedure ShowField(var field: TField; var offset: TOffset);
var
    fx, fy: byte;
    x, y: integer;
    rem_x: integer;
    SaveTextAttr: integer;
begin
    SaveTextAttr := TextAttr;

    x := offset.x;
    y := offset.y;
    rem_x := x;

    for fy := 1 to LenFieldOfBlocksY do
    begin
        x := rem_x;
        for fx := 1 to LenFieldOfBlocksX do
        begin
            if field[fx, fy].exists then
            begin
                TextColor(field[fx, fy].color);
                ShowBlock(x, y)
            end
            else
                HideBlock(x, y);
            x := x + LenBlockX
        end;
        y := y + LenBlockY
    end;
    TextAttr := SaveTextAttr;
    GotoXY(1, 1)
end;

procedure HideField(var field: TField; var offset: TOffset);
var
    fx, fy: byte;
    x, y: integer;
    rem_x: integer;
begin
    x := offset.x;
    y := offset.y;
    rem_x := x;

    for fy := 1 to LenFieldOfBlocksY do
    begin
        x := rem_x;
        for fx := 1 to LenFieldOfBlocksX do
        begin
            HideBlock(x, y);
            x := x + LenBlockX
        end;
        y := y + LenBlockY
    end;
    GotoXY(1, 1)
end;

function BlockExistsInLine(var field: TField; y: byte): boolean;
var
    fx, fy: byte;
begin
    BlockExistsInLine := false;

    for fy := (y - 1) downto 1 do
    begin
        for fx := 1 to LenFieldOfBlocksX do
        begin
            if field[fx, fy].exists then
            begin
                BlockExistsInLine := true;
                exit
            end
        end
    end
end;

function CopyLine(var field: TField; y: byte): TLine;
var
    x: byte;
begin
    for x := 1 to LenFieldOfBlocksX do
        CopyLine[x] := field[x, y]
end;

procedure PasteLine(var field: TField; y: byte; line: TLine);
var
    x: byte;
begin
    for x := 1 to LenFieldOfBlocksX do
        field[x, y] := line[x]
end;

procedure DeleteLine(var field: TField; y: byte);
var
    x: byte;
begin
    for x := 1 to LenFieldOfBlocksX do
        field[x, y].exists := false
end;

procedure MoveDownLines(var field: TField; y: byte);
var
    fy: byte;
begin
    for fy := y downto 2 do
    begin
        if not BlockExistsInLine(field, y) then
            exit;
        PasteLine(field, fy, CopyLine(field, fy - 1))
    end;
    DeleteLine(field, 1)
end;

procedure CheckAndDelLines(var field: TField; var stat: TStat);
var
    x, y: byte;
    FullLine: boolean;
begin
    y := LenFieldOfBlocksY;

    while y >= 1 do
    begin
        FullLine := true;
        for x := 1 to LenFieldOfBlocksX do
        begin
            if not field[x, y].exists then
            begin
                FullLine := false;
                break
            end
        end;
        if FullLine then
        begin
            DeleteLine(field, y);
            MoveDownLines(field, y);
            HideStat(stat);
            IncreaseStat(stat);
            ShowStat(stat);
            HideSpeed(stat);
            IncreaseSpeed(stat);
            ShowSpeed(stat);
            continue
        end;
        y := y - 1
    end
end;

procedure ShowBorders(var offset: TOffset);
var
    i: integer;
begin
    GotoXY(offset.x - 1, offset.y - 1);
    for i := 1 to (LenFieldOfBlocksX * LenBlockX) + 2 + StatMessageLength + 5 do
        write(BorderChar);

    for i := 0 to (LenFieldOfBlocksY * LenBlockY) - 1 do
    begin
        GotoXY(offset.x - 1, offset.y + i);
        write(BorderChar);
        GotoXY(offset.x + (LenFieldOfBlocksX * LenBlockX), offset.y + i);
        write(BorderChar);
        GotoXY(
            offset.x + (LenFieldOfBlocksX * LenBlockX) +
                LenFieldStatX, offset.y + i
        );
        write(BorderChar)
    end;
    GotoXY(offset.x - 1, offset.y + (LenFieldOfBlocksY * LenBlockY));
    for i := 1 to (LenFieldOfBlocksX * LenBlockX) + 2 + LenFieldStatX do
        write(BorderChar)
end;

end.