# Typescript Integration Project
 - [Typescript Implementation Plan](https://docs.google.com/document/d/18VDaM21yDwct6vbgF5Kjr5SNw6bX_F4DrsVrVJwFpS0/edit)
 - [Notes from Eric/Akshata Meeting](https://docs.google.com/document/d/1LUkty-6GC5SD3_Brp5xYZU6GbEKxJ9xSLt9heKhE2Ow/edit), June 1
 - [Pull Request for integrating TS support into babel config](https://github.com/QuorumUS/quorum-site/pull/25867)

## Progress on 7/8
Updated `feature/tsc-3` to not have global react and global react-dom import trick. Basic gist is downgrading npm to `6.14.13` (unfortunate but oh well). Now having problem with `react-datepicker` appearantly just not working. I don't think this actually matters since `ff_search_design` is enabled for all, and that disabled everything.

Probably the best steps going forward are either (1) get react-datepicker working or (2) drop support for the non-`ff_search_design` which will require changing a lot of other tests.

During Eric/Frank, it was discussed that I would get a couple days to finish up phase 1.

Next Steps:
 - Talk to Kristin about getting a ticket out to log work on phase 1