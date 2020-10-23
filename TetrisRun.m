function TetrisRun()

%% パラメータ用意
% パラメータの読み込み
global tetrisParam;
tetrisParam = GetTetrisParameter();

%% テトリス用クラス用意
% テトリスクラス、テトリミノ、盤面を作成
tetrisGameObj = TetrisGame();

%% 初期化処理
% キー入力取得用データ用意
global keyinputState;
keyinputState = struct( ...
    'keyInputUp',    false, ...
    'keyInputDown',  false, ...
    'keyInputLeft',  false, ...
    'keyInputRight', false...
);

%% 画面用意
% メイン画面
tetrisViewer = TetrisViewer();

%% メインループ
initLoop = true;

while(true)
    if tetrisGameObj.isGameContinue
        if initLoop
            tetrisViewer.Draw(tetrisGameObj.boardObj.GetBoardDisplayData());
            initLoop = false;
        else
            tetrisGameObj = tetrisGameObj.Run();
            if tetrisGameObj.isUpdate
                tetrisViewer.Draw(tetrisGameObj.boardObj.GetBoardDisplayData());
            end
        end
    else
        tetrisViewer.Draw(tetrisGameObj.boardObj.GetBoardDisplayData());
    end
    pause(1/60);
end

%% 終了処理
close all;

end