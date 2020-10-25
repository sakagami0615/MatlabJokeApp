function [fig, panel] = MsCreateViewData()

global msParam;

% Figure作成
figPosition = [50, 100, msParam.windosSize.width, msParam.windosSize.height];
fig = figure('Position',figPosition, ...
             'numbertitle','off', ...
             'Resize', 'off', ...
             'Name', msParam.windowTitle);

% Figureに付けるパネルのサイズ計算
panelPosition = [msParam.boardPanelSize.margin, msParam.boardPanelSize.margin, ...
                 msParam.boardPanelSize.width, msParam.boardPanelSize.height];

% パネル作成
panel = uipanel(fig, 'Units','Pixel', 'Position',panelPosition, 'title','');

end