function status=notify(msg,titl,subtitl,alert)
%NOTIFY  Display OS X notification message window
%   STATUS = NOTIFY(MESSAGE) displays the string MESSAGE in an OS X notification
%   window. MESSAGE may be an empty string. A nonzero STATUS value indicates a
%   failure.
%   
%   NOTIFY(MESSAGE,TITLE) additionally specifies a string TITLE for the
%   notification. TITLE may be an empty string.
%   
%   NOTIFY(MESSAGE,TITLE,SUBTITLE) additionally specifies a string SUBTITLE for
%   the notification. SUBTITLE may be an empty string.
%   
%   NOTIFY(MESSAGE,TITLE,SUBTITLE,SOUND) additionally specifies an alert SOUND
%   to play when the notification first displays. Valid sound names are in
%   /System/Library/Sounds and ~/Library/Sounds and include: Basso', 'Blow',
%   'Bottle', 'Frog', 'Funk', 'Glass', 'Hero', 'Morse', 'Ping', 'Pop', 'Purr',
%   'Sosumi', 'Submarine', and 'Tink'.
%
%   Note: The behavior of the notification window can be controlled by going to
%   System Preferences > Notifications > Script Editior and choosing Alerts
%   rather than Banners. This way the notification can be dismissed by clicking
%   Close (rather than clicking on the body of the notification which launches
%   Script Editor).

%   See: http://apple.stackexchange.com/q/57412/112204
%        http://stackoverflow.com/q/15793534/2278029

%   Andrew D. Horchler, adh9 @ case . edu, Created 5-23-14
%   Revision: 1.0, 4-9-16


status = 1; %#ok<NASGU>
if ~ismac
    error('notify:InvalidOS','This function only supports OS X.');
end

if ~ischar(msg)
    error('notify:InvalidMessage','Message must be a string.');
end

rep = @(str)strrep(regexprep(str,'["\\]','\\$0'),'''','\"');
cmd = ['osascript -e ''display notification "' rep(msg)];
if nargin > 1
    if ~ischar(titl)
        error('notify:InvalidTitle','Title must be a string.');
    end
    cmd = [cmd '" with title "' rep(titl)];
    if nargin > 2
        if ~ischar(subtitl)
            error('notify:InvalidSubtitle','Subtitle must be a string.');
        end
        cmd = [cmd '" subtitle "' rep(subtitl)];
        if nargin > 3
            sounds = {'Basso','Blow','Bottle','Frog','Funk','Glass','Hero',...
                      'Morse','Ping','Pop','Purr','Sosumi','Submarine','Tink'};
            if ~isempty(alert) && ~any(strcmpi(alert,sounds))
                error('notify:InvalidSound','Sound must be a string.');
            end
            cmd = [cmd '" sound name "' rep(alert)];
        end
    end
else
    cmd = [cmd '" with title "Matlab'];
end
status = unix([cmd '"''']);