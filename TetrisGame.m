classdef TetrisGame
    %TETRISGAME �e�g���X���Ǘ�����匳�̃N���X
    %   �e�g���~�m�̐����A�ړ��A�Q�[���I�[�o��������{����
    
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
        
        %% �e�g���~�m����
        function obj = SpawnTetrimino(obj)
            global tetrisParam;
            
            % �����ʒu�A��]�����Z�b�g
            obj.currState.posX = tetrisParam.boardSize.width/2;
            obj.currState.posY = 1 + 1;
            obj.currState.rotate = 1;
            
            % �e�g���~�m�̎�ނ������_���Ɏ擾
            obj.currState.type = randi(obj.tetrinimoObj.tetriminoNum - 1, 1);
            
            % �e�g���~�m�̊e��u���b�N�̑��Έʒu�A�ő��]�����擾
            [relativePos, maxRotate] = obj.tetrinimoObj.GetTetrimino(obj.currState.type);
            obj.currTetrimino.relativePos = relativePos;
            obj.currTetrimino.maxRotate = maxRotate;
            
            % �X�|�[�������e�g���~�m���u����ꍇ�́A�u��
            if obj.boardObj.JudgePutTetrinino(obj.currState.posX, obj.currState.posY, obj.currTetrimino.relativePos{obj.currState.rotate})
                obj.boardObj = obj.boardObj.PutTetrinino(obj.currState.posX, obj.currState.posY, obj.currTetrimino.relativePos{obj.currState.rotate}, obj.currState.type);
            % �u���Ȃ��ꍇ�̓Q�[���I�[�o�ɂȂ�̂ŁA�Ֆʂ̃u���b�N����F�ɐ��߁A�Q�[���p���t���O��܂�
            else
                gameoverColorIndex = strmatch('GameOver', tetrisParam.blockColor.ColorName);
                obj.boardObj = obj.boardObj.PaintTetriminoAll(gameoverColorIndex);
                obj.isGameContinue = false;
            end
        end
        
        %% �e�g���~�m�ړ�����
        function obj = MoveTetrimino(obj)
            global keyinputState;
            
            % �e��L�[���͂ɉ����ăe�g���~�m���ړ�������
            % �e�g���~�m�̈ړ��Ɏ��s�����ꍇ�A�X�V�O�ɖ߂��K�v�����邽��
            % �X�V�O�̏�Ԃ�ۑ����Ă���ړ�������
            isKeyinput = false;
            if keyinputState.keyInputDown                
                % �����������Ăяo���悤�ɂ���
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
            
            % �e�g���~�m�̑��삪���������ꍇ
            if isKeyinput
                % �X�V�O�̃e�g���~�m���폜����
                obj.boardObj = obj.boardObj.PopTetrinino(prevState.posX, prevState.posY, obj.currTetrimino.relativePos{prevState.rotate});
                
                % �X�V��̃e�g���~�m��u����ꍇ�́A�u��
                if obj.boardObj.JudgePutTetrinino(obj.currState.posX, obj.currState.posY, obj.currTetrimino.relativePos{obj.currState.rotate})
                    obj.boardObj = obj.boardObj.PutTetrinino(obj.currState.posX, obj.currState.posY, obj.currTetrimino.relativePos{obj.currState.rotate}, obj.currState.type);
                    % �e�g���~�m�X�V�t���O�𗧂Ă�
                    obj.isUpdate = true;
                else
                    % �X�V��̃e�g���~�m��u����Ȃ��ꍇ�́A�X�V�O�̃e�g���~�m���ēx�u���čX�V�O�ɖ߂�
                    obj.boardObj = obj.boardObj.PutTetrinino(prevState.posX, prevState.posY, obj.currTetrimino.relativePos{prevState.rotate}, prevState.type);
                    obj.currState = prevState;
                end
            end    
        end
        
        %% �e�g���~�m��������
        function obj = FallTetrimino(obj)
            % �e�g���~�m�̈ړ��Ɏ��s�����ꍇ�A�X�V�O�ɖ߂��K�v�����邽��
            % �X�V�O�̏�Ԃ�ۑ����Ă���ړ�������
            prevState = obj.currState;
            obj.currState.posY = obj.currState.posY + 1;
            
            % �X�V�O�̃e�g���~�m���폜����
            obj.boardObj = obj.boardObj.PopTetrinino(prevState.posX, prevState.posY, obj.currTetrimino.relativePos{prevState.rotate});
            % �X�V��̃e�g���~�m��u����ꍇ
            if obj.boardObj.JudgePutTetrinino(obj.currState.posX, obj.currState.posY, obj.currTetrimino.relativePos{obj.currState.rotate})
                % �X�V��̃e�g���~�m��u��
                obj.boardObj = obj.boardObj.PutTetrinino(obj.currState.posX, obj.currState.posY, obj.currTetrimino.relativePos{obj.currState.rotate}, obj.currState.type);
            % �X�V��̃e�g���~�m��u����Ȃ��ꍇ
            else
                % �X�V�O�̃e�g���~�m���ēx�u��
                obj.boardObj = obj.boardObj.PutTetrinino(prevState.posX, prevState.posY, obj.currTetrimino.relativePos{prevState.rotate}, prevState.type);
                % �u���b�N�Ŗ��܂����s���폜
                obj.boardObj = obj.boardObj.ClearFillLine();
                % �V�K�e�g���~�m���X�|�[��
                obj = obj.SpawnTetrimino();
            end
            % �e�g���~�m�X�V�t���O�𗧂Ă�
            obj.isUpdate = true;
            
        end
        
        
    end
    
    methods
        %% �R���X�g���N�^
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
        
        %% ���C�����[�v��CALL����֐�
        function obj = Run(obj)
            global tetrisParam;
            
            % �X�V�t���O��������
            obj.isUpdate = false;
            
            % �L�[����
            if mod(obj.ctrlLoopCount, tetrisParam.keyinputSampleFrame) == 0
                obj = obj.MoveTetrimino();
                obj.ctrlLoopCount = 0;
            end
            % ����
            if mod(obj.fallLoopCount, tetrisParam.fallSampleFrame) == 0
                obj = obj.FallTetrimino();
                obj.fallLoopCount = 0;
            end
            
            % �J�E���^�X�V
            obj.ctrlLoopCount = obj.ctrlLoopCount + 1;
            obj.fallLoopCount = obj.fallLoopCount + 1;
        end
                
    end
end

