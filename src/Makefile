SAC ?= sac2c

bin/nbody_10000: examples/nbody.sac
	$(SAC) -t mt_pth -DN=10000 $< -o $@

bin/nbody_25000: examples/nbody.sac
	$(SAC) -t mt_pth -DN=25000 $< -o $@

bin/nbody_40000: examples/nbody.sac
	$(SAC) -t mt_pth -DN=40000 $< -o $@

bin/stencil_10000: examples/stencil.sac
	$(SAC) -t mt_pth -DN=10000 $< -o $@

bin/stencil_25000: examples/stencil.sac
	$(SAC) -t mt_pth -DN=25000 $< -o $@

bin/stencil_40000: examples/stencil.sac
	$(SAC) -t mt_pth -DN=40000 $< -o $@

bin/matmul_500: examples/matmul.sac
	$(SAC) -t mt_pth -DN=500 $< -o $@

bin/matmul_1000: examples/matmul.sac
	$(SAC) -t mt_pth -DN=1000 $< -o $@

bin/matmul_1500: examples/matmul.sac
	$(SAC) -t mt_pth -DN=1500 $< -o $@

bin/nbody_mtd: examples/nbody_mtd.sac
	$(SAC) -t mt_pth -mt_dynamic $< -o $@

bin/stencil_mtd: examples/stencil_mtd.sac
	$(SAC) -t mt_pth -mt_dynamic $< -o $@

bin/matmul_mtd: examples/matmul_mtd.sac
	$(SAC) -t mt_pth -mt_dynamic $< -o $@

bin/ecodynamic:
	curl -L https://github.com/JordyAaldering/ecodynamic/releases/download/main/server > bin/ecodynamic
	chmod +x bin/ecodynamic

clean:
	$(RM) bin/*
