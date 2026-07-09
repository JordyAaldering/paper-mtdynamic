SAC ?= sac2c

bin/nbody_%: examples/nbody.sac
	$(SAC) -t mt_pth -DN=$* $< -o $@

bin/stencil_%: examples/stencil.sac
	$(SAC) -t mt_pth -DN=$* $< -o $@

bin/matmul_%: examples/matmul.sac
	$(SAC) -t mt_pth -DN=$* $< -o $@

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
