``` 
    The dominance matrix will contain the results from the decision function over the credal set
    (e.g. maximality, E-admissibility etc.)
    1 on row i and col j means that the class represented by index i is dominating class j
    0 if incomparability
```
const DominanceMatrix = Matrix{Bool}

struct DominancePair
	dominant::Int64
	dominate::Int64
	DominancePair(y1::Int64, y2::Int64) = new(y1, y2)
end

struct IncomparablePair
	class1::Int64
	class2::Int64
	IncomparablePair(y1::Int64, y2::Int64) = new(y1, y2)
end


struct Prediction
	undominated::Vector{Int64}
	dominance_pairs::Vector{DominancePair}
	incomparable_pairs::Vector{IncomparablePair}
	function Prediction(dom::DominanceMatrix)
		dominance_pairs::Vector{DominancePair} = DominancePair[]
		incomparable_pairs::Vector{IncomparablePair} = IncomparablePair[]
		for y1 in 1:size(dom,1), y2 ∈ y1:size(dom,1)
			(y1 == y2) && (continue)
			if dom[y1, y2]
				push!(dominance_pairs, DominancePair(y1, y2))
			elseif dom[y2, y1]
				push!(dominance_pairs, DominancePair(y2, y1))
			else
				push!(incomparable_pairs, IncomparablePair(y1, y2))
			end
		end
		undominated::Vector{Int64} = Int64[]
		for y in 1:size(dom,1)
			any(dom[y, :]) && push!(undominated, y)
		end
		new(undominated, dominance_pairs, incomparable_pairs)
	end
end