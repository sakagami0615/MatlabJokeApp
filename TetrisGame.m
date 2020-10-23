classdef TetrisGame
    %TETRISGAME テトリスを管理する大元のクラス
    %   テトリミノの生成、移動、ゲームオーバ判定を実施する
    
    properties
        boardObj
        isUpdate
        currState
        currTetrimino
        isGameContinue
    end
    
    properties (Access = 'private')
        tetrinimoObj
        ctrlLoopCount
        fallLoopCount
    end
    
    
    methods (Access = 'private') 
        
        %% テトリミノ生成
        function obj = SpawnTetrimino(obj)
            global tetrisParam;
            
            % 初期位置、回転数をセット
            obj.currState.posX = tetrisParam.boardSize.width/2;
            obj.currState.posY = 1 + 1;
            obj.currState.rotate = 1;
            
            % テトリミノの種類をランダムに取得
            obj.currState.type = randi(obj.tetrinimoObj.tetriminoNum - 1, 1);
            
            % テトリミノの各種ブロックの相対位置、最大回転数を取得
            [relativePos, maxRotate] = obj.tetrinimoObj.GetTetrimino(obj.currState.type);
            obj.currTetrimino.relativePos = relativePos;
            obj.currTetrimino.maxRotate = maxRotate;
            
            % スポーンしたテトリミノが置ける場合は、置く
            if obj.boardObj.JudgePutTetrinino(obj.currState.posX, obj.currState.posY, obj.currTetrimino.relativePos{obj.currState.rotate})
                obj.boardObj = obj.boardObj.PutTetrinino(obj.currState.posX, obj.currState.posY, obj.currTetrimino.relativePos{obj.currState.rotate}, obj.currState.type);
            % 置けない場合はゲームオーバになるので、盤面のブロックを一色に染め、ゲーム継続フラグを折る
            else
                gameoverColorIndex = strmatch('GameOver', tetrisParam.blockColor.ColorName);
                obj.boardObj = obj.boardObj.PaintTetriminoAll(gameoverColorIndex);
                obj.isGameContinue = false;
            end
        end
        
        %% テトリミノ移動処理
        function obj = MoveTetrimino(obj)
            global keyinputState;
            
            % 各種キー入力に応じてテトリミノを移動させる
            % テトリミノの移動に失敗した場合、更新前に戻す必要があるため
            % 更新前の状態を保存してから移動させる
            isKeyinput = false;
            if keyinputState.keyInputDown                
                % 落下処理を呼び出すようにする
                obj.fallLoopCount = 0;
                return;
            elseif keyinputState.keyInputUp
                prevState = obj.currState;
                obj.currState.rotate = mod(obj.currState.rotate, obj.currTetrimino.maxRotate) + 1;
                isKeyinput = true;
            elseif keyinputState.keyInputLeft
                prevState = obj.currState;
                obj.currState.posX = obj.currState.posX - 1;
                isKeyinput = true;
            elseif keyinputState.keyInputRight
                prevState = obj.currState;
                obj.currState.posX = obj.currState.posX + 1;
                isKeyinput = true;
            end
            
            % テトリミノの操作が発生した場合
            if isKeyinput
                % 更新前のテトリミノを削除する
                obj.boardObj = obj.boardObj.PopTetrinino(prevState.posX, prevState.posY, obj.currTetrimino.relativePos{prevState.rotate});
                
                % 更新後のテトリミノを置ける場合は、置く
                if obj.boardObj.JudgePutTetrinino(obj.currState.posX, obj.currState.posY, obj.currTetrimino.relativePos{obj.currState.rotate})
                    obj.boardObj = obj.boardObj.PutTetrinino(obj.currState.posX, obj.currState.posY, obj.currTetrimino.relativePos{obj.currState.rotate}, obj.currState.type);
                    % テトリミノ更新フラグを立てる
                    obj.isUpdate = true;
                else
                    % 更新後のテトリミノを置けるない場合は、更新前のテトリミノを再度置いて更新前に戻す
                    obj.boardObj = obj.boardObj.PutTetrinino(prevState.posX, prevState.posY, obj.currTetrimino.relativePos{prevState.rotate}, prevState.type);
                    obj.currState = prevState;
                end
            end    
        end
        
        %% テトリミノ落下処理
        function obj = FallTetrimino(obj)
            % テトリミノの移動に失敗した場合、更新前に戻す必要があるため
            % 更新前の状態を保存してから移動させる
            prevState = obj.currState;
            obj.currState.posY = obj.currState.posY + 1;
            
            % 更新前のテトリミノを削除する
            obj.boardObj = obj.boardObj.PopTetrinino(prevState.posX, prevState.posY, obj.currTetrimino.relativePos{prevState.rotate});
            % 更新後のテトリミノを置ける場合
            if obj.boardObj.JudgePutTetrinino(obj.currState.posX, obj.currState.posY, obj.currTetrimino.relativePos{obj.currState.rotate})
                % 更新後のテトリミノを置く
                obj.boardObj = obj.boardObj.PutTetrinino(obj.currState.posX, obj.currState.posY, obj.currTetrimino.relativePos{obj.currState.rotate}, obj.currState.type);
            % 更新後のテトリミノを置けるない場合
            else
                % 更新前のテトリミノを再度置く
                obj.boardObj = obj.boardObj.PutTetrinino(prevState.posX, prevState.posY, obj.currTetrimino.relativePos{prevState.rotate}, prevState.type);
                % ブロックで埋まった行を削除
                obj.boardObj = obj.boardObj.ClearFillLine();
                % 新規テトリミノをスポーン
                obj = obj.SpawnTetrimino();
            end
            % テトリミノ更新フラグを立てる
            obj.isUpdate = true;
            
        end
        
        
    end
    
    methods
        %% コンストラクタ
        function obj = TetrisGame()
            obj.tetrinimoObj = TetrisTetriminos();
            obj.boardObj = TetrisBoard();
            obj.ctrlLoopCount = 0;
            obj.fallLoopCount = 0;
            obj.isUpdate = false;
            obj.isGameContinue = true;
            
            obj.currState = struct( ...
                'type',   NaN, ...
                'posX',   NaN, ...
                'posY',   NaN, ...
                'rotate', NaN);
            
            obj.currTetrimino = struct( ...
                'relativePos', NaN , ...
                'maxRotate',   NaN);
            
            obj = obj.SpawnTetrimino();
        
        end
        
        %% メインループでCALLする関数
        function obj = Run(obj)
            global tetrisParam;
            
            % 更新フラグを初期化
            obj.isUpdate = false;
            
            % キー操作
            if mod(obj.ctrlLoopCount, tetrisParam.keyinputSampleFrame) == 0
                obj = obj.MoveTetrimino();
                obj.ctrlLoopCount = 0;
            end
            % 落下
            if mod(obj.fallLoopCount, tetrisParam.fallSampleFrame) == 0
                obj = obj.FallTetrimino();
                obj.fallLoopCount = 0;
            end
            
            % カウンタ更新
            obj.ctrlLoopCount = obj.ctrlLoopCount + 1;
            obj.fallLoopCount = obj.fallLoopCount + 1;
        end
                
    end
end

