""" 
    The dominance matrix will contain the results from the decision function over the credal set
    (e.g. maximality, E-admissibility etc.)
    1 on row i and col j means that the class represented by index i is dominating class j
    0 if incomparability
"""
const DominanceMatrix = Matrix{Bool}

"""
    DominancePair is a struct which meanings is that the class represented by the index in 'dominant'
    is dominating (in the sence of the used decision function) the class represented by the 'dominate' index
"""

struct DominancePair
	dominant::Int64
	dominate::Int64
	DominancePair(y1::Int64, y2::Int64) = new(y1, y2)
end

"""
    IncomparablePair contains two classes which are incomparable w.r.t the used decision function.
    The index representing class1 is smaller than the index of class2 (when built from Prediction struct)
"""
struct IncomparablePair
	class1::Int64
	class2::Int64
	IncomparablePair(y1::Int64, y2::Int64) = new(y1, y2)
end

"""
    Prediction is a struct synthecising the classification taken by the used decision function, 
    as described in the DominanceMatrix.
    - undominated contains the class or classes which are not dominated by another
    - dominance_pairs contains all the pairs of classes where dominance occurs
    - incomparable_pairs contains all the pairs of classes which are incomparable
"""
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