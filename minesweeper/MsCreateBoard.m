function board = MsCreateBoard()

global msParam;

board = zeros(msParam.boardSize.height, msParam.boardSize.width);
bombNum = msParam.bombRate * (msParam.boardSize.height * msParam.boardSize.width);
bombPosList = randperm(msParam.boardSize.height*msParam.boardSize.width, bombNum);

%乱数で生成した位置にマインがあることを指定
board(bombPosList) = -1;
%マス３×３近傍のマイン数計算
board = board + (board==0).*imfilter(board,-ones(3,3));

end