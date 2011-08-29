% RAMANSPECDRIVER Driver to test ramanspec class

clear classes
load TestData.mat;
PNCA001 = ramanspec(sample_10_dried,{'sample_10_dried'});
PNCA001 = set(PNCA001, 'SampleID','PNCA001');

exp = ramanexperiment('Test');
exp = set(exp,'ContainedSamples',[PNCA001,PNCA001+PNCA001]);