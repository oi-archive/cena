unit ojsort;

interface

uses
  Classes, ojrc, comctrls;

type
  PSortItem=^TSortItem;
  TSortItem=record
    Score, Time: double;
    ListItem: TListItem;
    Place: integer;
  end;

var
  List: TList;

procedure Sort(List: TList);

implementation

procedure QuickSort(List: TList; l,r: integer);
var
  i,j: integer;
  x,y: PSortItem;
begin
  i:=l;
  j:=r;
  x:=List.Items[(l+r) div 2];

  repeat
    while (PSortItem(List.Items[i]).Score>x.Score)
     or ((PSortItem(List.Items[i]).Score=x.Score) and (PSortItem(List.Items[i]).Time<x.Time)) do
       inc(i);
    while (PSortItem(List.Items[j]).Score<x.Score)
     or ((PSortItem(List.Items[j]).Score=x.Score) and (PSortItem(List.Items[j]).Time>x.Time)) do
      dec(j);
    if i<=j then begin
      y:=List.Items[i];
      List.Items[i]:=List.Items[j];
      List.Items[j]:=y;
      inc(i);
      dec(j);
    end;
  until i>j;
  if l<j then
    QuickSort(List,l,j);
  if i<r then
    QuickSort(List,i,r);
end;

procedure Sort(List: TList);
var
  i:integer;
begin
  if List.Count>0 then begin
    QuickSort(List,0,List.Count-1);
    PSortItem(List.Items[0]).Place:=1;
    for i:=1 to List.Count-1 do
      if (PSortItem(List.Items[i]).Score<PSortItem(List.Items[i-1]).Score)
      or (PSortItem(List.Items[i]).Time>PSortItem(List.Items[i-1]).Time) then
        PSortItem(List.Items[i]).Place:=i+1
      else
        PSortItem(List.Items[i]).Place:=PSortItem(List.Items[i-1]).Place;
  end;
end;

end.
