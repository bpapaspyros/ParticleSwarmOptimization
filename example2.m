function [] = g06(particles, iterations)
	clc;

	% d
	d = 0.01;

	% declaring functions
		% 	obj function
	f = @(x)( (x(1)-10)^3 + (x(2)-20)^3 );

	g1 = @(x)( -(x(1)-5)^2 - (x(2)-5)^2 + 100 );
	g2 = @(x)(  (x(1)-6)^2 + (x(2)-5)^2 - 82.81 );

		% keep functions in a matrix
	fgh = {f; g1; g2};
		% constraints
	c = [13 100; 0 100];

		% calling the fitness function
		% trying to calculate those on 
		% our own
	if nargin ~= 2
		iterations = 6000;
		particles  = 30;
	end

	[mybestsol, mybestf, timeElapsed] = pso(fgh, c, particles, iterations, true);

		% best known solution
	bestsol = [14.095 0.84296];
	bestf = f(bestsol);

	fprintf('\n\nResults (Calculated VS Best known) for %d iterations and %d: \n', iterations, particles)
	fprintf('\t f(x): %f \t %f \n', mybestf, bestf);
	fprintf('\t x (calculated): %s \n', num2str(mybestsol));
	fprintf('\t x (best known): %s \n', num2str(bestsol));
	fprintf('\nTime elapsed: %f  \n\n', timeElapsed);

