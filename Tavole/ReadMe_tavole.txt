SistemiNL: 
			vi sono dei pdf che racchiudono modelli di sistemi non lineari, alcuni sono un bel
			po' complessi, non ho potuto controllarli bene per ora

FRANKA:   
			-dynamic_model: modello dinamico del Franka, per maggior dettaglio si veda https://github.com/marcocognetti/FrankaEmikaPandaDynModel/blob/master/README.txt
							-parameters_retrieval/: Matlab code for the parameters retrieval algorithm for the Franka Emika Panda Robot
							-utils/: A set of useful utility functions
							-data/: Contain the datasets used in the identification process and other data
							-generate_joint_traj/: Contains a set of tools for joint trajectory generation
							-ConvertDynPars2VREP/: Tool that converts the retrieved dynamic parameters according to the V-REP interface
							-dyn_model_panda/: It contains the dynamical model of the Franka Emika Panda Robot in Matla
			
			-franka_control: 		-controllori per il Franka
			-mdl_franka			-modello del franka
			-startup_franka			-carica i file necessari
