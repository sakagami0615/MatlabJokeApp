classdef TetrisBoard
    %TETRISBOARD �e�g���X�̔Ֆʂ��Ǘ�����
    
    properties (Access = 'private')
        boardData
    end
    
    methods
        %% �R���X�g���N�^
        function obj = TetrisBoard()
            global tetrisParam;
            
            obj.boardData = zeros(tetrisParam.boardSize.height, tetrisParam.boardSize.width);

            for widthIndex = 1:tetrisParam.boardSize.width
                obj.boardData(1, widthIndex) = -1;
                obj.boardData(tetrisParam.boardSize.height, widthIndex) = -1;
            end
            for heightIndex = 1:tetrisParam.boardSize.height
                obj.boardData(heightIndex, 1) = -1;
                obj.boardData(heightIndex, tetrisParam.boardSize.width) = -1;
            end
            
        end
        
        %% �e�g���~�m��Ֆʂɒu��
        function obj = PutTetrinino(obj, posX, posY, blockRelPosList, colorIndex)
            for posIndex = 1:length(blockRelPosList)
                relPos = blockRelPosList{posIndex};
                obj.boardData(posY+relPos(2), posX+relPos(1)) = colorIndex;
            end
        end
        
        %% �e�g���~�m��Ֆʂ���폜����
        function obj = PopTetrinino(obj, posX, posY, blockRelPosList)
            for posIndex = 1:length(blockRelPosList)
                relPos = blockRelPosList{posIndex};
                obj.boardData(posY+relPos(2), posX+relPos(1)) = 0;
            end
        end
        
        %% �`��p�Ֆʂ��擾
        function boardDisplayData = GetBoardDisplayData(obj)
            global tetrisParam;
            boardDisplayData = obj.boardData(2:tetrisParam.boardDisplaySize.height+1, 2:tetrisParam.boardDisplaySize.width+1);
        end
    end
end

