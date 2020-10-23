classdef TetrisViewer
    %TETRISVIEWER テトリスの盤面を描画
    
    properties
        fig
    end

    methods
        %% コンストラクタ
        function obj = TetrisViewer()
            global tetrisParam;            

            obj.fig = figure('Position',[0,0,tetrisParam.windosSize.width,tetrisParam.windosSize.height], ...
                   'Name', 'Tetris', ...
                   'NumberTitle','off', ...
                   'DoubleBuffer', 'on', ...
                   'KeyPressFcn', @KeyPressFnc, ...
                   'KeyReleaseFcn', @KeyReleaseFcn);
            axes('position', [0, 0, 1, 1], ...
                 'XTick', [], 'YTick', [], ...
                 'SortMethod', 'childorder', ...
                 'YDir', 'normal');
             
            function KeyPressFnc(~, event)
                global keyinputState
                keyinputState.keyInputUp = strcmp(event.Key, 'uparrow');
                keyinputState.keyInputDown = strcmp(event.Key, 'downarrow');
                keyinputState.keyInputLeft = strcmp(event.Key, 'leftarrow');
                keyinputState.keyInputRight = strcmp(event.Key, 'rightarrow');
            end
            
            function KeyReleaseFcn(~, ~)
                global keyinputState
                keyinputState.keyInputUp = false;
                keyinputState.keyInputDown = false;
                keyinputState.keyInputLeft = false;
                keyinputState.keyInputRight = false;
            end
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

