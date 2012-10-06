function [BestFit] = ModelFitBandit(Ntrials)

[ Rew CSs ] = TestBandit_k(Ntrials);
BestFit=ModelFitDriver(CSs,Rew,3);
