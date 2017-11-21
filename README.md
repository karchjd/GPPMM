# GPPMM
Implementation of Gaussian Process Panel Modeling in Matlab

# Note

While all major functionality is available, this package is still in a rather early stage. For example, documentation is still incomplete and the package will soon undergo major API changes. Its current purpose is mainly to enable reachers familiar with Matlab to experiment with Gaussian Process Panel Modeling. 

The recommended approach to learn about the functionality of the package is currently to closely follow the examples provided. This is described in the following.


# Installation

## Prerequisites

GPML (http://www.gaussianprocess.org/gpml/code/matlab/doc/) needs to be installed first. Instead of the current version, version 3.6 is required. The direct links to the archives are

http://gaussianprocess.org/gpml/code/matlab/release/gpml-matlab-v3.6-2015-07-07.tar.gz

or

http://gaussianprocess.org/gpml/code/matlab/release/gpml-matlab-v3.6-2015-07-07.zip.

For installation, follow the instructions [here](http://www.gaussianprocess.org/gpml/code/matlab/doc/).

## Installation

Download all files (for example, by clicking [here](https://github.com/karchjd/GPPMM/archive/master.zip) and make sure that the [main](main/) folder including all its subfolders is included in you Matlab path. This can be achived running

```matlab
>> addpath(genpath('main/'))
```

from within the base folder.

# Example

The example in [examples/demoGPPM.m](examples/demoGPPM.m) demonstrates all major functions and how they are typically used.
