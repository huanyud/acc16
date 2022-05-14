# acc16
A simulation of the path planning algorithm in our ACC 2016 paper:

Huanyu Ding, Eric Cristofalo, Joseph Wang, David A. Castañón, Eduardo Montijano, Venkatesh Saligrama, and Mac Schwager, “A multi-resolution approach for discovery and 3D modeling of archaeological sites using satellite imagery and a UAV-borne camera,” In Proc. American Control Conference (ACC), Boston, MA, 2016.

## Algorithms
`greedy_algo.m` implements the algorithm in "**A multi-resolution approach for discovery and 3D modeling of archaeological sites using satellite imagery and a UAV-borne camera**" by **H. Ding**, **E. Cristofalo**, **J. Wang**, **D.A. Castanon**, **E. Montijano**, **V. Saligrama**, and **M. Schwager**, American Control Conference (ACC), 2016.

`benchmark_naive_algo.m` implements a simple greedy benchmark algorithm described in the paper above.

`tsiligirides_algo.m` implements the algorithm in "**Heuristic methods applied to orienteering**" by **T. Tsiligirides**, Journal of the Operational Research Society, vol. 35, no. 9, , pp. 797-809, 1984.

`glv_algo.m` implements the algorithm in "**The orienteering problem**" by **B.L. Golden**, **L. Levy**, and **R. Vohra**, Naval Research Logistics, vol. 34, no. 3, pp. 307–318, 1987.

`CGW_algorithm/cgw_algo.m` implements the algorithm in "**A fast and effective heuristic for the orienteering problem**" by **I.-M. Chao**, **B.L. Golden** and **E.A. Wasil**, European Journal of Operational Research, vol. 88, no. 3, pp. 475–489, 1996.

`pia_algo.m` implements the algorithm in "**The effective application of a new approach to the generalized orienteering problem**" by **J. Silberholz** and **B.L. Golden**, Journal of Heuristics, vol. 16, no. 3, pp. 393–415, 2010.

## Dependencies
### `lkh` or `lkh.exe`
The algorithm in our ACC 2016 paper uses the Lin-Kernighan-Helsgaun (LKH) algorithm for the Traveling Salesman Problem (TSP) as a subroutine. 

Please download the `lkh` (for Unix/Linux) or `lkh.exe` (for Windows) program first. See http://www.akira.ruc.dk/~keld/research/LKH/ for more information on the LKH program.

### `tinevez-matlab-tree`
The tree data structure used in our algorithm. Please see https://github.com/tinevez/matlab-tree for more information.

## How to run
Run 'main3.m'.

To run a specific algorithm, remove comments ahead of it.
