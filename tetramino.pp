unit tetramino;

interface
uses common_types;

procedure InitFigure(var fig: TFigure);

procedure RotateFigureLeft(var fig: TFigure);
procedure RotateFigureRight(var fig: TFigure);

procedure ShowFigure(var fig: TFigure; var offset: TOffset);
procedure HideFigure(var fig: TFigure; var offset: TOffset);

procedure MoveDownFigure(var fig: TFigure);
procedure MoveLeftFigure(var fig: TFigure);
procedure MoveRightFigure(var fig: TFigure);

function OutOfWall(var field: TField; var fig: TFigure): boolean;
function InExistsBlocks(var field: TField; var fig: TFigure): boolean;
function CanRotateLeft(var field: TField; var fig: TFigure): boolean;
function CanRotateRight(var field: TField; var fig: TFigure): boolean;
function DownPosIsFree(var field: TField; var fig: TFigure): boolean;
function LeftPosIsFree(var field: TField; var fig: TFigure): boolean;
function RightPosIsFree(var field: TField; var fig: TFigure): boolean;

procedure StopFigure(var field: TField; var fig: TFigure);
procedure ForceDrop(
    var field: TField; var fig: TFigure; var offset: TOffset;
    SaveTextAttr: integer; var Stat: TStat
);

implementation
uses crt, block, unit_field, gamestat;

procedure InitColomn(var fig: TFigure; column: byte);
var
    i: byte;
begin
    for i := 1 to LenFigureOfBlocks do
    begin
        fig.all[column, i].exists := false;
        fig.all[column, i].color := Black
    end
end;

procedure InitCleanFigure(var fig: TFigure);
var
    i: byte;
begin
    for i := 1 to LenFigureOfBlocks do
        InitColomn(fig, i)
end;

procedure DrawI(var fig: TFigure; color: byte);
var
    i: byte;
begin
    fig.active.x := 1;
    fig.active.y := 4;

    for i := 1 to fig.active.y do
    begin
        fig.all[1, i].exists := true;
        fig.all[1, i].color := color
    end
end;

procedure DrawO(var fig: TFigure; color: byte);
var
    i, j: byte;
begin
    fig.active.x := 2;
    fig.active.y := 2;

    for i := 1 to fig.active.y do
    begin
        for j := 1 to fig.active.x do
        begin
            fig.all[j, i].exists := true;
            fig.all[j, i].color := color
        end
    end
end;

procedure DrawT(var fig: TFigure; color: byte);
var
    i: byte;
begin
    fig.active.x := 3;
    fig.active.y := 2;

    for i := 1 to fig.active.x do
    begin
        fig.all[i, 1].exists := true;
        fig.all[i, 1].color := color
    end;
    fig.all[2, 2].exists := true;
    fig.all[2, 2].color := color
end;

procedure DrawS(var fig: TFigure; color: byte);
var
    i: byte;
begin
    fig.active.x := 3;
    fig.active.y := 2;

    for i := 2 to fig.active.x do
    begin
        fig.all[i, 1].exists := true;
        fig.all[i, 1].color := color
    end;
    for i := 1 to 2 do
    begin
        fig.all[i, 2].exists := true;
        fig.all[i, 2].color := color
    end
end;

procedure DrawZ(var fig: TFigure; color: byte);
var
    i: byte;
begin
    fig.active.x := 3;
    fig.active.y := 2;

    for i := 1 to 2 do
    begin
        fig.all[i, 1].exists := true;
        fig.all[i, 1].color := color
    end;
    for i := 2 to fig.active.x do
    begin
        fig.all[i, 2].exists := true;
        fig.all[i, 2].color := color
    end
end;

procedure DrawJ(var fig: TFigure; color: byte);
var
    i: byte;
begin
    fig.active.x := 2;
    fig.active.y := 3;

    for i := 1 to fig.active.y do
    begin
        fig.all[2, i].exists := true;
        fig.all[2, i].color := color
    end;
    fig.all[1, 3].exists := true;
    fig.all[1, 3].color := color
end;

procedure DrawL(var fig: TFigure; color: byte);
var
    i: byte;
