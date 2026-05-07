unit common_types;

interface
uses crt;

const
    LenBlockX = 3;
    LenBlockY = 2;
    LenFigureOfBlocks = 4;
    ColorCount = 16;
    BGColorCount = 8;
    CountFigures = 7;

    LenFieldOfBlocksX = 10;
    LenFieldOfBlocksY = 20;
    SpawnPointX = 5;
    SpawnPointY = 1;
    BorderChar = '*';
    StatMessageLength = 13;
    LenFieldStatX = StatMessageLength + 5;

    StartSpeed = 50;
    MaxSpeed = 10;

type
    TAllFigures =
        (I, O, T, S, Z, J, L);

    TBlock = record
        color: byte;
        exists: boolean;
    end;
    TFigureAll = array [1..LenFigureOfBlocks, 1..LenFigureOfBlocks] of TBlock;
    { [x, y] }
    TFigureActive = record
        x, y: byte;
    end;
    TFigure = record
        id: TAllFigures;
        all: TFigureAll;
        active: TFigureActive;
        CurX, CurY: byte;   { UpLeft point }
    end;
    TField = array [1..LenFieldOfBlocksX, 1..LenFieldOfBlocksY] of TBlock;
    TOffset = record
        x, y: integer;
    end;
    TStat = record
        score: longint;
        x, y: integer;
        SpeedIteration: integer;
    end;

var
    AllColors: array [1..ColorCount] of byte =
    (
        Black, Blue, Green, Cyan,
        Red, Magenta, Brown, LightGray,
        DarkGray, LightBlue, LightGreen, LightCyan,
        LightRed, LightMagenta, Yellow, White
    );
    DelayDuration: integer = 20;

    CenterScreenX, CenterScreenY: integer;
    MinScreenWidth, MinScreenHeight: integer;

implementation

begin
    CenterScreenX := ScreenWidth div 2;
    CenterScreenY := ScreenHeight div 2;
    MinScreenWidth := (LenFieldOfBlocksX * LenBlockX) + 3 + LenFieldStatX + 2;
    MinScreenHeight := (LenFieldOfBlocksY * LenBlockY) + 2 + 2;
end.