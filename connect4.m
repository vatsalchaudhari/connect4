clc
clear


% Initialize scene
my_scene = simpleGameEngine('ConnectFour.png',86,101);

% Set up variables to name the various sprites
empty_sprite = 1;
red_sprite = 2;
black_sprite = 3;

% Display empty board   
board_display = empty_sprite * ones(6,7);
drawScene(my_scene,board_display)

turn = 1; % This variable keeps tracks of turns played

% Loop iterates until there are no empty spaces on the board
while (turn <= 42)
    [~,col] = getInput(my_scene); % Uses getInput function to get row and column
    sound(1) % plays sound
    row = findRow(col,board_display); % Uses findRow function to find bottom most row
    
    % Loop iterates while the column is full
    while (~row)
        errorMessage = ['Column ', int2str(col), ' is full'];
        disp(msgbox({errorMessage; 'Try another column'}, 'Error', 'error', 'modal'))
        
        [~,col] = getInput(my_scene);
        row = findRow(col,board_display);
    end
    
    % Alternates between the black & red sprite
    if (mod(turn, 2) == 0)
        board_display(row,col) = black_sprite;
    else
        board_display(row,col) = red_sprite;
    end
    
    drawScene(my_scene,board_display) % updates board with sprite
    
    % checks if black has 4 in a row
    if (turn>6 && checkForWin(row,col,board_display) && mod(turn, 2) == 0)
        disp(msgbox('Black Wins!', 'Game Over')); break;
    % checks if red has 4 in a row
    elseif(turn>6 && checkForWin(row,col,board_display) && mod(turn, 2) ~= 0)
        disp(msgbox('Red Wins!', 'Game Over')); break;
    end
    
    turn = turn+1; % increments turn by 1
end

% Checks for tie
if turn > 42
    disp(msgbox('You both tied.', 'Game Over'));
end

% This function convert user mouse input to a row and column
function [row,col] = getInput(obj)
    [X,Y] = ginput(1);
    % Convert this into the tile row/column
    row = ceil(Y/obj.sprite_height/obj.zoom);
    col = ceil(X/obj.sprite_width/obj.zoom);
end

% This function finds the bottom most empty row in the appropriate column
function [row] = findRow(col,board_display)
    % If column is full it returns false
    if(board_display(1, col) ~= 1)
        row = false;
    else
        row = 6; % Row starts at 6
    
        % Iterates until there is an empty row
        while (board_display(row,col) ~= 1)
            row = row-1; % decrements row by 1
        end
    end
end

% % This function checks for 4 in a row
function [result] = checkForWin(r,c,board)
    if checkHorizontal(r,board)||checkVertical(c,board)||checkDiagonal1(board)||checkDiagonal2(board)
        result = true;
    else
        result = false;
    end
end

% This function checks for a horizontal win
function [result] = checkHorizontal(r,board)
    for c=1 : 4
        if board(r,c)==2 && board(r,c+1)==2 && board(r,c+2)==2 && board(r,c+3)==2
            result = true; break;
        elseif board(r,c)==3 && board(r,c+1)==3 && board(r,c+2)==3 && board(r,c+3)==3
            result = true; break;
        else
            result = false;
        end
    end
end

% This function checks for a vertical win
function [result] = checkVertical(c,board)
    for r=1 : 3
        if board(r,c)==2 && board(r+1,c)==2 && board(r+2,c)==2 && board(r+3,c)==2
            result = true; break;
        elseif board(r,c)==3 && board(r+1,c)==3 && board(r+2,c)==3 && board(r+3,c)==3
            result = true; break;
        else
            result = false;
        end
    end
end


% This function checks for a diagonal win (/) positive slope
function [result] = checkDiagonal1(board)
    for r=4 : 6
        for c=1 : 4
            if board(r,c)==2 && board(r-1,c+1)==2 && board(r-2,c+2)==2 && board(r-3,c+3)==2 
                result = true; break;
            elseif board(r,c)==3 && board(r-1,c+1)==3 && board(r-2,c+2)==3 && board(r-3,c+3)==3 
                result = true; break;
            else 
                result = false;
            end
        end
    end
end

% This function checks for a diagonal win (\) negative slope
function [result] = checkDiagonal2(board)
    for r=1 : 3
        for c=1 : 4
            if board(r,c)==2 && board(r+1,c+1)==2 && board(r+2,c+2)==2 && board(r+3,c+3)==2 
                result = true; break;
            elseif board(r,c)==3 && board(r+1,c+1)==3 && board(r+2,c+2)==3 && board(r+3,c+3)==3 
                result = true; break;
            else 
                result = false;
            end
        end
    end
end