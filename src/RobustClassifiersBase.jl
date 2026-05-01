module RobustClassifiersBase

export 
    DominanceMatrix, 
    DominancePair, 
    IncomparablePair, 
    Prediction,
    IntervalDominance,
    Maximality,
    EAdmissibility,
    GammaMaxiMax,
    GammaMaxiMin,
    Hurwicz,
    DecisionRuleTypes

include("DecisionTypes.jl")
include("DecisionRuleTypes.jl")

end
