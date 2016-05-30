function [] = g05(particles, iterations)
	clc;

	% d
	d = 0.01;

	% declaring functions
		% 	obj function
	f = @(x)(3.*x(1) + 0.000001.*x(1).^3 + 2.*x(2) + (0.000002/3).*x(2).^3);

	g1 = @(x)(-x(4) + x(3) - 0.55);
	g2 = @(x)(-x(3) + x(4) - 0.55);

		% converting to inequality
	h3 = @(x)( 1000*sin(-x(3)-0.25) + 1000*sin(-x(4)-0.25) + 894.8 - x(1) - d);
	h4 = @(x)( 1000*sin( x(3)-0.25) + 1000*sin( x(3)-x(4)-0.25) + 894.8 - x(2) - d);
	h5 = @(x)( 1000*sin( x(4)-0.25) + 1000*sin( x(4)-x(3)-0.25) + 1294.8 - d);

		% keep functions in a matrix
	fgh = {f; g1; g2; h3; h4; h5};
		% constraints
	c = [0 1200; 0 1200; -0.55 0.55; -0.55 0.55];

		% calling the fitness function
		% trying to calculate those on 
		% our own
	if nargin ~= 2
		iterations = 6000;
		particles  = 30;
	end

	[mybestsol, mybestf, timeElapsed] = pso(fgh, c, particles, iterations, true);

		% best known solution
	bestsol = [679.9453 1026.067 0.1188764 -0.3962336];
	bestf = f(bestsol);

	fprintf('\n\nResults (Calculated VS Best known) for %d iterations and %d: \n', iterations, particles)
	fprintf('\t f(x): %f \t %f \n', mybestf, bestf);
	fprintf('\t x (calculated): %s \n', num2str(mybestsol));
	fprintf('\t x (best known): %s \n', num2str(bestsol));
	fprintf('\nTime elapsed: %f  \n\n', timeElapsed);

