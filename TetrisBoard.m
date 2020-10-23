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
                %obj.boardData(1, widthIndex) = -1;
                obj.boardData(tetrisParam.boardSize.height, widthIndex) = -1;
            end
            for heightIndex = 1:tetrisParam.boardSize.height
                obj.boardData(heightIndex, 1) = -1;
                obj.boardData(heightIndex, tetrisParam.boardSize.width) = -1;
            end
            
        end
        
        %% �Ֆʂɂ���u���b�N����F�Ő��߂�
        function obj = PaintTetriminoAll(obj, colorIndex)
            global tetrisParam
            for heightIndex = 1:tetrisParam.boardSize.height
                for widthIndex = 1:tetrisParam.boardSize.width
                    if obj.boardData(heightIndex, widthIndex) > 0
                        obj.boardData(heightIndex, widthIndex) = colorIndex;
                    end
                end
            end
        end
            
        
        %% �e�g���~�m��Ֆʂɒu���邩�𔻒�
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

