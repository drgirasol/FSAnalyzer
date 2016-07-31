function [ pool ] = updatereset( pool )
pool.reset.filename = [];
pool.reset.Pathname = [];
pool.reset.species = [];
pool.reset.ladder = [];
pool.reset.fragmentcount = [];

pool.reset.minTH = pool.minTH;
pool.reset.pcr = pool.pcr;
pool.reset.statusBOX = pool.statusBOX;
pool.reset.DyeNoDend = pool.DyeNoDend;
pool.reset.currFILE = pool.currFILE;
pool.reset.plot.pnote = pool.plot.pnote;
pool.reset.plot.pcrB = pool.plot.pcrB;
pool.reset.selC = pool.selC;
pool = pool.reset;
pool.reset = pool;
end