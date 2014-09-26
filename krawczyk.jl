using IntervalArithmetic
using AutoDiff

	# center(x) = Interval(mid(x))
	function y(x)
		if differentiate(f, mid(x)) == Interval(0) 
			Interval(1)//(differentiate(f, mid(x)))
		else Interval(1)//differentiate(f, mid(x))
		end
	end
	z(x) = 1 - y(x)*differentiate(f, x)
	K(x) = mid(x) - y(x)*f(mid(x)) + z(x)*(x - mid(x))
	do_isect(x, y) = isectext(arr_a[x], arr_b[y])
	
	lower(x::Interval) = Interval(x.lo, mid(x))
	higher(x::Interval) = Interval(mid(x), x.hi)

	x = Ad(a, Interval(1.))

	arr_a = Interval[]
	arr_b = Interval[]

	push!(arr_a, a)

	k = 0
	while k < 20 #true
		
		println(k)
		@show((arr_a, arr_b))
		
		arr_b = Interval[]

		for i = 1:length(arr_a)
			push!(arr_b, K(arr_a[i]))
		end

		arr_a_new = Interval[]

		for i = 1:length(arr_b)
			if do_isect(i, i) != false
				if do_isect(i, i) == arr_a[i]
					arr_a_new = vcat(arr_a_new, isectext(lower(arr_a[i]), arr_b[i]), isectext(higher(arr_a[i]), arr_b[i]))
				else arr_a_new = vcat(arr_a_new, do_isect(i, i))
				end	
			end
		end

		if arr_a_new == arr_a 
			break
		end
		
		arr_a = arr_a_new
		k += 1
	end

	println("Function calls: ", k)
	return arr_a
