classdef KeyEvent
    %KEYEVENT キーイベント管理クラス
    %   キーの入力状態を管理する
    %   キーの入力状態は、keyinputStateグローバル変数で取得可能
    
    methods
        %% コンストラクタ
        function obj = KeyEvent()
            % キー入力取得用データ用意
            global keyinputState;
            keyinputState = struct( ...
                'keyInputEsc',   false, ...
                'keyInputUp',    false, ...
                'keyInputDown',  false, ...
                'keyInputLeft',  false, ...
                'keyInputRight', false...
            );
        end
        
        %% キー入力時のイベント関数
        function KeyPressFnc(~, ~, event)
            global keyinputState
            keyinputState.keyInputEsc = strcmp(event.Key, 'escape');
            keyinputState.keyInputUp = strcmp(event.Key, 'uparrow');
            keyinputState.keyInputDown = strcmp(event.Key, 'downarrow');
            keyinputState.keyInputLeft = strcmp(event.Key, 'leftarrow');
            keyinputState.keyInputRight = strcmp(event.Key, 'rightarrow');
        end

        %% キー未入力時のイベント関数
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

