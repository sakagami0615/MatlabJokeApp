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

while(isgraphics(tetrisViewer.fig))
    % ゲーム継続時
    if tetrisGameObj.isGameContinue
        % 初回時は描画のみ実施
        if initLoop
            tetrisViewer.Draw(tetrisGameObj.boardObj.GetBoardDisplayData());
            initLoop = false;
        % 初回以降は、テトリミノの更新が発生した場合に描画する
        else
            tetrisGameObj = tetrisGameObj.Run();
            if tetrisGameObj.isUpdate
                tetrisViewer.Draw(tetrisGameObj.boardObj.GetBoardDisplayData());
            end
        end
    % ゲームオーバー時
    else
        tetrisViewer.Draw(tetrisGameObj.boardObj.GetBoardDisplayData());
    end
    
    pause(tetrisParam.sleepTime);
end

end