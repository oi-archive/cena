{$N+}
unit libcheck;

interface

var
  std,rep: Text;
  fsco: extended;

procedure Score(AScore: extended);
procedure Finish;

implementation

var
  i: integer;

procedure Score(AScore: extended);
var
  src: Text;
begin
  assign(src,'score.log');
  rewrite(src);
  writeln(src,AScore:0:10);
  close(src);
end;

procedure Finish;
begin 
  close(std);
  close(rep);
end;

begin
  val(paramstr(1),fsco,i);
  assign(std,paramstr(2));
  reset(std);
  assign(rep,'report.log'); 
  rewrite(rep);
end.
