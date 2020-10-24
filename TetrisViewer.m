classdef TetrisViewer
    %TETRISVIEWER テトリスの盤面を描画
    
    properties
        fig
    end

    methods        
        %% コンストラクタ
        function obj = TetrisViewer(keyEventObj)
            global tetrisParam; 
            % 描画用画像を用意
            obj.fig = figure('Position',[0,0,tetrisParam.windosSize.width,tetrisParam.windosSize.height], ...
                   'Name', tetrisParam.windowTitle, ...
                   'NumberTitle','off', ...
                   'DoubleBuffer', 'on', ...
                   'KeyPressFcn', @keyEventObj.KeyPressFnc, ...
                   'KeyReleaseFcn', @keyEventObj.KeyReleaseFcn);
            axes('position', [0, 0, 1, 1], ...
                 'XTick', [], 'YTick', [], ...
                 'SortMethod', 'childorder', ...
                 'YDir', 'normal');
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

