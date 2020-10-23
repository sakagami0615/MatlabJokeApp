classdef TetrisViewer
    %TETRISVIEWER このクラスの概要をここに記述
    %   詳細説明をここに記述

    methods
        %% コンストラクタ
        function obj = TetrisViewer()
            global tetrisParam;

            figure('Position',[0,0,tetrisParam.windosSize.width,tetrisParam.windosSize.height], ...
                   'Name', 'Tetris', ...
                   'NumberTitle','off', ...
                   'DoubleBuffer', 'on', ...
                   'KeyPressFcn', [mfilename, ' keypress']);
            axes('position', [0, 0, 1, 1], ...
                 'XTick', [], 'YTick', [], ...
                 'SortMethod', 'childorder', ...
                 'YDir', 'normal');            
        end
        
        %% 描画関数
        function Draw(~, boardData)
            global tetrisParam;
            
            displayData = zeros(tetrisParam.boardDisplaySize.height,tetrisParam.boardDisplaySize.width, 3);
            
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
            
            image(displayData*tetrisParam.blockSize);

        end

    end
end

