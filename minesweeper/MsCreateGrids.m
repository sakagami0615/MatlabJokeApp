function grids = MsCreateGrids(board, panel)

global msParam;

% 全グリッドの位置を計算
[gridPosXList, gridPosYList] = meshgrid(1:(msParam.blockSize):(msParam.boardSize.width*msParam.blockSize), ...
                                        1:(msParam.blockSize):(msParam.boardSize.height*msParam.blockSize));
 
%グリッド作成用、各グリッドのハンドルを初期化  
grids = repmat(uicontrol(panel),[msParam.blockSize, msParam.blockSize]);
%Loopでグリッドを作成
for index = 1:msParam.boardSize.height*msParam.boardSize.width
    grids(index) = uicontrol(panel, ...
                            'Position', [gridPosXList(index),gridPosYList(index),msParam.blockSize, msParam.blockSize], ...
                            'UserData', board(index), ...
                            'String', board(index), ...
                            'ForegroundColor', [0.9, 0.9, 0.9], ...
                            'BackgroundColor', [0.9, 0.9, 0.9]);
end

end