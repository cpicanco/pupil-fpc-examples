{
  pupil-fpc-examples
  Copyright (C) 2014-2017 Carlos Rafael Fernandes Picanço, Universidade Federal do Pará.

  The present file is distributed under the terms of the GNU Lesser General Public License (LGPL v3.0).

  You should have received a copy of the GNU General Public License
  along with this program. If not, see <http://www.gnu.org/licenses/>.
}
program pupil_task;

{$MODE objfpc}{$H+}

uses {$IFDEF UNIX}cthreads, cmem,{$ENDIF}
  SysUtils,
  Pupil.Tasks, zmq, zmq.helpers;

var
  context, requester : Pointer;

  reply : string;
  i : integer = 0;

  function Request(ARequest : string) : string;
  begin
    WriteLn('request:', ARequest);
    SendString(requester, ARequest);
    Result := RecvShortString(requester); // wait for response
    WriteLn('reply:', Result);
  end;

begin
  context := zmq_ctx_new;
  requester := zmq_socket(context, ZMQ_REQ);
  zmq_connect(requester, PupilRequestHost);
  PupilSubscribeHost := PupilSubscribeHost+Request('SUB_PORT');
  BeginThread(@PupilSubscriberTask);

  repeat
    Sleep(3000);
    case i of
      1 : reply := Request('C'); // start calibration
      2 : reply := Request('c'); // stop calibration
      3 : reply := Request('R'); // start recording
      4 : reply := Request('r'); // stop recording
    end;
    Inc(i);
  until i > 5;

  zmq_close(requester);
  zmq_ctx_shutdown(Context);
end.

