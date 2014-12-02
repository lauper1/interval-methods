# https://github.com/johnmyleswhite/ContinuedFractions.jl
using ContinuedFractions

conv(x) = convergents(ContinuedFraction(x), Rational)

function frac(alpha, epsilon)
	n = 1
	while abs(alpha*den(conv(alpha)[n]) - num(conv(alpha)[n])) >= epsilon
		n += 1
	end
	(den(conv(alpha)[n]), num(conv(alpha)[n]))
end

function eff(m, b, epsilon)
	bb = b
	kn = 0
	#i = 0
	
	b1 = b + m*1
	if (b1 < epsilon)
		(q, p) =  (1,0) 
	elseif (1 - b1 < epsilon)
		(q, p) = (1,1)
	else
	b = b1
	r = (1, b1)
	end
	
	
	
	
	while bb > epsilon && 1 - bb > epsilon
		if bb < 0.5
			println("way 1")
			@show (p, q) = frac(m, 2bb)
		else
			println("way 2")
			@show (p, q) = frac(m, 2*(1 - bb))
		end
		#bb = m*q + b - ifloor(m*q + bb)
		bb = mod(m*q + bb, 1)
		kn += q
		#i += 1
		#if i >= 3000
			#println("cycle break: too many iterations")
			#break
		#end
	end
	#println("cycle ended")
	q = kn
	p = ifloor(m*q) + 1
	return (q, p)	
	#return i
end

function first_collision(x, y, vx, vy, delta)
	# Normalize velocity
	
	m = vy/vx
	b = y - m*x
	if vx > 0 && vy > 0
		(q, p) = eff(m, b, delta)
		p = ifloor(m*q) + 1
	elseif vx < 0 && vy > 0
		m = -m
		(q, p) = eff(m, b, delta)
		p = ifloor(m*q) + 1
		m = -m
		q = -q
	elseif vx < 0 && vy < 0
		b = 1 - b
		(q, p) = eff(m, b, delta)
		b = 1 - b
		p = -(ifloor(m*q) + 1)
		q = -q
	elseif vx > 0 && vy < 0
		b = 1 - b
		m = -m
		(q, p) = eff(m, b, delta)
		b = 1 - b
		m = -m
		p = -(ifloor(m*q) + 1)
	end
	return (q, p)
end

#c = sqrt(1.001) # Irrationalizing coefficient
# Split the 1st quadrant into N = 30 equal angular parts
# For each n < N, slope is tg(pi n/(2N))

#N = 30

#=
for n = 1:N-1
	loops = 0
	for m = 1:N
		for b = 1:N
			x = eff(tan(pi*n/(2N))*c, b/N*c, n/N)
			if x == 3000
				loops += 1
				break
			end
		end
	end
	println(n/N, " ", loops/N^2)
end
=#

#=
for n = 1:N-1
	loops = 0
	@show n
	for m = 1:N
		for b = 1:N
			m = tan(pi*rand()/2)
			x = eff(m, rand(), n/N*sqrt(1 + m^2))
			if x == 300
				loops += 1
				break
			end
		end
	end
	println(n/N, " ", loops/N^2)
end
=#
