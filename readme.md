[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip) [![](https://img.shields.io/badge/Shiny-shinyapps.io-blue?style=flat&labelColor=white&logo=RStudio&logoColor=blue)](https://n2o2b1-enzimatik.shinyapps.io/openmelt/)

## openMELT

openMELT is app written in R Shiny for analysing data from High Resolution Melting (HRM) experiments. openMELT aims to enable HRM accessible for everyone, as most of HRM analysis tool is paid and proprietary software. openMELT is reimplementation and improvement of liuyigh's [PyHRM](https://github.com/liuyigh/PyHRM) (python language) in R language. OpenMELT integrate clustering analysis with K-means into diffrence graph for easier analysis.

## Instrument support

- [x] Bio-Rad CFX series (stable)
- [ ] Applied Biosystem 7500 series (on going)
- [ ] Healforce X 960 (on going)

## How to Use

1. Upload HRM data in csv format
2. Set analysis parameter (temperature, reference sample)

## To Do

- [ ] instrument, temperature, refrence input
- [ ] tab-bed look
- [ ] sample selector
- [ ] meta integration
- [ ] plot_ly or ggplot?
- [ ] sample file