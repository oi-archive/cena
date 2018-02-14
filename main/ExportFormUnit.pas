unit ExportFormUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, MyTypes, ojrc;

type
  TExportForm = class(TForm)
    lbl1: TLabel;
    rb1: TRadioButton;
    rb2: TRadioButton;
    btn1: TButton;
    btn2: TButton;
    lst1: TListBox;
    btn3: TButton;
    dlgSave1: TSaveDialog;
    lbl2: TLabel;
    procedure btn1Click(Sender: TObject);
    procedure rb2Click(Sender: TObject);
    procedure rb1Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ExportForm: TExportForm;

implementation

{$R *.dfm}

procedure TExportForm.btn1Click(Sender: TObject);
var
  i,j,k:integer;
  PR:TPeopleResult;
  f:system.text;
begin

//  try

{
  if rb1.Checked then
    dlgsave1.Options:=dlgsave1.Options+[ofOverwritePrompt]
  else
    dlgsave1.Options:=dlgsave1.Options-[ofOverwritePrompt];
}

  if dlgsave1.Execute then begin
    Enabled:=false;
    system.Assign(f,dlgsave1.FileName);
    system.Rewrite(f);

    if rb1.Checked then begin   //  export cjd;
//      rs.open('SELECT * FROM [People] ORDER BY [Score] DESC,[Time]',connr,1,1);
      writeln(f,'名次,选手名称,总得分,有效用时');
//      for i:=1 to rs.recordcount do begin
//        writeln(f,i,',',rs.Fields['Name'],',',floattostr(rs.fields['Score']),',',
//              floattostr(rs.fields['Time']));
//        rs.movenext;
//      end;
    end
    else begin

      for i:=0 to lst1.Items.Count-1 do        // the ith ppl
        if lst1.Selected[i] then begin
          lbl2.Caption:='导出'+lst1.Items.Strings[i]+'...';
          Application.ProcessMessages;
          PR:=TPeopleResult.Create;
          PR.LoadFromFile(lst1.Items.Strings[i]);

          writeln(f,'选手名称：',lst1.Items.Strings[i]);
{

          for j:=0 to Contest.Count-1 do begin //  the jth prob
          writeln(f,'试题：',Contest.Items[j].Title,'  文件名：',Contest.Items[j].Name);
          writeln(f,'编号,评测结果,时间,内存');
            for k:=0 to Contest.Items[j].Count-1 do begin  //  the kth tc
              write(f,k,',');

              case PR.Problem[j].TestCase[k].Status of
                3: write(f,'正确,');
                5: write(f,'错误的答案,');
                6: write(f,'超时,');
                7: write(f,'超空间,');
                8: write(f,'运行时错误 ',PR.Problem[j].TestCase[k].ExitCode,',');
                9: write(f,'无输出,');
                10:write(f,'部分正确,');
              end;

              if PR.Problem[j].TestCase[k].Status in [3,5,7,8,9,10,11,12] then
                write(f,floattostr(PR.Problem[j].TestCase[k].Time),'s');
              write(f,',');
              if PR.Problem[j].TestCase[k].Status in [3,5,6,8,9,10,11,12] then
                write(f,floattostr(PR.Problem[j].TestCase[k].Memory),'KB');

              writeln(f);

            end;

            writeln(f,'本题总得分',floattostr(PR.Problem[j].Score),'，有效用时',floattostr(PR.Problem[j].Time),'s。');
            writeln(f);


          end;
          }
          PR.Free;
        end;
    end;
    system.Close(f);
    Enabled:=true;
    lbl2.Caption:='';
    MessageBox(Handle, '导出已完成。', '导出', MB_OK + MB_ICONINFORMATION);

  end;

//  except
//  end;


end;

procedure TExportForm.rb2Click(Sender: TObject);
var
  i:integer;
begin
  lst1.Clear;

  lst1.Enabled:=true;
  btn3.Enabled:=true;
end;

procedure TExportForm.rb1Click(Sender: TObject);
begin
  lst1.Enabled:=false;
  btn3.Enabled:=false;
  lst1.Clear;
end;

procedure TExportForm.btn3Click(Sender: TObject);
var
  i:integer;
begin
  for i:=0 to lst1.Items.Count-1 do
    lst1.Selected[i]:=true;
end;

end.
