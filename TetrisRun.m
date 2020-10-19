function TetrisRun()

%% パラメータ用意
% パラメータの読み込み
global tetrisParam;
tetrisParam = GetTetrisParameter();

%% テトリミノ用意
% テトリミノを作成
tetrisTetrinimoObj = TetrisTetriminos();

%% 初期化処理
% 盤面を用意
tetrisBoardObj = TetrisBoard();

% testcode
blockType = 1;
rotateCount = 1;
[tetriminoRelPos, tetriminoRotate] = tetrisTetrinimoObj.GetTetrimino(blockType);
tetrisBoardObj = tetrisBoardObj.PutTetrinino(5, 5, tetriminoRelPos{rotateCount}, blockType);


%% 画面用意

% メイン画面
tetrisViewer = TetrisViewer();

tetrisViewer.Draw(tetrisBoardObj.GetBoardDisplayData());


%% メインループ


%% 終了処理

end