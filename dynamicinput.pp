unit dynamicinput;

interface

const
    KeyLeft = -75;
    KeyRight = -77;
    KeyDown = -80;
    KeyEscape = 27;
    KeySpace = 32;
    KeyQ = 113;
    KeyE = 101;

procedure GetKey(var code: integer);

implementation
uses crt;

procedure GetKey(var code: integer);
var
    c: char;
begin
    c := ReadKey;
    if c = #0 then
    begin
        c := ReadKey;
        code := -ord(c);
    end
    else
    begin
        code := ord(c)
    end
end;

end.