begin
    fig.active.x := 2;
    fig.active.y := 3;

    for i := 1 to fig.active.y do
    begin
        fig.all[1, i].exists := true;
        fig.all[1, i].color := color
    end;
    fig.all[2, 3].exists := true;
    fig.all[2, 3].color := color
end;

procedure DrawFigure(var fig: TFigure; color: byte);
begin
    if fig.id = I then
        DrawI(fig, color)
    else
    if fig.id = O then
        DrawO(fig, color)
    else
    if fig.id = T then
        DrawT(fig, color)
    else
    if fig.id = S then
        DrawS(fig, color)
    else
    if fig.id = Z then
        DrawZ(fig, color)
    else
    if fig.id = J then
        DrawJ(fig, color)
    else
    if fig.id = L then
        DrawL(fig, color)
    else
    { id = None }
        exit
end;

function GetRandomFigId(): TAllFigures;
var
    num: byte;
begin
    num := random(CountFigures);
    case num of
        0:
            GetRandomFigId := I;
        1:
            GetRandomFigId := O;
        2:
            GetRandomFigId := T;
        3:
            GetRandomFigId := S;
        4:
            GetRandomFigId := Z;
        5:
            GetRandomFigId := J;
        6:
            GetRandomFigId := L;
    end
end;

function GetRandomFigColor(): byte;
begin
    GetRandomFigColor := AllColors[random(ColorCount) + 1];
end;

procedure InitFigure(var fig: TFigure);
var
    i: byte;
begin
    for i := 1 to LenFigureOfBlocks do
        InitColomn(fig, i);

    fig.id := GetRandomFigId();
    DrawFigure(fig, GetRandomFigColor());

    fig.CurX := SpawnPointX;
    fig.CurY := SpawnPointY
end;

procedure Transposition(var fig: TFigure);
var
    tmp_fig: TFigure;
    i, j: byte;
begin
    tmp_fig := fig;
    InitCleanFigure(fig);
    fig.id := tmp_fig.id;
    fig.active.x := tmp_fig.active.y;
    fig.active.y := tmp_fig.active.x;
    fig.CurX := tmp_fig.CurX;
    fig.CurY := tmp_fig.CurY;

    for i := 1 to LenFigureOfBlocks do
    begin
        for j := 1 to LenFigureOfBlocks do
        begin
            if tmp_fig.all[j, i].exists then
                fig.all[i, j] := tmp_fig.all[j, i]
        end
    end
end;

procedure Reflectioning(var fig: TFigure);
var
    tmp_fig: TFigure;
    i: byte;
begin
    if (fig.active.x = 1) or (fig.active.x = 4) then
        exit;

    tmp_fig := fig;
    InitColomn(fig, 1);
    InitColomn(fig, fig.active.x);

    for i := 1 to LenFigureOfBlocks do
        fig.all[1, i] := tmp_fig.all[tmp_fig.active.x, i];

    for i := 1 to LenFigureOfBlocks do
        fig.all[fig.active.x, i] := tmp_fig.all[1, i]
end;

procedure RotateFigureLeft(var fig: TFigure);
begin
    Reflectioning(fig);
    Transposition(fig)
end;

procedure RotateFigureRight(var fig: TFigure);
begin
    Transposition(fig);
    Reflectioning(fig)
end;

function FindFigureColor(var fig: TFigure): byte;
var
    fx, fy: byte;
begin
    FindFigureColor := White;
    for fy := 1 to fig.active.y do
        for fx := 1 to fig.active.x do
            if fig.all[fx, fy].exists then
            begin
                FindFigureColor := fig.all[fx, fy].color;
                exit
            end
end;

procedure ShowFigure(var fig: TFigure; var offset: TOffset);
var
    fx, fy, x, y: integer;
    rem_x: integer;
begin
    x := offset.x + (fig.CurX - 1) * LenBlockX;
    y := offset.y + (fig.CurY - 1) * LenBlockY;
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
        y := y + LenBlockY;
    end;
    GotoXY(1, 1)
end;

procedure HideFigure(var fig: TFigure; var offset: TOffset);
var
    fx, fy, x, y: integer;
    rem_x: integer;
begin
    x := offset.x + (fig.CurX - 1) * LenBlockX;
    y := offset.y + (fig.CurY - 1) * LenBlockY;
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

