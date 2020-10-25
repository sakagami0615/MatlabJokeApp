function MsRun()

%% パラメータの読み込み
global msParam;
global isgamecontinue
msParam = GetMsParameter();
isgamecontinue = true;


%% 描画用データ作成
[fig, panel] = MsCreateViewData();

%% 盤面初期化
board = MsCreateBoard();

%% グリッド作成
grids = MsCreateGrids(board, panel);

%% コールバック関数の適用
% 計算に使うため周辺にマインがないグリッドのインデックスを抽出し周辺にマインがないグリッドの塊を作成
stats = regionprops(board== 0,'PixelList','PixelIdxList');
% それぞれのグリッドをクリックしたら稼働するコールバック関数を適用
set(grids, 'Callback',{@ClickEvent, fig, board==0, stats, grids});

end


%% クリック時のコールバック関数
function ClickEvent(handle, ~, fig, board, stats, grids)

global isgamecontinue

if handle.UserData < 0    %If hits Mine
    set(handle,'BackgroundColor',[1 0 0],'ForegroundColor',[0 0 0],'String','●');
    if isgamecontinue
        errordlg('Game Over!','!!!');
        set(handle,'Callback','');
        isgamecontinue = false;
    end
elseif handle.UserData == 0       %If hits a block without number (Should expand to all connected blocks without number)
    hInd = find(grids==handle);    %Find blob containing current button
    for k = 1:numel(stats)
        if ~any(stats(k).PixelIdxList == hInd)
            board(stats(k).PixelIdxList) = false; %only keep the current button blob alive
        end
    end
    board = bwmorph(board, 'thick', 1); %Expand one pixel to border for current button blob
    UD = [grids.UserData]';
    set(grids(board(:)&UD>=0),'Style','Edit','Enable','inactive','ForegroundColor',[0 0 0],'BackgroundColor',[1 1 1]);
    set(grids(board(:)&UD==0),'String','')
else %If hits a block with number
    set(handle,'Style','Edit','Enable','inactive','ForegroundColor',[0 0 0],'BackgroundColor',[1 1 1]);
end
%Win check
if isgamecontinue && sum(strcmpi({grids.Style},'edit'))==sum([grids.UserData]>=0)
    uiwait(msgbox('Congratulations!!','WIN'));
    close(fig);
end

end