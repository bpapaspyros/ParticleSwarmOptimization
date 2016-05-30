function [gbest, best, timeElapsed] = fitness(fgh, constraints, pNum, maxIter, showIter)	
	tic; % start timing

	% getting a handle on the objective function
	fg = fgh{1};

	% pre allocating space for our vectors
	position  = zeros(pNum, size(constraints, 1));
	velocity  = zeros(pNum, size(constraints, 1));

	% letting the user know initialization started
	disp('Initialization started')

	% initializing particle positions
	for k=1:pNum
		while ~checkInequalities(fgh, position(k, :))
			for l=1:size(constraints, 1)
				position(k, l) = random('Uniform', constraints(l, 1), constraints(l, 2), 1, 1); 
			end % for l
		end % while
	
		% initializing particle velocities
		for l=1:size(constraints, 1)
			velocity(k, l) = abs(constraints(l, 1) - constraints(l, 2)) * 1/2; 
		end
	end % for k 

	% initializing pbest and gbest
	pbest = position;
	gbest = position(1, :);
	lposition = position;

	% letting the user know the calculation has begun
	disp('Calculating ...')

	% main loop
	for iter=1:maxIter
		% updating pbest
		for k=1:pNum			
			cur = fg(position(k, :)); % value with current position
			lbest = fg(pbest(k, :));  % value with pbest position

			% check if we need to update pbest
			if cur < lbest && checkInequalities(fgh, position(k, :))
				pbest(k, :) = position(k, :);
			end
		end

		% updating gbest
		for k=1:pNum 
			best = fg(gbest);    % global best position
			b = fg(pbest(k, :)); % pbest for iteration k

			% check if we need to update the gbest
			if b < best
				gbest = pbest(k, :);
			end
		end

		% for every particle
		for k=1:pNum

			% new velocity
			velocity(k, :) = velocity(k, :) + 2.*random('Uniform', -1, 1, 1, size(velocity, 2)).*(pbest(k, :)-position(k, :)) + 2.*random('Uniform', -1, 1, 1, size(velocity, 2)).*(gbest-position(k, :));
			
			% new position
			position(k, :) = position(k, :) + velocity(k, :);

			% make sure to stay within bounds
			for l=1:size(constraints, 1)
				if position(k, l) < constraints(l, 1)
					position(k, l) = constraints(l, 1)*random('Uniform', 0, 1, 1, 1);
				elseif position(k, l) > constraints(l, 2)
					position(k, l) = constraints(l, 2)*random('Uniform', 0, 1, 1, 1);
				end
			end % for l
		end % for k

		% if velocity was zero for 2 iterations we get a new random position
		if position(k, :) == lposition(k, :)
			for l=1:size(constraints, 1)
				position(k, l) = random('Uniform', constraints(l, 1), constraints(l, 2), 1, 1); 
			end % for l
		end

		lposition(k, :) = position(k, :);

		% iteration counter
		if showIter == true
			clc;
			fprintf('- Current iteration: %d \n- Min value calculated so far: %d', iter, fg(gbest));
		end

	end % for iter

	% return the best value and time elapsed
	best = fg(gbest);
	timeElapsed = toc; % stop timer



% checking constraints according to the given functions
function tf = checkInequalities(fgh, x)
	% check the constraints with the given functions
	for k=2:length(fgh)
		func = fgh{k}; % get a handle to the k'th function

		% check if function value is > 0
		% if so, return false
		if func(x) > 0 
			tf = false;
			return;
		end
	end

	% all constraints met
	tf = true;