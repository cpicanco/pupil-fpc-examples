{
  pupil-fpc-examples
  Copyright (C) 2014-2017 Carlos Rafael Fernandes Picanço, Universidade Federal do Pará.

  The present file is distributed under the terms of the GNU Lesser General Public License (LGPL v3.0).

  You should have received a copy of the GNU General Public License
  along with this program. If not, see <http://www.gnu.org/licenses/>.
}
unit MyClass;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Pupil.Client;

type

  { TMyClass }

  TMyClass = class
  private
    procedure RequestReceived(Sender: TObject; ARequest, AResponse: String);
    procedure MultiPartMessageReceived(Sender: TObject; AMultiPartMessage : TPupilMessage);
  public
    constructor Create(APupilClient : TPupilClient);
    procedure Wait(AValue : Cardinal);
  end;

var
  MyObject : TMyClass;

implementation

{ TMyClass }

procedure TMyClass.RequestReceived(Sender: TObject;
  ARequest, AResponse: String);
begin
  WriteLn(Sender.ClassName, #32, ARequest,#32,AResponse);
end;

procedure TMyClass.MultiPartMessageReceived(Sender: TObject;
  AMultiPartMessage: TPupilMessage);
var
  j: Integer;
begin
  WriteLn(AMultiPartMessage.Topic);
  with AMultiPartMessage.Payload do
    for j := 0 to Count -1 do
      WriteLn(Sender.ClassName, #32, Items[j].Key, ':', Items[j].Value);
end;

constructor TMyClass.Create(APupilClient: TPupilClient);
begin
  APupilClient.OnCalibrationStopped:= @MultiPartMessageReceived;
  APupilClient.OnCalibrationSuccessful:= @MultiPartMessageReceived;
  APupilClient.OnMultiPartMessageReceived:= @MultiPartMessageReceived;
  APupilClient.OnRecordingStarted:= @MultiPartMessageReceived;
  APupilClient.OnRequestReceived:= @RequestReceived;
end;

procedure TMyClass.Wait(AValue: Cardinal);
var
  Event : PRTLEvent;
begin
  Event := RTLEventCreate;
  RTLeventWaitFor(Event, AValue);
  RTLeventdestroy(Event);
end;

end.

