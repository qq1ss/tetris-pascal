unit block;

interface
uses common_types;

procedure ShowBlock(x, y: integer);
procedure HideBlock(x, y: integer);

implementation
uses crt;

procedure ShowBlock(x, y: integer);
var
    bx, by: integer;
begin
    for by := 1 to LenBlockY do
    begin
        GotoXY(x, y);
        for bx := 1 to LenBlockX do
            write('#');
        y := y + 1
    end
end;

procedure HideBlock(x, y: integer);
var
    bx, by: integer;
begin
    for by := 1 to LenBlockY do
    begin
        GotoXY(x, y);
        for bx := 1 to LenBlockX do
            write(' ');
        y := y + 1
    end
end;

end.