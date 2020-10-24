classdef TetrisViewer
    %TETRISVIEWER �e�g���X�̔Ֆʂ�`��
    
    properties
        fig
    end
    
    methods (Access = 'private')
        %% �E�B���h�E��Position���v�Z����
        function position = GetFigurePosition(obj)
            global tetrisParam;
            
            currPosX = obj.fig.Position(1) + obj.fig.Position(3) - tetrisParam.windosSize.width;
            currPosY = obj.fig.Position(2) + obj.fig.Position(4) - tetrisParam.windosSize.height;
            
            position = [currPosX, currPosY, tetrisParam.windosSize.width, tetrisParam.windosSize.height];
        end
    end

    methods
        %% �R���X�g���N�^
        function obj = TetrisViewer(keyEventObj)
            global tetrisParam;
            % �`��p�摜��p��
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
            
            % �E�B���h�E��Position���Z�b�g
            obj.fig.Position = obj.GetFigurePosition();
        end
        
        %% �f�X�g���N�^
        function delete(obj)
            if isgraphics(obj.fig)
                close(obj.fig);
            end
        end
                
        %% �`��֐�
        function Draw(~, boardData)
            global tetrisParam;
            
            % �`��p�f�[�^��p��
            displayData = zeros(tetrisParam.boardDisplaySize.height,tetrisParam.boardDisplaySize.width, 3);
            
            % �J���[�C���f�b�N�X��RGB�ɕϊ����A�Z�b�g����
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
            
            % �`��
            image(displayData*tetrisParam.blockSize);

        end
    end
end

