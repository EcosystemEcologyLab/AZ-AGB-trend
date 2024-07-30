# Trends in Above Ground Biomass in Arizona


<!-- README.md is generated from README.qmd. Please edit that file -->
<!-- badges: start -->

[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)

<!-- badges: end -->

This is a research compendium for work in progress comparing trends in
above-ground biomass in Arizona from different data products. This is a
collaboration between [CCT-Data
Science](https://datascience.cct.arizona.edu/) and the [David Moore
lab](https://djpmoore.tumblr.com/home) at University of Arizona.

## Reproducibility

### Data

The raw data are not contained in this repo and will need to be added
after you clone it. Create a `data/` folder and move the following
folders from the “snow” server to it: Chopping, ESA_CCI, Liu, LT_GNN,
and Xu. Alternatively, you may be able to run this in a way that
directly access files on snow if it is mounted—in `_targets.R`, change
`root <- "data/"` to point to the equivalent folder on the mounted
volume, e.g. `root <- "/Volumes/moore/"`

### `renv`

This project uses
[`renv`](https://rstudio.github.io/renv/articles/renv.html) for package
management. When opening this repo as an RStudio Project for the first
time, `renv` should automatically install itself and prompt you to run
`renv::restore()` to install all package dependencies.

### `targets`

This project uses the [`targets`
package](https://docs.ropensci.org/targets/) for workflow management.
Run `targets::tar_make()` from the console to run the workflow and
reproduce all results. The graph below shows the workflow:

``` mermaid
graph LR
  style Legend fill:#FFFFFF00,stroke:#000000;
  style Graph fill:#FFFFFF00,stroke:#000000;
  subgraph Legend
    direction LR
    xf1522833a4d242c5([""Up to date""]):::uptodate --- x2db1ec7a48f65a9b([""Outdated""]):::outdated
    x2db1ec7a48f65a9b([""Outdated""]):::outdated --- xb6630624a7b3aa0f([""Dispatched""]):::dispatched
    xb6630624a7b3aa0f([""Dispatched""]):::dispatched --- xd03d7c7dd2ddda2b([""Stem""]):::none
    xd03d7c7dd2ddda2b([""Stem""]):::none --- x6f7e04ea3427f824[""Pattern""]:::none
  end
  subgraph Graph
    direction LR
    x362c73969e11896c(["avg_menlove"]):::outdated --> x50cf0456ded10704(["summary_avg_menlove_grazing<br>avg_menlove grazing"]):::outdated
    xf59a011d97d6f12a(["grazing"]):::uptodate --> x50cf0456ded10704(["summary_avg_menlove_grazing<br>avg_menlove grazing"]):::outdated
    xe0e11eeaeac92a26(["avg_esa"]):::outdated --> xd92f0eed94cf722d(["summary_avg_esa_az<br>avg_esa az"]):::outdated
    xd175b91b13bd123d(["az"]):::uptodate --> xd92f0eed94cf722d(["summary_avg_esa_az<br>avg_esa az"]):::outdated
    xd175b91b13bd123d(["az"]):::uptodate --> xe09b277f2cce7c36(["avg_gedi"]):::outdated
    xa21cf5d839044be8(["file_gedi"]):::dispatched --> xe09b277f2cce7c36(["avg_gedi"]):::outdated
    xbc0c37938a8a7f23(["forest"]):::uptodate --> x3a8636093f779dbf(["summary_slope_xu_forest<br>slope_xu forest"]):::outdated
    xd0a9a1247a9acf3a(["slope_xu"]):::outdated --> x3a8636093f779dbf(["summary_slope_xu_forest<br>slope_xu forest"]):::outdated
    xbc19a0d6018eaa1c(["agb_liu"]):::outdated --> xd37fc9b64825c560(["avg_liu"]):::outdated
    x2845c5058e9f8aef(["avg_chopping"]):::outdated --> x65b08f2d0ef68803(["map_avg_chopping<br>avg_chopping"]):::outdated
    xd175b91b13bd123d(["az"]):::uptodate --> x65b08f2d0ef68803(["map_avg_chopping<br>avg_chopping"]):::outdated
    xe0e11eeaeac92a26(["avg_esa"]):::outdated --> x5c18e043d82c4e72(["summary_avg_esa_forest<br>avg_esa forest"]):::outdated
    xbc0c37938a8a7f23(["forest"]):::uptodate --> x5c18e043d82c4e72(["summary_avg_esa_forest<br>avg_esa forest"]):::outdated
    xbc0c37938a8a7f23(["forest"]):::uptodate --> x43f3e06ae2970aaa(["summary_slope_chopping_forest<br>slope_chopping forest"]):::outdated
    xe119d220d3903100(["slope_chopping<br>recombine tiles"]):::outdated --> x43f3e06ae2970aaa(["summary_slope_chopping_forest<br>slope_chopping forest"]):::outdated
    xf59a011d97d6f12a(["grazing"]):::uptodate --> xf452a31c3dfb82fd(["summary_slope_ltgnn_grazing<br>slope_ltgnn grazing"]):::outdated
    x92d8eb7a1c6e0d45(["slope_ltgnn<br>recombine tiles"]):::outdated --> xf452a31c3dfb82fd(["summary_slope_ltgnn_grazing<br>slope_ltgnn grazing"]):::outdated
    xd175b91b13bd123d(["az"]):::uptodate --> xdb1b350d3e25ae99(["summary_slope_chopping_az<br>slope_chopping az"]):::outdated
    xe119d220d3903100(["slope_chopping<br>recombine tiles"]):::outdated --> xdb1b350d3e25ae99(["summary_slope_chopping_az<br>slope_chopping az"]):::outdated
    x77cbe3d593cb2d43(["agb_chopping"]):::outdated --> x9ab15d934f656154(["summary_agb_chopping_az<br>agb_chopping az"]):::outdated
    xd175b91b13bd123d(["az"]):::uptodate --> x9ab15d934f656154(["summary_agb_chopping_az<br>agb_chopping az"]):::outdated
    x2173e4c903ac22de(["agb_ltgnn"]):::outdated --> x813b2d9782d4739d(["summary_agb_ltgnn_az<br>agb_ltgnn az"]):::outdated
    xd175b91b13bd123d(["az"]):::uptodate --> x813b2d9782d4739d(["summary_agb_ltgnn_az<br>agb_ltgnn az"]):::outdated
    xf59a011d97d6f12a(["grazing"]):::uptodate --> xba5dd31799fd36d8(["summary_slope_esa_grazing<br>slope_esa grazing"]):::outdated
    x7e6fa45e50ec29d0(["slope_esa<br>recombine tiles"]):::outdated --> xba5dd31799fd36d8(["summary_slope_esa_grazing<br>slope_esa grazing"]):::outdated
    x362c73969e11896c(["avg_menlove"]):::outdated --> x0dc909fa551e2f7c(["summary_avg_menlove_forest<br>avg_menlove forest"]):::outdated
    xbc0c37938a8a7f23(["forest"]):::uptodate --> x0dc909fa551e2f7c(["summary_avg_menlove_forest<br>avg_menlove forest"]):::outdated
    xd175b91b13bd123d(["az"]):::uptodate --> x2173e4c903ac22de(["agb_ltgnn"]):::outdated
    x0f295d6ee27609ef(["dir_ltgnn"]):::dispatched --> x2173e4c903ac22de(["agb_ltgnn"]):::outdated
    xe09b277f2cce7c36(["avg_gedi"]):::outdated --> x0bab3afdedaf0eca(["summary_avg_gedi_pima<br>avg_gedi pima"]):::outdated
    xc7806e6395dc77f0(["pima"]):::uptodate --> x0bab3afdedaf0eca(["summary_avg_gedi_pima<br>avg_gedi pima"]):::outdated
    xd37fc9b64825c560(["avg_liu"]):::outdated --> xfc8ca7bd7dcc72e8(["summary_avg_liu_az<br>avg_liu az"]):::outdated
    xd175b91b13bd123d(["az"]):::uptodate --> xfc8ca7bd7dcc72e8(["summary_avg_liu_az<br>avg_liu az"]):::outdated
    x77cbe3d593cb2d43(["agb_chopping"]):::outdated --> xb58c02e87241a3fd(["summary_agb_chopping_pima<br>agb_chopping pima"]):::outdated
    xc7806e6395dc77f0(["pima"]):::uptodate --> xb58c02e87241a3fd(["summary_agb_chopping_pima<br>agb_chopping pima"]):::outdated
    xd175b91b13bd123d(["az"]):::uptodate --> x4afa489f093f813d(["summary_slope_esa_az<br>slope_esa az"]):::outdated
    x7e6fa45e50ec29d0(["slope_esa<br>recombine tiles"]):::outdated --> x4afa489f093f813d(["summary_slope_esa_az<br>slope_esa az"]):::outdated
    xe09b277f2cce7c36(["avg_gedi"]):::outdated --> x512de232c4c08abf(["map_avg_gedi<br>avg_gedi"]):::outdated
    xd175b91b13bd123d(["az"]):::uptodate --> x512de232c4c08abf(["map_avg_gedi<br>avg_gedi"]):::outdated
    x2845c5058e9f8aef(["avg_chopping"]):::outdated --> xe42054a0b9f880cc(["summary_avg_chopping_az<br>avg_chopping az"]):::outdated
    xd175b91b13bd123d(["az"]):::uptodate --> xe42054a0b9f880cc(["summary_avg_chopping_az<br>avg_chopping az"]):::outdated
    xa8922e00bbeb0d22(["summary_avg"]):::outdated --> x5e3fa6533b348023(["summary_avg_csv"]):::outdated
    xe119d220d3903100(["slope_chopping<br>recombine tiles"]):::outdated --> x233993926a893e13(["summary_slope_chopping_wilderness<br>slope_chopping wilderness"]):::outdated
    x1e70594f4ceaaf92(["wilderness"]):::uptodate --> x233993926a893e13(["summary_slope_chopping_wilderness<br>slope_chopping wilderness"]):::outdated
    xce7164452e083ea7(["avg_ltgnn"]):::outdated --> x80e77ccd4a49d1e6(["summary_avg_ltgnn_az<br>avg_ltgnn az"]):::outdated
    xd175b91b13bd123d(["az"]):::uptodate --> x80e77ccd4a49d1e6(["summary_avg_ltgnn_az<br>avg_ltgnn az"]):::outdated
    xd175b91b13bd123d(["az"]):::uptodate --> xaf6d6b4b557c99d9(["agb_xu"]):::outdated
    xd7c413f770bf7058(["file_xu"]):::outdated --> xaf6d6b4b557c99d9(["agb_xu"]):::outdated
    x2173e4c903ac22de(["agb_ltgnn"]):::outdated --> xce7164452e083ea7(["avg_ltgnn"]):::outdated
    xe0e11eeaeac92a26(["avg_esa"]):::outdated --> xe711da9780a303cb(["map_avg_esa<br>avg_esa"]):::outdated
    xd175b91b13bd123d(["az"]):::uptodate --> xe711da9780a303cb(["map_avg_esa<br>avg_esa"]):::outdated
    xff5e2469295493cf(["agb_esa"]):::outdated --> x41cc2ed88a4a4959(["summary_agb_esa_az<br>agb_esa az"]):::outdated
    xd175b91b13bd123d(["az"]):::uptodate --> x41cc2ed88a4a4959(["summary_agb_esa_az<br>agb_esa az"]):::outdated
    xe6a12927573470a4["tiles_slope_esa"]:::outdated --> x7e6fa45e50ec29d0(["slope_esa<br>recombine tiles"]):::outdated
    xd37fc9b64825c560(["avg_liu"]):::outdated --> x521430bdf8700e8c(["summary_avg_liu_grazing<br>avg_liu grazing"]):::outdated
    xf59a011d97d6f12a(["grazing"]):::uptodate --> x521430bdf8700e8c(["summary_avg_liu_grazing<br>avg_liu grazing"]):::outdated
    x2173e4c903ac22de(["agb_ltgnn"]):::outdated --> xaae2459862dab5f1(["summary_agb_ltgnn_wilderness<br>agb_ltgnn wilderness"]):::outdated
    x1e70594f4ceaaf92(["wilderness"]):::uptodate --> xaae2459862dab5f1(["summary_agb_ltgnn_wilderness<br>agb_ltgnn wilderness"]):::outdated
    xe0e11eeaeac92a26(["avg_esa"]):::outdated --> xd260d238f730e290(["summary_avg_esa_wilderness<br>avg_esa wilderness"]):::outdated
    x1e70594f4ceaaf92(["wilderness"]):::uptodate --> xd260d238f730e290(["summary_avg_esa_wilderness<br>avg_esa wilderness"]):::outdated
    xd175b91b13bd123d(["az"]):::uptodate --> xbc0c37938a8a7f23(["forest"]):::uptodate
    x85a88a617aba43db(["file_forest"]):::uptodate --> xbc0c37938a8a7f23(["forest"]):::uptodate
    x77cbe3d593cb2d43(["agb_chopping"]):::outdated --> xd4df5df11594a110(["summary_agb_chopping_grazing<br>agb_chopping grazing"]):::outdated
    xf59a011d97d6f12a(["grazing"]):::uptodate --> xd4df5df11594a110(["summary_agb_chopping_grazing<br>agb_chopping grazing"]):::outdated
    xff5e2469295493cf(["agb_esa"]):::outdated --> x8e8e19dd383ef894(["summary_agb_esa_grazing<br>agb_esa grazing"]):::outdated
    xf59a011d97d6f12a(["grazing"]):::uptodate --> x8e8e19dd383ef894(["summary_agb_esa_grazing<br>agb_esa grazing"]):::outdated
    xdb1b350d3e25ae99(["summary_slope_chopping_az<br>slope_chopping az"]):::outdated --> x1c41c311396266df(["summary_slope"]):::outdated
    x43f3e06ae2970aaa(["summary_slope_chopping_forest<br>slope_chopping forest"]):::outdated --> x1c41c311396266df(["summary_slope"]):::outdated
    xf13fbf6f44cbb493(["summary_slope_chopping_grazing<br>slope_chopping grazing"]):::outdated --> x1c41c311396266df(["summary_slope"]):::outdated
    x63ddbeccd0d557ce(["summary_slope_chopping_pima<br>slope_chopping pima"]):::outdated --> x1c41c311396266df(["summary_slope"]):::outdated
    x233993926a893e13(["summary_slope_chopping_wilderness<br>slope_chopping wilderness"]):::outdated --> x1c41c311396266df(["summary_slope"]):::outdated
    x4afa489f093f813d(["summary_slope_esa_az<br>slope_esa az"]):::outdated --> x1c41c311396266df(["summary_slope"]):::outdated
    xb6a9e0cd928f2675(["summary_slope_esa_forest<br>slope_esa forest"]):::outdated --> x1c41c311396266df(["summary_slope"]):::outdated
    xba5dd31799fd36d8(["summary_slope_esa_grazing<br>slope_esa grazing"]):::outdated --> x1c41c311396266df(["summary_slope"]):::outdated
    x51b3777c9b968240(["summary_slope_esa_pima<br>slope_esa pima"]):::outdated --> x1c41c311396266df(["summary_slope"]):::outdated
    xea771a04c84d81ce(["summary_slope_esa_wilderness<br>slope_esa wilderness"]):::outdated --> x1c41c311396266df(["summary_slope"]):::outdated
    x23d2dddb8b4d468d(["summary_slope_liu_az<br>slope_liu az"]):::outdated --> x1c41c311396266df(["summary_slope"]):::outdated
    x43019e7527698ff0(["summary_slope_liu_forest<br>slope_liu forest"]):::outdated --> x1c41c311396266df(["summary_slope"]):::outdated
    xfd5767961ec332dc(["summary_slope_liu_grazing<br>slope_liu grazing"]):::outdated --> x1c41c311396266df(["summary_slope"]):::outdated
    x40d6f95217c56731(["summary_slope_liu_pima<br>slope_liu pima"]):::outdated --> x1c41c311396266df(["summary_slope"]):::outdated
    xc273acc4788a090a(["summary_slope_liu_wilderness<br>slope_liu wilderness"]):::outdated --> x1c41c311396266df(["summary_slope"]):::outdated
    x8d84a39ead4d60f2(["summary_slope_ltgnn_az<br>slope_ltgnn az"]):::outdated --> x1c41c311396266df(["summary_slope"]):::outdated
    x152c6d581d1495fb(["summary_slope_ltgnn_forest<br>slope_ltgnn forest"]):::outdated --> x1c41c311396266df(["summary_slope"]):::outdated
    xf452a31c3dfb82fd(["summary_slope_ltgnn_grazing<br>slope_ltgnn grazing"]):::outdated --> x1c41c311396266df(["summary_slope"]):::outdated
    x584108227a8877b2(["summary_slope_ltgnn_pima<br>slope_ltgnn pima"]):::outdated --> x1c41c311396266df(["summary_slope"]):::outdated
    xcc67952bbe5e9006(["summary_slope_ltgnn_wilderness<br>slope_ltgnn wilderness"]):::outdated --> x1c41c311396266df(["summary_slope"]):::outdated
    xb372d528e437a0b6(["summary_slope_xu_az<br>slope_xu az"]):::outdated --> x1c41c311396266df(["summary_slope"]):::outdated
    x3a8636093f779dbf(["summary_slope_xu_forest<br>slope_xu forest"]):::outdated --> x1c41c311396266df(["summary_slope"]):::outdated
    x4da065287d8173ab(["summary_slope_xu_grazing<br>slope_xu grazing"]):::outdated --> x1c41c311396266df(["summary_slope"]):::outdated
    x28f558d535ac8cf2(["summary_slope_xu_pima<br>slope_xu pima"]):::outdated --> x1c41c311396266df(["summary_slope"]):::outdated
    x8329fce609b4ae09(["summary_slope_xu_wilderness<br>slope_xu wilderness"]):::outdated --> x1c41c311396266df(["summary_slope"]):::outdated
    xe4f00e0ffdff9ac9["tiles_agb_chopping"]:::outdated --> x581136bf2fbd250d["tiles_slope_chopping"]:::outdated
    xaf6d6b4b557c99d9(["agb_xu"]):::outdated --> x12a08ae91d7b3a08(["summary_agb_xu_forest<br>agb_xu forest"]):::outdated
    xbc0c37938a8a7f23(["forest"]):::uptodate --> x12a08ae91d7b3a08(["summary_agb_xu_forest<br>agb_xu forest"]):::outdated
    xce7164452e083ea7(["avg_ltgnn"]):::outdated --> xa9dc84fe18bed8cb(["summary_avg_ltgnn_pima<br>avg_ltgnn pima"]):::outdated
    xc7806e6395dc77f0(["pima"]):::uptodate --> xa9dc84fe18bed8cb(["summary_avg_ltgnn_pima<br>avg_ltgnn pima"]):::outdated
    xd175b91b13bd123d(["az"]):::uptodate --> x23d2dddb8b4d468d(["summary_slope_liu_az<br>slope_liu az"]):::outdated
    x2f277a2639a2f721(["slope_liu"]):::outdated --> x23d2dddb8b4d468d(["summary_slope_liu_az<br>slope_liu az"]):::outdated
    xbc0c37938a8a7f23(["forest"]):::uptodate --> x152c6d581d1495fb(["summary_slope_ltgnn_forest<br>slope_ltgnn forest"]):::outdated
    x92d8eb7a1c6e0d45(["slope_ltgnn<br>recombine tiles"]):::outdated --> x152c6d581d1495fb(["summary_slope_ltgnn_forest<br>slope_ltgnn forest"]):::outdated
    xff5e2469295493cf(["agb_esa"]):::outdated --> xf35ce321bdfd9069(["summary_agb_esa_pima<br>agb_esa pima"]):::outdated
    xc7806e6395dc77f0(["pima"]):::uptodate --> xf35ce321bdfd9069(["summary_agb_esa_pima<br>agb_esa pima"]):::outdated
    xab765c69ea0afd8b(["avg_xu"]):::outdated --> x739c949301a78b29(["summary_avg_xu_forest<br>avg_xu forest"]):::outdated
    xbc0c37938a8a7f23(["forest"]):::uptodate --> x739c949301a78b29(["summary_avg_xu_forest<br>avg_xu forest"]):::outdated
    xf7e62795e93b1826["tiles_agb_ltgnn"]:::outdated --> x93c715afead0a10c["tiles_slope_ltgnn"]:::outdated
    xf59a011d97d6f12a(["grazing"]):::uptodate --> xf13fbf6f44cbb493(["summary_slope_chopping_grazing<br>slope_chopping grazing"]):::outdated
    xe119d220d3903100(["slope_chopping<br>recombine tiles"]):::outdated --> xf13fbf6f44cbb493(["summary_slope_chopping_grazing<br>slope_chopping grazing"]):::outdated
    x2173e4c903ac22de(["agb_ltgnn"]):::outdated --> xa2b9a2a0e58773ca(["summary_agb_ltgnn_grazing<br>agb_ltgnn grazing"]):::outdated
    xf59a011d97d6f12a(["grazing"]):::uptodate --> xa2b9a2a0e58773ca(["summary_agb_ltgnn_grazing<br>agb_ltgnn grazing"]):::outdated
    x362c73969e11896c(["avg_menlove"]):::outdated --> xb54108dfd45247a8(["summary_avg_menlove_pima<br>avg_menlove pima"]):::outdated
    xc7806e6395dc77f0(["pima"]):::uptodate --> xb54108dfd45247a8(["summary_avg_menlove_pima<br>avg_menlove pima"]):::outdated
    xd37fc9b64825c560(["avg_liu"]):::outdated --> x5be4a13ebfcd282e(["map_avg_liu<br>avg_liu"]):::outdated
    xd175b91b13bd123d(["az"]):::uptodate --> x5be4a13ebfcd282e(["map_avg_liu<br>avg_liu"]):::outdated
    xbc19a0d6018eaa1c(["agb_liu"]):::outdated --> x58112906d882e0ac(["summary_agb_liu_grazing<br>agb_liu grazing"]):::outdated
    xf59a011d97d6f12a(["grazing"]):::uptodate --> x58112906d882e0ac(["summary_agb_liu_grazing<br>agb_liu grazing"]):::outdated
    xbc19a0d6018eaa1c(["agb_liu"]):::outdated --> x6ae84e09c72ffab7(["summary_agb_liu_az<br>agb_liu az"]):::outdated
    xd175b91b13bd123d(["az"]):::uptodate --> x6ae84e09c72ffab7(["summary_agb_liu_az<br>agb_liu az"]):::outdated
    x82da0520708aba1e(["dir_pima"]):::uptodate --> xc7806e6395dc77f0(["pima"]):::uptodate
    xd37fc9b64825c560(["avg_liu"]):::outdated --> x947c22e2543131f6(["summary_avg_liu_wilderness<br>avg_liu wilderness"]):::outdated
    x1e70594f4ceaaf92(["wilderness"]):::uptodate --> x947c22e2543131f6(["summary_avg_liu_wilderness<br>avg_liu wilderness"]):::outdated
    xe09b277f2cce7c36(["avg_gedi"]):::outdated --> x6016eef1dfbb2190(["summary_avg_gedi_forest<br>avg_gedi forest"]):::outdated
    xbc0c37938a8a7f23(["forest"]):::uptodate --> x6016eef1dfbb2190(["summary_avg_gedi_forest<br>avg_gedi forest"]):::outdated
    x2173e4c903ac22de(["agb_ltgnn"]):::outdated --> xa453d5fba81aa0a1(["summary_agb_ltgnn_pima<br>agb_ltgnn pima"]):::outdated
    xc7806e6395dc77f0(["pima"]):::uptodate --> xa453d5fba81aa0a1(["summary_agb_ltgnn_pima<br>agb_ltgnn pima"]):::outdated
    x77cbe3d593cb2d43(["agb_chopping"]):::outdated --> xe4f00e0ffdff9ac9["tiles_agb_chopping"]:::outdated
    xa4e4ad6dff7fba44(["tiles_agb_chopping_exts"]):::outdated --> xe4f00e0ffdff9ac9["tiles_agb_chopping"]:::outdated
    xe42054a0b9f880cc(["summary_avg_chopping_az<br>avg_chopping az"]):::outdated --> xa8922e00bbeb0d22(["summary_avg"]):::outdated
    x6ed505d5d5b3b6d9(["summary_avg_chopping_forest<br>avg_chopping forest"]):::outdated --> xa8922e00bbeb0d22(["summary_avg"]):::outdated
    x6745d86a7cabf031(["summary_avg_chopping_grazing<br>avg_chopping grazing"]):::outdated --> xa8922e00bbeb0d22(["summary_avg"]):::outdated
    x1fff5af5ac13d38c(["summary_avg_chopping_pima<br>avg_chopping pima"]):::outdated --> xa8922e00bbeb0d22(["summary_avg"]):::outdated
    x176ce95398af7666(["summary_avg_chopping_wilderness<br>avg_chopping wilderness"]):::outdated --> xa8922e00bbeb0d22(["summary_avg"]):::outdated
    xd92f0eed94cf722d(["summary_avg_esa_az<br>avg_esa az"]):::outdated --> xa8922e00bbeb0d22(["summary_avg"]):::outdated
    x5c18e043d82c4e72(["summary_avg_esa_forest<br>avg_esa forest"]):::outdated --> xa8922e00bbeb0d22(["summary_avg"]):::outdated
    xf48ae011e191afa2(["summary_avg_esa_grazing<br>avg_esa grazing"]):::outdated --> xa8922e00bbeb0d22(["summary_avg"]):::outdated
    x547c5b30e0e61dd9(["summary_avg_esa_pima<br>avg_esa pima"]):::outdated --> xa8922e00bbeb0d22(["summary_avg"]):::outdated
    xd260d238f730e290(["summary_avg_esa_wilderness<br>avg_esa wilderness"]):::outdated --> xa8922e00bbeb0d22(["summary_avg"]):::outdated
    x26cd8f2f25ab8591(["summary_avg_gedi_az<br>avg_gedi az"]):::outdated --> xa8922e00bbeb0d22(["summary_avg"]):::outdated
    x6016eef1dfbb2190(["summary_avg_gedi_forest<br>avg_gedi forest"]):::outdated --> xa8922e00bbeb0d22(["summary_avg"]):::outdated
    x2f0fbf3ab8c5aa0e(["summary_avg_gedi_grazing<br>avg_gedi grazing"]):::outdated --> xa8922e00bbeb0d22(["summary_avg"]):::outdated
    x0bab3afdedaf0eca(["summary_avg_gedi_pima<br>avg_gedi pima"]):::outdated --> xa8922e00bbeb0d22(["summary_avg"]):::outdated
    xf146ed3a9957b8ff(["summary_avg_gedi_wilderness<br>avg_gedi wilderness"]):::outdated --> xa8922e00bbeb0d22(["summary_avg"]):::outdated
    xfc8ca7bd7dcc72e8(["summary_avg_liu_az<br>avg_liu az"]):::outdated --> xa8922e00bbeb0d22(["summary_avg"]):::outdated
    x87db7fb0eeceb7b6(["summary_avg_liu_forest<br>avg_liu forest"]):::outdated --> xa8922e00bbeb0d22(["summary_avg"]):::outdated
    x521430bdf8700e8c(["summary_avg_liu_grazing<br>avg_liu grazing"]):::outdated --> xa8922e00bbeb0d22(["summary_avg"]):::outdated
    x46b14b74e3ee43b1(["summary_avg_liu_pima<br>avg_liu pima"]):::outdated --> xa8922e00bbeb0d22(["summary_avg"]):::outdated
    x947c22e2543131f6(["summary_avg_liu_wilderness<br>avg_liu wilderness"]):::outdated --> xa8922e00bbeb0d22(["summary_avg"]):::outdated
    x80e77ccd4a49d1e6(["summary_avg_ltgnn_az<br>avg_ltgnn az"]):::outdated --> xa8922e00bbeb0d22(["summary_avg"]):::outdated
    xa4db64cf18ef79c4(["summary_avg_ltgnn_forest<br>avg_ltgnn forest"]):::outdated --> xa8922e00bbeb0d22(["summary_avg"]):::outdated
    xbb03acdda0302bbf(["summary_avg_ltgnn_grazing<br>avg_ltgnn grazing"]):::outdated --> xa8922e00bbeb0d22(["summary_avg"]):::outdated
    xa9dc84fe18bed8cb(["summary_avg_ltgnn_pima<br>avg_ltgnn pima"]):::outdated --> xa8922e00bbeb0d22(["summary_avg"]):::outdated
    x2c23b61edddf4c1b(["summary_avg_ltgnn_wilderness<br>avg_ltgnn wilderness"]):::outdated --> xa8922e00bbeb0d22(["summary_avg"]):::outdated
    x4d93207ec1c13dd9(["summary_avg_menlove_az<br>avg_menlove az"]):::outdated --> xa8922e00bbeb0d22(["summary_avg"]):::outdated
    x0dc909fa551e2f7c(["summary_avg_menlove_forest<br>avg_menlove forest"]):::outdated --> xa8922e00bbeb0d22(["summary_avg"]):::outdated
    x50cf0456ded10704(["summary_avg_menlove_grazing<br>avg_menlove grazing"]):::outdated --> xa8922e00bbeb0d22(["summary_avg"]):::outdated
    xb54108dfd45247a8(["summary_avg_menlove_pima<br>avg_menlove pima"]):::outdated --> xa8922e00bbeb0d22(["summary_avg"]):::outdated
    x8279a1b14ecded4d(["summary_avg_menlove_wilderness<br>avg_menlove wilderness"]):::outdated --> xa8922e00bbeb0d22(["summary_avg"]):::outdated
    xdaa0bd159fbd90b9(["summary_avg_xu_az<br>avg_xu az"]):::outdated --> xa8922e00bbeb0d22(["summary_avg"]):::outdated
    x739c949301a78b29(["summary_avg_xu_forest<br>avg_xu forest"]):::outdated --> xa8922e00bbeb0d22(["summary_avg"]):::outdated
    xf2210586c7376cbe(["summary_avg_xu_grazing<br>avg_xu grazing"]):::outdated --> xa8922e00bbeb0d22(["summary_avg"]):::outdated
    x4b5420324ea606be(["summary_avg_xu_pima<br>avg_xu pima"]):::outdated --> xa8922e00bbeb0d22(["summary_avg"]):::outdated
    x4526a18020fe5aec(["summary_avg_xu_wilderness<br>avg_xu wilderness"]):::outdated --> xa8922e00bbeb0d22(["summary_avg"]):::outdated
    xab765c69ea0afd8b(["avg_xu"]):::outdated --> xf2210586c7376cbe(["summary_avg_xu_grazing<br>avg_xu grazing"]):::outdated
    xf59a011d97d6f12a(["grazing"]):::uptodate --> xf2210586c7376cbe(["summary_avg_xu_grazing<br>avg_xu grazing"]):::outdated
    x362c73969e11896c(["avg_menlove"]):::outdated --> x8279a1b14ecded4d(["summary_avg_menlove_wilderness<br>avg_menlove wilderness"]):::outdated
    x1e70594f4ceaaf92(["wilderness"]):::uptodate --> x8279a1b14ecded4d(["summary_avg_menlove_wilderness<br>avg_menlove wilderness"]):::outdated
    x6cc03a032cc82abc(["file_az"]):::uptodate --> xd175b91b13bd123d(["az"]):::uptodate
    xce7164452e083ea7(["avg_ltgnn"]):::outdated --> xbb03acdda0302bbf(["summary_avg_ltgnn_grazing<br>avg_ltgnn grazing"]):::outdated
    xf59a011d97d6f12a(["grazing"]):::uptodate --> xbb03acdda0302bbf(["summary_avg_ltgnn_grazing<br>avg_ltgnn grazing"]):::outdated
    xbc0c37938a8a7f23(["forest"]):::uptodate --> xb6a9e0cd928f2675(["summary_slope_esa_forest<br>slope_esa forest"]):::outdated
    x7e6fa45e50ec29d0(["slope_esa<br>recombine tiles"]):::outdated --> xb6a9e0cd928f2675(["summary_slope_esa_forest<br>slope_esa forest"]):::outdated
    xce7164452e083ea7(["avg_ltgnn"]):::outdated --> x2c23b61edddf4c1b(["summary_avg_ltgnn_wilderness<br>avg_ltgnn wilderness"]):::outdated
    x1e70594f4ceaaf92(["wilderness"]):::uptodate --> x2c23b61edddf4c1b(["summary_avg_ltgnn_wilderness<br>avg_ltgnn wilderness"]):::outdated
    xab765c69ea0afd8b(["avg_xu"]):::outdated --> xdaa0bd159fbd90b9(["summary_avg_xu_az<br>avg_xu az"]):::outdated
    xd175b91b13bd123d(["az"]):::uptodate --> xdaa0bd159fbd90b9(["summary_avg_xu_az<br>avg_xu az"]):::outdated
    xab765c69ea0afd8b(["avg_xu"]):::outdated --> x48f5a86c2ddca733(["map_avg_xu<br>avg_xu"]):::outdated
    xd175b91b13bd123d(["az"]):::uptodate --> x48f5a86c2ddca733(["map_avg_xu<br>avg_xu"]):::outdated
    xe09b277f2cce7c36(["avg_gedi"]):::outdated --> x2f0fbf3ab8c5aa0e(["summary_avg_gedi_grazing<br>avg_gedi grazing"]):::outdated
    xf59a011d97d6f12a(["grazing"]):::uptodate --> x2f0fbf3ab8c5aa0e(["summary_avg_gedi_grazing<br>avg_gedi grazing"]):::outdated
    x77cbe3d593cb2d43(["agb_chopping"]):::outdated --> xf2e4ec3dfa0e7f01(["summary_agb_chopping_forest<br>agb_chopping forest"]):::outdated
    xbc0c37938a8a7f23(["forest"]):::uptodate --> xf2e4ec3dfa0e7f01(["summary_agb_chopping_forest<br>agb_chopping forest"]):::outdated
    xff5e2469295493cf(["agb_esa"]):::outdated --> x20d1ac09aae31387(["tiles_agb_esa_exts"]):::outdated
    xab765c69ea0afd8b(["avg_xu"]):::outdated --> x4b5420324ea606be(["summary_avg_xu_pima<br>avg_xu pima"]):::outdated
    xc7806e6395dc77f0(["pima"]):::uptodate --> x4b5420324ea606be(["summary_avg_xu_pima<br>avg_xu pima"]):::outdated
    xd37fc9b64825c560(["avg_liu"]):::outdated --> x46b14b74e3ee43b1(["summary_avg_liu_pima<br>avg_liu pima"]):::outdated
    xc7806e6395dc77f0(["pima"]):::uptodate --> x46b14b74e3ee43b1(["summary_avg_liu_pima<br>avg_liu pima"]):::outdated
    x2173e4c903ac22de(["agb_ltgnn"]):::outdated --> xaa53c027d65e1306(["tiles_agb_ltgnn_exts"]):::outdated
    xd175b91b13bd123d(["az"]):::uptodate --> x362c73969e11896c(["avg_menlove"]):::outdated
    x5313d669c7ef4b5b(["file_menlove"]):::outdated --> x362c73969e11896c(["avg_menlove"]):::outdated
    xaf6d6b4b557c99d9(["agb_xu"]):::outdated --> xab765c69ea0afd8b(["avg_xu"]):::outdated
    xab765c69ea0afd8b(["avg_xu"]):::outdated --> x4526a18020fe5aec(["summary_avg_xu_wilderness<br>avg_xu wilderness"]):::outdated
    x1e70594f4ceaaf92(["wilderness"]):::uptodate --> x4526a18020fe5aec(["summary_avg_xu_wilderness<br>avg_xu wilderness"]):::outdated
    xd175b91b13bd123d(["az"]):::uptodate --> xf59a011d97d6f12a(["grazing"]):::uptodate
    x612011bac0c2064c(["file_grazing"]):::uptodate --> xf59a011d97d6f12a(["grazing"]):::uptodate
    xce7164452e083ea7(["avg_ltgnn"]):::outdated --> xa4db64cf18ef79c4(["summary_avg_ltgnn_forest<br>avg_ltgnn forest"]):::outdated
    xbc0c37938a8a7f23(["forest"]):::uptodate --> xa4db64cf18ef79c4(["summary_avg_ltgnn_forest<br>avg_ltgnn forest"]):::outdated
    xe0e11eeaeac92a26(["avg_esa"]):::outdated --> x547c5b30e0e61dd9(["summary_avg_esa_pima<br>avg_esa pima"]):::outdated
    xc7806e6395dc77f0(["pima"]):::uptodate --> x547c5b30e0e61dd9(["summary_avg_esa_pima<br>avg_esa pima"]):::outdated
    x362c73969e11896c(["avg_menlove"]):::outdated --> xe0788df647ee7d1b(["map_avg_menlove<br>avg_menlove"]):::outdated
    xd175b91b13bd123d(["az"]):::uptodate --> xe0788df647ee7d1b(["map_avg_menlove<br>avg_menlove"]):::outdated
    xc7806e6395dc77f0(["pima"]):::uptodate --> x51b3777c9b968240(["summary_slope_esa_pima<br>slope_esa pima"]):::outdated
    x7e6fa45e50ec29d0(["slope_esa<br>recombine tiles"]):::outdated --> x51b3777c9b968240(["summary_slope_esa_pima<br>slope_esa pima"]):::outdated
    x93c715afead0a10c["tiles_slope_ltgnn"]:::outdated --> x92d8eb7a1c6e0d45(["slope_ltgnn<br>recombine tiles"]):::outdated
    xff5e2469295493cf(["agb_esa"]):::outdated --> x58dd2247fb268089(["summary_agb_esa_wilderness<br>agb_esa wilderness"]):::outdated
    x1e70594f4ceaaf92(["wilderness"]):::uptodate --> x58dd2247fb268089(["summary_agb_esa_wilderness<br>agb_esa wilderness"]):::outdated
    x77cbe3d593cb2d43(["agb_chopping"]):::outdated --> xa4e4ad6dff7fba44(["tiles_agb_chopping_exts"]):::outdated
    xe09b277f2cce7c36(["avg_gedi"]):::outdated --> x26cd8f2f25ab8591(["summary_avg_gedi_az<br>avg_gedi az"]):::outdated
    xd175b91b13bd123d(["az"]):::uptodate --> x26cd8f2f25ab8591(["summary_avg_gedi_az<br>avg_gedi az"]):::outdated
    xd0a9a1247a9acf3a(["slope_xu"]):::outdated --> x8329fce609b4ae09(["summary_slope_xu_wilderness<br>slope_xu wilderness"]):::outdated
    x1e70594f4ceaaf92(["wilderness"]):::uptodate --> x8329fce609b4ae09(["summary_slope_xu_wilderness<br>slope_xu wilderness"]):::outdated
    x2173e4c903ac22de(["agb_ltgnn"]):::outdated --> xf7e62795e93b1826["tiles_agb_ltgnn"]:::outdated
    xaa53c027d65e1306(["tiles_agb_ltgnn_exts"]):::outdated --> xf7e62795e93b1826["tiles_agb_ltgnn"]:::outdated
    x2845c5058e9f8aef(["avg_chopping"]):::outdated --> x1fff5af5ac13d38c(["summary_avg_chopping_pima<br>avg_chopping pima"]):::outdated
    xc7806e6395dc77f0(["pima"]):::uptodate --> x1fff5af5ac13d38c(["summary_avg_chopping_pima<br>avg_chopping pima"]):::outdated
    xaf6d6b4b557c99d9(["agb_xu"]):::outdated --> x2267885cec56d4ae(["summary_agb_xu_grazing<br>agb_xu grazing"]):::outdated
    xf59a011d97d6f12a(["grazing"]):::uptodate --> x2267885cec56d4ae(["summary_agb_xu_grazing<br>agb_xu grazing"]):::outdated
    xd175b91b13bd123d(["az"]):::uptodate --> x71256fe0be643989(["plot_slope_xu<br>slope_xu"]):::outdated
    xd0a9a1247a9acf3a(["slope_xu"]):::outdated --> x71256fe0be643989(["plot_slope_xu<br>slope_xu"]):::outdated
    x92d8eb7a1c6e0d45(["slope_ltgnn<br>recombine tiles"]):::outdated --> xcc67952bbe5e9006(["summary_slope_ltgnn_wilderness<br>slope_ltgnn wilderness"]):::outdated
    x1e70594f4ceaaf92(["wilderness"]):::uptodate --> xcc67952bbe5e9006(["summary_slope_ltgnn_wilderness<br>slope_ltgnn wilderness"]):::outdated
    xaf6d6b4b557c99d9(["agb_xu"]):::outdated --> xd0a9a1247a9acf3a(["slope_xu"]):::outdated
    xd175b91b13bd123d(["az"]):::uptodate --> xb372d528e437a0b6(["summary_slope_xu_az<br>slope_xu az"]):::outdated
    xd0a9a1247a9acf3a(["slope_xu"]):::outdated --> xb372d528e437a0b6(["summary_slope_xu_az<br>slope_xu az"]):::outdated
    x54bfa6a29dc559f0(["summary_slope_plot"]):::outdated --> x3aebfd756df36a1b(["summary_slope_plot_png"]):::outdated
    xd175b91b13bd123d(["az"]):::uptodate --> xf701d65879a8f737(["plot_slope_liu<br>slope_liu"]):::outdated
    x2f277a2639a2f721(["slope_liu"]):::outdated --> xf701d65879a8f737(["plot_slope_liu<br>slope_liu"]):::outdated
    xc7806e6395dc77f0(["pima"]):::uptodate --> x63ddbeccd0d557ce(["summary_slope_chopping_pima<br>slope_chopping pima"]):::outdated
    xe119d220d3903100(["slope_chopping<br>recombine tiles"]):::outdated --> x63ddbeccd0d557ce(["summary_slope_chopping_pima<br>slope_chopping pima"]):::outdated
    x362c73969e11896c(["avg_menlove"]):::outdated --> x4d93207ec1c13dd9(["summary_avg_menlove_az<br>avg_menlove az"]):::outdated
    xd175b91b13bd123d(["az"]):::uptodate --> x4d93207ec1c13dd9(["summary_avg_menlove_az<br>avg_menlove az"]):::outdated
    xd175b91b13bd123d(["az"]):::uptodate --> x8d84a39ead4d60f2(["summary_slope_ltgnn_az<br>slope_ltgnn az"]):::outdated
    x92d8eb7a1c6e0d45(["slope_ltgnn<br>recombine tiles"]):::outdated --> x8d84a39ead4d60f2(["summary_slope_ltgnn_az<br>slope_ltgnn az"]):::outdated
    xbc19a0d6018eaa1c(["agb_liu"]):::outdated --> xa9ce1b2a787b22a8(["summary_agb_liu_forest<br>agb_liu forest"]):::outdated
    xbc0c37938a8a7f23(["forest"]):::uptodate --> xa9ce1b2a787b22a8(["summary_agb_liu_forest<br>agb_liu forest"]):::outdated
    xc7806e6395dc77f0(["pima"]):::uptodate --> x28f558d535ac8cf2(["summary_slope_xu_pima<br>slope_xu pima"]):::outdated
    xd0a9a1247a9acf3a(["slope_xu"]):::outdated --> x28f558d535ac8cf2(["summary_slope_xu_pima<br>slope_xu pima"]):::outdated
    xbc0c37938a8a7f23(["forest"]):::uptodate --> x43019e7527698ff0(["summary_slope_liu_forest<br>slope_liu forest"]):::outdated
    x2f277a2639a2f721(["slope_liu"]):::outdated --> x43019e7527698ff0(["summary_slope_liu_forest<br>slope_liu forest"]):::outdated
    xd175b91b13bd123d(["az"]):::uptodate --> x77cbe3d593cb2d43(["agb_chopping"]):::outdated
    x57fed634f20ed860(["file_chopping"]):::outdated --> x77cbe3d593cb2d43(["agb_chopping"]):::outdated
    xf59a011d97d6f12a(["grazing"]):::uptodate --> xfd5767961ec332dc(["summary_slope_liu_grazing<br>slope_liu grazing"]):::outdated
    x2f277a2639a2f721(["slope_liu"]):::outdated --> xfd5767961ec332dc(["summary_slope_liu_grazing<br>slope_liu grazing"]):::outdated
    xe0e11eeaeac92a26(["avg_esa"]):::outdated --> xf48ae011e191afa2(["summary_avg_esa_grazing<br>avg_esa grazing"]):::outdated
    xf59a011d97d6f12a(["grazing"]):::uptodate --> xf48ae011e191afa2(["summary_avg_esa_grazing<br>avg_esa grazing"]):::outdated
    x77cbe3d593cb2d43(["agb_chopping"]):::outdated --> x2845c5058e9f8aef(["avg_chopping"]):::outdated
    xd175b91b13bd123d(["az"]):::uptodate --> xaa9bafe13d69d264(["plot_slope_ltgnn<br>slope_ltgnn"]):::outdated
    x92d8eb7a1c6e0d45(["slope_ltgnn<br>recombine tiles"]):::outdated --> xaa9bafe13d69d264(["plot_slope_ltgnn<br>slope_ltgnn"]):::outdated
    xd175b91b13bd123d(["az"]):::uptodate --> xff5e2469295493cf(["agb_esa"]):::outdated
    x1b3e7f5b8dde540f(["dir_esa"]):::dispatched --> xff5e2469295493cf(["agb_esa"]):::outdated
    x7e6fa45e50ec29d0(["slope_esa<br>recombine tiles"]):::outdated --> xea771a04c84d81ce(["summary_slope_esa_wilderness<br>slope_esa wilderness"]):::outdated
    x1e70594f4ceaaf92(["wilderness"]):::uptodate --> xea771a04c84d81ce(["summary_slope_esa_wilderness<br>slope_esa wilderness"]):::outdated
    xd175b91b13bd123d(["az"]):::uptodate --> xb057c3287f92b5b6(["plot_slope_esa<br>slope_esa"]):::outdated
    x7e6fa45e50ec29d0(["slope_esa<br>recombine tiles"]):::outdated --> xb057c3287f92b5b6(["plot_slope_esa<br>slope_esa"]):::outdated
    x2845c5058e9f8aef(["avg_chopping"]):::outdated --> x176ce95398af7666(["summary_avg_chopping_wilderness<br>avg_chopping wilderness"]):::outdated
    x1e70594f4ceaaf92(["wilderness"]):::uptodate --> x176ce95398af7666(["summary_avg_chopping_wilderness<br>avg_chopping wilderness"]):::outdated
    x77cbe3d593cb2d43(["agb_chopping"]):::outdated --> x7b57db8ba3446924(["summary_agb_chopping_wilderness<br>agb_chopping wilderness"]):::outdated
    x1e70594f4ceaaf92(["wilderness"]):::uptodate --> x7b57db8ba3446924(["summary_agb_chopping_wilderness<br>agb_chopping wilderness"]):::outdated
    xbc19a0d6018eaa1c(["agb_liu"]):::outdated --> x2f277a2639a2f721(["slope_liu"]):::outdated
    xaf6d6b4b557c99d9(["agb_xu"]):::outdated --> x6422972db09e9220(["summary_agb_xu_az<br>agb_xu az"]):::outdated
    xd175b91b13bd123d(["az"]):::uptodate --> x6422972db09e9220(["summary_agb_xu_az<br>agb_xu az"]):::outdated
    x1c41c311396266df(["summary_slope"]):::outdated --> x54bfa6a29dc559f0(["summary_slope_plot"]):::outdated
    xce7164452e083ea7(["avg_ltgnn"]):::outdated --> x4e04c2eb1f920d66(["map_avg_ltgnn<br>avg_ltgnn"]):::outdated
    xd175b91b13bd123d(["az"]):::uptodate --> x4e04c2eb1f920d66(["map_avg_ltgnn<br>avg_ltgnn"]):::outdated
    x581136bf2fbd250d["tiles_slope_chopping"]:::outdated --> xe119d220d3903100(["slope_chopping<br>recombine tiles"]):::outdated
    xcefaa4368249c2e2(["summary_yearly"]):::outdated --> xccca8b6f540da46a(["summary_yearly_csv"]):::outdated
    xaf6d6b4b557c99d9(["agb_xu"]):::outdated --> x19a45f62170cc130(["summary_agb_xu_wilderness<br>agb_xu wilderness"]):::outdated
    x1e70594f4ceaaf92(["wilderness"]):::uptodate --> x19a45f62170cc130(["summary_agb_xu_wilderness<br>agb_xu wilderness"]):::outdated
    xff5e2469295493cf(["agb_esa"]):::outdated --> xe0e11eeaeac92a26(["avg_esa"]):::outdated
    xbc19a0d6018eaa1c(["agb_liu"]):::outdated --> xd6ffb188ca311cf2(["summary_agb_liu_wilderness<br>agb_liu wilderness"]):::outdated
    x1e70594f4ceaaf92(["wilderness"]):::uptodate --> xd6ffb188ca311cf2(["summary_agb_liu_wilderness<br>agb_liu wilderness"]):::outdated
    x9ab15d934f656154(["summary_agb_chopping_az<br>agb_chopping az"]):::outdated --> xcefaa4368249c2e2(["summary_yearly"]):::outdated
    xf2e4ec3dfa0e7f01(["summary_agb_chopping_forest<br>agb_chopping forest"]):::outdated --> xcefaa4368249c2e2(["summary_yearly"]):::outdated
    xd4df5df11594a110(["summary_agb_chopping_grazing<br>agb_chopping grazing"]):::outdated --> xcefaa4368249c2e2(["summary_yearly"]):::outdated
    xb58c02e87241a3fd(["summary_agb_chopping_pima<br>agb_chopping pima"]):::outdated --> xcefaa4368249c2e2(["summary_yearly"]):::outdated
    x7b57db8ba3446924(["summary_agb_chopping_wilderness<br>agb_chopping wilderness"]):::outdated --> xcefaa4368249c2e2(["summary_yearly"]):::outdated
    x41cc2ed88a4a4959(["summary_agb_esa_az<br>agb_esa az"]):::outdated --> xcefaa4368249c2e2(["summary_yearly"]):::outdated
    xf2b9e89639ff381c(["summary_agb_esa_forest<br>agb_esa forest"]):::outdated --> xcefaa4368249c2e2(["summary_yearly"]):::outdated
    x8e8e19dd383ef894(["summary_agb_esa_grazing<br>agb_esa grazing"]):::outdated --> xcefaa4368249c2e2(["summary_yearly"]):::outdated
    xf35ce321bdfd9069(["summary_agb_esa_pima<br>agb_esa pima"]):::outdated --> xcefaa4368249c2e2(["summary_yearly"]):::outdated
    x58dd2247fb268089(["summary_agb_esa_wilderness<br>agb_esa wilderness"]):::outdated --> xcefaa4368249c2e2(["summary_yearly"]):::outdated
    x6ae84e09c72ffab7(["summary_agb_liu_az<br>agb_liu az"]):::outdated --> xcefaa4368249c2e2(["summary_yearly"]):::outdated
    xa9ce1b2a787b22a8(["summary_agb_liu_forest<br>agb_liu forest"]):::outdated --> xcefaa4368249c2e2(["summary_yearly"]):::outdated
    x58112906d882e0ac(["summary_agb_liu_grazing<br>agb_liu grazing"]):::outdated --> xcefaa4368249c2e2(["summary_yearly"]):::outdated
    x9fab6ebe20055bc7(["summary_agb_liu_pima<br>agb_liu pima"]):::outdated --> xcefaa4368249c2e2(["summary_yearly"]):::outdated
    xd6ffb188ca311cf2(["summary_agb_liu_wilderness<br>agb_liu wilderness"]):::outdated --> xcefaa4368249c2e2(["summary_yearly"]):::outdated
    x813b2d9782d4739d(["summary_agb_ltgnn_az<br>agb_ltgnn az"]):::outdated --> xcefaa4368249c2e2(["summary_yearly"]):::outdated
    x3f566b4f9e187e71(["summary_agb_ltgnn_forest<br>agb_ltgnn forest"]):::outdated --> xcefaa4368249c2e2(["summary_yearly"]):::outdated
    xa2b9a2a0e58773ca(["summary_agb_ltgnn_grazing<br>agb_ltgnn grazing"]):::outdated --> xcefaa4368249c2e2(["summary_yearly"]):::outdated
    xa453d5fba81aa0a1(["summary_agb_ltgnn_pima<br>agb_ltgnn pima"]):::outdated --> xcefaa4368249c2e2(["summary_yearly"]):::outdated
    xaae2459862dab5f1(["summary_agb_ltgnn_wilderness<br>agb_ltgnn wilderness"]):::outdated --> xcefaa4368249c2e2(["summary_yearly"]):::outdated
    x6422972db09e9220(["summary_agb_xu_az<br>agb_xu az"]):::outdated --> xcefaa4368249c2e2(["summary_yearly"]):::outdated
    x12a08ae91d7b3a08(["summary_agb_xu_forest<br>agb_xu forest"]):::outdated --> xcefaa4368249c2e2(["summary_yearly"]):::outdated
    x2267885cec56d4ae(["summary_agb_xu_grazing<br>agb_xu grazing"]):::outdated --> xcefaa4368249c2e2(["summary_yearly"]):::outdated
    x791138c276dc3e66(["summary_agb_xu_pima<br>agb_xu pima"]):::outdated --> xcefaa4368249c2e2(["summary_yearly"]):::outdated
    x19a45f62170cc130(["summary_agb_xu_wilderness<br>agb_xu wilderness"]):::outdated --> xcefaa4368249c2e2(["summary_yearly"]):::outdated
    xf59a011d97d6f12a(["grazing"]):::uptodate --> x4da065287d8173ab(["summary_slope_xu_grazing<br>slope_xu grazing"]):::outdated
    xd0a9a1247a9acf3a(["slope_xu"]):::outdated --> x4da065287d8173ab(["summary_slope_xu_grazing<br>slope_xu grazing"]):::outdated
    xd37fc9b64825c560(["avg_liu"]):::outdated --> x87db7fb0eeceb7b6(["summary_avg_liu_forest<br>avg_liu forest"]):::outdated
    xbc0c37938a8a7f23(["forest"]):::uptodate --> x87db7fb0eeceb7b6(["summary_avg_liu_forest<br>avg_liu forest"]):::outdated
    x2173e4c903ac22de(["agb_ltgnn"]):::outdated --> x3f566b4f9e187e71(["summary_agb_ltgnn_forest<br>agb_ltgnn forest"]):::outdated
    xbc0c37938a8a7f23(["forest"]):::uptodate --> x3f566b4f9e187e71(["summary_agb_ltgnn_forest<br>agb_ltgnn forest"]):::outdated
    x9a2ca8b45e66f5bb["tiles_agb_esa"]:::outdated --> xe6a12927573470a4["tiles_slope_esa"]:::outdated
    x1c41c311396266df(["summary_slope"]):::outdated --> xb34478bb102a7efb(["summary_slope_csv"]):::outdated
    xc7806e6395dc77f0(["pima"]):::uptodate --> x584108227a8877b2(["summary_slope_ltgnn_pima<br>slope_ltgnn pima"]):::outdated
    x92d8eb7a1c6e0d45(["slope_ltgnn<br>recombine tiles"]):::outdated --> x584108227a8877b2(["summary_slope_ltgnn_pima<br>slope_ltgnn pima"]):::outdated
    xc7806e6395dc77f0(["pima"]):::uptodate --> x40d6f95217c56731(["summary_slope_liu_pima<br>slope_liu pima"]):::outdated
    x2f277a2639a2f721(["slope_liu"]):::outdated --> x40d6f95217c56731(["summary_slope_liu_pima<br>slope_liu pima"]):::outdated
    xd175b91b13bd123d(["az"]):::uptodate --> x1e70594f4ceaaf92(["wilderness"]):::uptodate
    xde7dcd102c91a534(["file_wilderness"]):::uptodate --> x1e70594f4ceaaf92(["wilderness"]):::uptodate
    xd175b91b13bd123d(["az"]):::uptodate --> xe9e3637e70732128(["plot_slope_chopping<br>slope_chopping"]):::outdated
    xe119d220d3903100(["slope_chopping<br>recombine tiles"]):::outdated --> xe9e3637e70732128(["plot_slope_chopping<br>slope_chopping"]):::outdated
    xaf6d6b4b557c99d9(["agb_xu"]):::outdated --> x791138c276dc3e66(["summary_agb_xu_pima<br>agb_xu pima"]):::outdated
    xc7806e6395dc77f0(["pima"]):::uptodate --> x791138c276dc3e66(["summary_agb_xu_pima<br>agb_xu pima"]):::outdated
    xff5e2469295493cf(["agb_esa"]):::outdated --> xf2b9e89639ff381c(["summary_agb_esa_forest<br>agb_esa forest"]):::outdated
    xbc0c37938a8a7f23(["forest"]):::uptodate --> xf2b9e89639ff381c(["summary_agb_esa_forest<br>agb_esa forest"]):::outdated
    xd175b91b13bd123d(["az"]):::uptodate --> xbc19a0d6018eaa1c(["agb_liu"]):::outdated
    xc44a9baead45da39(["file_liu"]):::outdated --> xbc19a0d6018eaa1c(["agb_liu"]):::outdated
    xff5e2469295493cf(["agb_esa"]):::outdated --> x9a2ca8b45e66f5bb["tiles_agb_esa"]:::outdated
    x20d1ac09aae31387(["tiles_agb_esa_exts"]):::outdated --> x9a2ca8b45e66f5bb["tiles_agb_esa"]:::outdated
    xbc19a0d6018eaa1c(["agb_liu"]):::outdated --> x9fab6ebe20055bc7(["summary_agb_liu_pima<br>agb_liu pima"]):::outdated
    xc7806e6395dc77f0(["pima"]):::uptodate --> x9fab6ebe20055bc7(["summary_agb_liu_pima<br>agb_liu pima"]):::outdated
    x2845c5058e9f8aef(["avg_chopping"]):::outdated --> x6745d86a7cabf031(["summary_avg_chopping_grazing<br>avg_chopping grazing"]):::outdated
    xf59a011d97d6f12a(["grazing"]):::uptodate --> x6745d86a7cabf031(["summary_avg_chopping_grazing<br>avg_chopping grazing"]):::outdated
    x2845c5058e9f8aef(["avg_chopping"]):::outdated --> x6ed505d5d5b3b6d9(["summary_avg_chopping_forest<br>avg_chopping forest"]):::outdated
    xbc0c37938a8a7f23(["forest"]):::uptodate --> x6ed505d5d5b3b6d9(["summary_avg_chopping_forest<br>avg_chopping forest"]):::outdated
    x2f277a2639a2f721(["slope_liu"]):::outdated --> xc273acc4788a090a(["summary_slope_liu_wilderness<br>slope_liu wilderness"]):::outdated
    x1e70594f4ceaaf92(["wilderness"]):::uptodate --> xc273acc4788a090a(["summary_slope_liu_wilderness<br>slope_liu wilderness"]):::outdated
    xe09b277f2cce7c36(["avg_gedi"]):::outdated --> xf146ed3a9957b8ff(["summary_avg_gedi_wilderness<br>avg_gedi wilderness"]):::outdated
    x1e70594f4ceaaf92(["wilderness"]):::uptodate --> xf146ed3a9957b8ff(["summary_avg_gedi_wilderness<br>avg_gedi wilderness"]):::outdated
    xc11069275cfeb620(["readme"]):::dispatched --> xc11069275cfeb620(["readme"]):::dispatched
  end
  classDef uptodate stroke:#000000,color:#ffffff,fill:#354823;
  classDef outdated stroke:#000000,color:#000000,fill:#78B7C5;
  classDef dispatched stroke:#000000,color:#000000,fill:#DC863B;
  classDef none stroke:#000000,color:#000000,fill:#94a4ac;
  linkStyle 0 stroke-width:0px;
  linkStyle 1 stroke-width:0px;
  linkStyle 2 stroke-width:0px;
  linkStyle 3 stroke-width:0px;
  linkStyle 332 stroke-width:0px;
```

Two packages that extend `targets` are used as well: `tarchetypes` and
`geotargets`. [`geotargets`](https://njtierney.github.io/geotargets/) is
under development by Eric Scott and Nick Tierney and allows `targets` to
work with `SpatRaster` objects created by `terra::rast()`.

Some of the steps require quite a lot of RAM, in particular those
involving the LT-GNN dataset. I’ve gotten this workflow to run on a
[Jetstream2/Exosphere](https://jetstream-cloud.org/index.html) instance
with 60GB of RAM, but I’m not exactly sure what the requirements are. If
you’d like to run this locally, I’d recommend modifying `_targets.R` to
remove steps involving the higher resolution data products like LT-GNN.

## Files

Files related to `renv`:

- `_targets_packages.R` is generated by `targets::tar_renv()` to make it
  easier for `renv` to discover dependencies used in the targets
  pipeline. Do not edit by hand.

- `.renvignore` tells `renv` which files **not** to scan when
  discovering dependencies

- `.Rprofile` allows `renv` to bootstrap itself when the project is
  opened. Do not edit by hand.

- `renv/` contains the local package library and other things that
  should not be edited by hand

- `renv.lock` is the JSON file containing information on this project’s
  dependencies. Should not be edited by hand.

Files related to `targets`:

- `_targets/` is the target store and should not be edited by hand.

- `_targets.R` defines the targets pipeline including options and what
  steps are run.

- `R/` contains functions that are sourced (loaded) when the targets
  pipeline is run. This is where you’ll find all the “custom” functions
  used in `_targets.R`

- `tiles/` and the files in it are created by the “tiles” target defined
  in `_targets.R`.

Other files:

- `data/` is where the input data products live. I’ve copied this from
  snow, but it is *possible* to use files on snow directly, although it
  is slower to run the pipeline. See comments in `_targets.R`

- `docs/` is a special folder in that any html file in it will be
  published to GitHub pages.

- `notes/` currently just contains some notes on how to modify this
  project to run on the HPC.

- `output/` used to save output from targets pipeline when
  `format = "file"`
