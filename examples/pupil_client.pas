{
  pupil-fpc-examples
  Copyright (C) 2014-2017 Carlos Rafael Fernandes Picanço, Universidade Federal do Pará.

  The present file is distributed under the terms of the GNU Lesser General Public License (LGPL v3.0).

  You should have received a copy of the GNU General Public License
  along with this program. If not, see <http://www.gnu.org/licenses/>.
}
program pupil_client; { Requires LCL package }

{$MODE objfpc}{$H+}

uses {$IFDEF UNIX}cthreads, cmem,{$ENDIF}Interfaces, Forms, MyClass, Pupil.Client;

{$R *.res}

function PupilClientThread(Args : Pointer) : PtrInt;
var
  i : integer = 0;

begin
  Result := PtrInt(0);
  PupilClient := TPupilClient.Create('127.0.0.1:50020');
  MyObject := TMyClass.Create(PupilClient);

  PupilClient.Start;
  PupilClient.StartSubscriber;
  PupilClient.Subscribe(SUB_ALL_NOTIFICATIONS);
  try
    repeat
      MyObject.Wait(3000);
      Inc(i);
      case i of
       1 : PupilClient.Request(REQ_SHOULD_START_CALIBRATION);
       2 : PupilClient.Request(REQ_SHOULD_STOP_CALIBRATION);
       3 : PupilClient.Request(REQ_SHOULD_START_RECORDING);
       4 : PupilClient.Request(REQ_SHOULD_STOP_RECORDING);
      end;
    until i > 5;
  finally
    MyObject.Free;
    PupilClient.Terminate;
    Halt;
  end;
end;

begin
  Application.Initialize;
  BeginThread(@PupilClientThread);
  Application.Run;
end.

