function [msParam] = GetMsParameter()

% ブロックのサイズ
blockSize = 15;

% 盤面サイズ
boardSize = struct( ...
    'width',  30, ...
    'height', 30 ...
);

% 盤面の描画サイズ
boardPanelSize = struct( ...
    'width',  boardSize.width * blockSize, ...
    'height', boardSize.height * blockSize, ...
    'margin', 30 ...
);

% ボム数の係数
bombRate = 0.2;

% ウィンドウのサイズ
windosSize = struct( ...
    'width',  boardPanelSize.width + 2*boardPanelSize.margin, ...
    'height', boardPanelSize.height + 2*boardPanelSize.margin ...
);

% ウィンドウ名
windowTitle = 'Minesweeper';

% マインスイーパーパラメータ
msParam = struct( ...
    'blockSize',      blockSize, ...
    'boardSize',      boardSize, ...
    'boardPanelSize', boardPanelSize, ...
    'bombRate',       bombRate, ...
    'windosSize',     windosSize, ...
    'windowTitle',    windowTitle ...
);

end