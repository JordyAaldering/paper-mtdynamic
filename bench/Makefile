.PHONY: clean

bin/ecodynamic:
	curl -L https://github.com/JordyAaldering/ecodynamic/releases/download/main/server > bin/ecodynamic
	chmod +x bin/ecodynamic

bin/matmul: sac/matmul.sac
	sac2c -t mt_pth $< -o $@

bin/matmul_mtd: src/matmul_mtd.sac
	$(SAC) -t mt_pth -mt_dynamic $< -o $@

bin/nbody: sac/nbody.sac
	sac2c -t mt_pth $< -o $@

bin/nbody_mtd: sac/nbody_mtd.sac
	sac2c -t mt_pth -mt_dynamic $< -o $@

bin/stencil: sac/stencil.sac
	sac2c -t mt_pth $< -o $@

bin/stencil_mtd: sac/stencil_mtd.sac
	sac2c -t mt_pth -mt_dynamic $< -o $@

clean:
	$(RM) bin/*
	$(RM) -r host/
	$(RM) -r tree/
