program Tetris;
uses crt, common_types, tetramino, unit_field, dynamicinput, block, gamestat;

var
    Offset: TOffset;
    Figure: TFigure;
    Field: TField;
    Stat: TStat;

    code: integer;
    SaveTextAttr: integer;
    Counts: integer;

begin
    if (ScreenWidth < MinScreenWidth) or (ScreenHeight < MinScreenHeight) then
    begin
        writeln(ErrOutput, 'Your screen is too small!');
        halt(1)
    end;
    randomize;
    SaveTextAttr := TextAttr;
    clrscr;

    InitFigure(Figure);
    InitField(Field, Offset);

    ShowBorders(Offset);
    ShowField(Field, Offset);
    ShowFigure(Figure, Offset);
    InitStat(Stat, Offset);
    ShowStat(Stat);
    ShowSpeed(Stat);

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
                        RotateFigureLeft(Figure);
                        ShowFigure(Figure, Offset)
                    end
                end;
                KeyE:
                begin
                    if CanRotateRight(Field, Figure) then
                    begin
                        HideFigure(Figure, Offset);
                        RotateFigureRight(Figure);
                        ShowFigure(Figure, Offset)
                    end
                end;
                KeyLeft:
                begin
                    if LeftPosIsFree(Field, Figure) then
                    begin
                        HideFigure(Figure, Offset);
                        MoveLeftFigure(Figure);
                        ShowFigure(Figure, Offset)
                    end
                end;
                KeyRight:
                begin
                    if RightPosIsFree(Field, Figure) then
                    begin
                        HideFigure(Figure, Offset);
                        MoveRightFigure(Figure);
                        ShowFigure(Figure, Offset)
                    end
                end;
                KeySpace:
                    GamePause();
                KeyDown:
                    ForceDrop(Field, Figure, Offset, SaveTextAttr, Stat);
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
                CheckAndDelLines(Field, Stat);
                ShowField(Field, Offset);
                InitFigure(Figure);
                if InExistsBlocks(Field, Figure) then
                begin
                    GameOver(Stat, SaveTextAttr);
                    break
                end
            end;
            ShowFigure(Figure, Offset)
        end
    end;
    TextAttr := SaveTextAttr;
    clrscr
end.