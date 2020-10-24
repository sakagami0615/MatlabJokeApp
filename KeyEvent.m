classdef KeyEvent
    %KEYEVENT �L�[�C�x���g�Ǘ��N���X
    %   �L�[�̓��͏�Ԃ��Ǘ�����
    %   �L�[�̓��͏�Ԃ́AkeyinputState�O���[�o���ϐ��Ŏ擾�\
    
    methods
        %% �R���X�g���N�^
        function obj = KeyEvent()
            % �L�[���͎擾�p�f�[�^�p��
            global keyinputState;
            keyinputState = struct( ...
                'keyInputEsc',   false, ...
                'keyInputUp',    false, ...
                'keyInputDown',  false, ...
                'keyInputLeft',  false, ...
                'keyInputRight', false...
            );
        end
        
        %% �L�[���͎��̃C�x���g�֐�
        function KeyPressFnc(~, ~, event)
            global keyinputState
            keyinputState.keyInputEsc = strcmp(event.Key, 'escape');
            keyinputState.keyInputUp = strcmp(event.Key, 'uparrow');
            keyinputState.keyInputDown = strcmp(event.Key, 'downarrow');
            keyinputState.keyInputLeft = strcmp(event.Key, 'leftarrow');
            keyinputState.keyInputRight = strcmp(event.Key, 'rightarrow');
        end

        %% �L�[�����͎��̃C�x���g�֐�
        function KeyReleaseFcn(~, ~, ~)
            global keyinputState
            keyinputState.keyInputEsc = false;
            keyinputState.keyInputUp = false;
            keyinputState.keyInputDown = false;
            keyinputState.keyInputLeft = false;
            keyinputState.keyInputRight = false;
        end
    end
end