procedure MoveDownFigure(var fig: TFigure);
begin
    fig.CurY := fig.CurY + 1;
end;

procedure MoveLeftFigure(var fig: TFigure);
begin
    fig.CurX := fig.CurX - 1;
end;

procedure MoveRightFigure(var fig: TFigure);
begin
    fig.CurX := fig.CurX + 1;
end;

function OutOfWall(var field: TField; var fig: TFigure): boolean;
begin
    OutOfWall :=
        (fig.CurX < 1) or ((fig.CurX + fig.active.x - 1) > LenFieldOfBlocksX) or
        (fig.CurY < 1) or ((fig.CurY + fig.active.y - 1) > LenFieldOfBlocksY)
end;

function InExistsBlocks(var field: TField; var fig: TFigure): boolean;
var
    fx, fy: byte;
    FieldX, FieldY: integer;
begin
    InExistsBlocks := false;

    for fy := 1 to fig.active.y do
    begin
        for fx := 1 to fig.active.x do
        begin
            FieldX := fig.CurX + fx - 1;
            FieldY := fig.CurY + fy - 1;
            if (fig.all[fx, fy].exists) and
                (field[FieldX, FieldY].exists) then
            begin
                InExistsBlocks := true;
                exit
            end
        end
    end
end;

function CanRotateLeft(var field: TField; var fig: TFigure): boolean;
var
    tmp_fig: TFigure;
begin
    tmp_fig := fig;
    RotateFigureLeft(tmp_fig);

    CanRotateLeft :=
        (not OutOfWall(field, tmp_fig)) and (not InExistsBlocks(field, tmp_fig))
end;

function CanRotateRight(var field: TField; var fig: TFigure): boolean;
var
    tmp_fig: TFigure;
begin
    tmp_fig := fig;
    RotateFigureRight(tmp_fig);

    CanRotateRight :=
        (not OutOfWall(field, tmp_fig)) and (not InExistsBlocks(field, tmp_fig))
end;

function DownPosIsFree(var field: TField; var fig: TFigure): boolean;
var
    tmp_fig: TFigure;
begin
    tmp_fig := fig;
    MoveDownFigure(tmp_fig);
    DownPosIsFree :=
        (not OutOfWall(field, tmp_fig)) and (not InExistsBlocks(field, tmp_fig))
end;

function LeftPosIsFree(var field: TField; var fig: TFigure): boolean;
var
    tmp_fig: TFigure;
begin
    tmp_fig := fig;
    MoveLeftFigure(tmp_fig);
    LeftPosIsFree :=
        (not OutOfWall(field, tmp_fig)) and (not InExistsBlocks(field, tmp_fig))
end;

function RightPosIsFree(var field: TField; var fig: TFigure): boolean;
var
    tmp_fig: TFigure;
begin
    tmp_fig := fig;
    MoveRightFigure(tmp_fig);
    RightPosIsFree :=
        (not OutOfWall(field, tmp_fig)) and (not InExistsBlocks(field, tmp_fig))
end;

procedure StopFigure(var field: TField; var fig: TFigure);
var
    FieldX, FieldY: integer;
    fx, fy: integer;
begin
    for fy := 1 to fig.active.y do
    begin
        for fx := 1 to fig.active.x do
        begin
            if fig.all[fx, fy].exists then
            begin
                FieldX := fig.CurX + fx - 1;
                FieldY := fig.CurY + fy - 1;
                field[FieldX, FieldY].exists := true;
                field[FieldX, FieldY].color := fig.all[fx, fy].color
            end
        end
    end
end;

procedure ForceDrop(
    var field: TField; var fig: TFigure; var offset: TOffset;
    SaveTextAttr: integer; var stat: TStat
);
begin
    HideFigure(fig, offset);
    while DownPosIsFree(field, fig) do
    begin
        MoveDownFigure(fig)
    end;
    StopFigure(field, fig);
    HideField(field, offset);
    CheckAndDelLines(field, stat);
    ShowField(field, offset);
    InitFigure(fig);
    if InExistsBlocks(field, fig) then
    begin
        GameOver(stat, SaveTextAttr);
    end;
    ShowFigure(fig, offset)
end;

end.
