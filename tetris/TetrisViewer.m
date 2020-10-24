classdef TetrisViewer
    %TETRISVIEWER テトリスの盤面を描画
    
    properties
        fig
    end
    
    methods (Access = 'private')
        %% ウィンドウのPositionを計算する
        function position = GetFigurePosition(obj)
            global tetrisParam;
            
            currPosX = obj.fig.Position(1) + obj.fig.Position(3) - tetrisParam.windosSize.width;
            currPosY = obj.fig.Position(2) + obj.fig.Position(4) - tetrisParam.windosSize.height;
            
            position = [currPosX, currPosY, tetrisParam.windosSize.width, tetrisParam.windosSize.height];
        end
    end

    methods
        %% コンストラクタ
        function obj = TetrisViewer(keyEventObj)
            global tetrisParam;
            % 描画用画像を用意
            obj.fig = figure(...
                   'Name', tetrisParam.windowTitle, ...
                   'NumberTitle','off', ...
                   'DoubleBuffer', 'on', ...
                   'Resize', 'off', ...
                   'KeyPressFcn', @keyEventObj.KeyPressFnc, ...
                   'KeyReleaseFcn', @keyEventObj.KeyReleaseFcn);
            axes(obj.fig, 'position', [0, 0, 1, 1], ...
                 'XTick', [], 'YTick', [], ...
                 'SortMethod', 'childorder', ...
                 'YDir', 'normal');
            
            % ウィンドウのPositionをセット
            obj.fig.Position = obj.GetFigurePosition();
        end
        
        %% デストラクタ
        function delete(obj)
            if isgraphics(obj.fig)
                close(obj.fig);
            end
        end
                
        %% 描画関数
        function Draw(~, boardData)
            global tetrisParam;
            
            % 描画用データを用意
            displayData = zeros(tetrisParam.boardDisplaySize.height,tetrisParam.boardDisplaySize.width, 3);
            
            % カラーインデックスをRGBに変換し、セットする
            function SetDisplayData(boardData, widthIndex, heightIndex)
                colorIndex = boardData(heightIndex, widthIndex);
                if colorIndex == 0
                    colorIndex = tetrisParam.blockColorNum;
                end
                color = tetrisParam.blockColor.ColorValue{colorIndex};
                displayData(heightIndex, widthIndex, 1) = color(1);
                displayData(heightIndex, widthIndex, 2) = color(2);
                displayData(heightIndex, widthIndex, 3) = color(3);
            end
            indexPattern = combvec(1:tetrisParam.boardDisplaySize.width, 1:tetrisParam.boardDisplaySize.height)';
            arrayfun(@(w,h) SetDisplayData(boardData, w, h) , indexPattern(:,1), indexPattern(:,2));
            
            % 描画
            image(displayData*tetrisParam.blockSize);

        end
    end
end

