program Tetris;
uses crt, common_types, tetramino, unit_field, dynamicinput, block, gamestat;

var
    Offset: TOffset;
    Figure, NextFigure: TFigure;
    Field: TField;
    Stat: TStat;
    code: integer;
    Counts: integer;

begin
    if (ScreenWidth < MinScreenWidth) or (ScreenHeight < MinScreenHeight) then
    begin
        writeln(ErrOutput, 'Your screen is too small!');
        halt(1)
    end;
    randomize;
    clrscr;

    InitFigure(Figure);
    InitFigure(NextFigure);
    InitField(Field, Offset);

    ShowBorders(Offset);
    ShowField(Field, Offset);
    InitStat(Stat, Offset);
    ShowStat(Stat);
    ShowSpeed(Stat);
    ShowFigure(Figure, Offset);
    ShowGhostFigure(Field, Figure, Offset);
    ShowNextFigure(Stat, NextFigure);

    Counts := 0;

    while true do
    begin
        If KeyPressed then
        begin
            GetKey(code);
            case code of
                KeyQ:
                begin
                    if CanRotateLeft(Field, Figure) then
                    begin
                        HideFigure(Figure, Offset);
                        HideGhostFigure(Field, Figure, Offset);
                        RotateFigureLeft(Figure);
                        ShowFigure(Figure, Offset);
                        ShowGhostFigure(Field, Figure, Offset)
                    end
                end;
                KeyE:
                begin
                    if CanRotateRight(Field, Figure) then
                    begin
                        HideFigure(Figure, Offset);
                        HideGhostFigure(Field, Figure, Offset);
                        RotateFigureRight(Figure);
                        ShowFigure(Figure, Offset);
                        ShowGhostFigure(Field, Figure, Offset)
                    end
                end;
                KeyLeft:
                begin
                    if LeftPosIsFree(Field, Figure) then
                    begin
                        HideFigure(Figure, Offset);
                        HideGhostFigure(Field, Figure, Offset);
                        MoveLeftFigure(Figure);
                        ShowFigure(Figure, Offset);
                        ShowGhostFigure(Field, Figure, Offset)
                    end
                end;
                KeyRight:
                begin
                    if RightPosIsFree(Field, Figure) then
                    begin
                        HideFigure(Figure, Offset);
                        HideGhostFigure(Field, Figure, Offset);
                        MoveRightFigure(Figure);
                        ShowFigure(Figure, Offset);
                        ShowGhostFigure(Field, Figure, Offset)
                    end
                end;
                KeySpace:
                    GamePause();
                KeyDown:
                    ForceDrop(
                        Field, Figure, NextFigure, Offset, Stat
                    );
                KeyEscape:
                    break;
            end
        end;
        delay(DelayDuration);
        Counts := Counts + 1;
        if Counts >= Stat.SpeedIteration then
        begin
            Counts := 0;
            HideFigure(Figure, Offset);
            if DownPosIsFree(Field, Figure) then
                MoveDownFigure(Figure)
            else
            begin
                StopFigure(Field, Figure);
                HideField(Field, Offset);
                HideGhostFigure(Field, Figure, Offset);
                CheckAndDelLines(Field, Stat);
                ShowField(Field, Offset);
                HideNextFigure(Stat, NextFigure);
                Figure := NextFigure;
                InitFigure(NextFigure);
                ShowNextFigure(Stat, NextFigure);
                if InExistsBlocks(Field, Figure) then
                begin
                    GameOver(Stat);
                    break
                end
            end;
            ShowGhostFigure(Field, Figure, Offset);
            ShowFigure(Figure, Offset)
        end
    end;
    TextAttr := StandartTextAttr;
    clrscr
end.