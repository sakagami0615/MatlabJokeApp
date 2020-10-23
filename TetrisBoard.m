classdef TetrisBoard
    %TETRISBOARD テトリスの盤面を管理する
    
    properties (Access = 'private')
        boardData
    end
    
    methods
        %% コンストラクタ
        function obj = TetrisBoard()
            global tetrisParam;
            
            % 盤面初期化
            obj.boardData = zeros(tetrisParam.boardSize.height, tetrisParam.boardSize.width);

            % 番兵を設定
            for widthIndex = 1:tetrisParam.boardSize.width
                obj.boardData(tetrisParam.boardSize.height, widthIndex) = -1;
            end
            for heightIndex = 1:tetrisParam.boardSize.height
                obj.boardData(heightIndex, 1) = -1;
                obj.boardData(heightIndex, tetrisParam.boardSize.width) = -1;
            end
            
        end
        
        %% 盤面にあるブロックを一色で染める
        function obj = PaintTetriminoAll(obj, colorIndex)
            global tetrisParam
            for heightIndex = 1:tetrisParam.boardSize.height
                for widthIndex = 1:tetrisParam.boardSize.width
                    % ブロックの有無を判定
                    if obj.boardData(heightIndex, widthIndex) > 0
                        % 指定した色インデックスに変更
                        obj.boardData(heightIndex, widthIndex) = colorIndex;
                    end
                end
            end
        end
        
        
        %% 埋まった行を削除
        function obj = ClearFillLine(obj)
            global tetrisParam
            clearLineCount = 0;
            heightIndex = tetrisParam.boardSize.height - 1;
            % 盤面の下辺からイテレート
            while(heightIndex > clearLineCount)
                % 探索行を取得
                lineData = obj.boardData(heightIndex, 2:end-1);
                isFillLine = (sum(lineData == 0) == 0);
                % ブロックで埋まっている場合
                if isFillLine
                    % ブロックで埋まっている行をカウント
                    clearLineCount = clearLineCount + 1;
                end
                % 探索行を上の行で置き換える    
                nextLineData = obj.boardData(heightIndex - clearLineCount, 2:end-1);
                obj.boardData(heightIndex, 2:end-1) = nextLineData;
                
                % ブロックで埋まっている行ではない場合、デクリメントする
                if ~isFillLine
                    heightIndex = heightIndex - 1;
                end
            end
        end
        
        %% テトリミノを盤面に置けるかを判定
        function judge = JudgePutTetrinino(obj, posX, posY, blockRelPosList)
            for posIndex = 1:length(blockRelPosList)
                relPos = blockRelPosList{posIndex};
                if obj.boardData(posY+relPos(2), posX+relPos(1)) ~= 0
                    judge = false;
                    return;
                end
                judge = true;
            end
        end
        
        %% テトリミノを盤面に置く
        function obj = PutTetrinino(obj, posX, posY, blockRelPosList, colorIndex)
            for posIndex = 1:length(blockRelPosList)
                relPos = blockRelPosList{posIndex};
                obj.boardData(posY+relPos(2), posX+relPos(1)) = colorIndex;
            end
        end
        
        %% テトリミノを盤面から削除する
        function obj = PopTetrinino(obj, posX, posY, blockRelPosList)
            for posIndex = 1:length(blockRelPosList)
                relPos = blockRelPosList{posIndex};
                obj.boardData(posY+relPos(2), posX+relPos(1)) = 0;
            end
        end
        
        %% 描画用盤面を取得
        function boardDisplayData = GetBoardDisplayData(obj)
            global tetrisParam;
            boardDisplayData = obj.boardData(2:tetrisParam.boardDisplaySize.height+1, 2:tetrisParam.boardDisplaySize.width+1);
        end
    end
end

