#!/bin/sh

# Updated FEB 25 2019:
# Notes on usage:
# The script has been updated to no longer require CUDA 4.2. Any version of CUDA should work. 
# You must manually set NVIDIA_COMPUTE_SDK_LOCATION and CUDA_INSTALL_PATH before running this script
# for it to function correctly. They should point to the location of the SDK samples the and toolkit, 
# respectively. Both can be downloaded from NVIDIA's website if you do not have them.

export GPGPUSIM_BENCHMARKS_SETUP_ENVIRONMENT_WAS_RUN=
export GPGPUSIM_BENCH_ROOT="$( cd "$( dirname "$BASH_SOURCE" )" && pwd )"

#if [ ! -d $NVIDIA_COMPUTE_SDK_LOCATION/../4.2 ]; then
#    echo "SDK 4.2 Not detected - installing and building"
#    if [ ! -f ./gpucomputingsdk_4.2.9_linux.run ]; then
#        wget http://developer.download.nvidia.com/compute/cuda/4_2/rel/sdk/gpucomputingsdk_4.2.9_linux.run
#    fi
#    chmod u+x gpucomputingsdk_4.2.9_linux.run
#    ./gpucomputingsdk_4.2.9_linux.run -- --prefix=`pwd`/4.2 --cudaprefix=$CUDA_INSTALL_PATH
#    export NVIDIA_COMPUTE_SDK_LOCATION=`pwd`/4.2
#    make -j -i -C $NVIDIA_COMPUTE_SDK_LOCATION/
#fi

if [ ! -n "$NVIDIA_COMPUTE_SDK_LOCATION" ]; then
    echo "ERROR *** NVIDIA_COMPUTE_SDK_LOCATION not set;"
    return
elif [ ! -d "$NVIDIA_COMPUTE_SDK_LOCATION" ]; then
    echo "ERROR *** NVIDIA_COMPUTE_SDK_LOCATION=$NVIDIA_COMPUTE_SDK_LOCATION invalid. directory does not exist.";
    return
fi

if [ ! -n "$CUDA_INSTALL_PATH" ]; then
    echo "ERROR *** CUDA_INSTALL_PATH not set;"
    return
elif [ ! -d "$CUDA_INSTALL_PATH" ]; then
    echo "ERROR *** CUDA_INSTALL_PATH=$CUDA_INSTALL_PATH invalid. directory does not exist.";
    return
else 
    NVCC_PATH=`which nvcc`;
    if [ $? != 0 ]; then
        echo "";
        echo "ERROR ** nvcc (from CUDA Toolkit) was not found in PATH but required to build the ISPASS 2009 benchmarks.";
        echo "         Try adding $(CUDA_INSTALL_PATH)/bin/ to your PATH environment variable.";
        echo "         Please also be sure to read README.ISPASS-2009 if you have not done so.";
        echo "";
        return
    fi
fi

export CUDA_VERSION=`nvcc --version | grep release | sed -re 's/.*release ([0-9]+\.[0-9]+).*/\1/'`;
export CUDA_VERSION_MAJOR=`nvcc --version | grep release | sed -re 's/.*release ([0-9]+)\..*/\1/'`;
export CUDAHOME=$CUDA_INSTALL_PATH

export BINDIR=$GPGPUSIM_BENCH_ROOT/../bin/$CUDA_VERSION
export BINSUBDIR=release

export SETENV="export BINDIR=$BINDIR; export BINSUBDIR=$BINSUBDIR; export ROOTOBJDIR=obj_$CUDA_VERSION;"
echo BINDIR=$BINDIR

export MAKE_ARGS=""
export CUDA_CPPFLAGS=""
export NVCC_ADDITIONAL_ARGS=""

if [ $CUDA_VERSION_MAJOR -eq 4 ]; then
    export CUDA_CPPFLAGS="$CUDA_CPPFLAGS -gencode=arch=compute_10,code=compute_10"
    export CUDA_CPPFLAGS="$CUDA_CPPFLAGS -gencode=arch=compute_13,code=compute_13"
    export CUDA_CPPFLAGS="$CUDA_CPPFLAGS -gencode=arch=compute_20,code=compute_20"
    export CUDA_CPPFLAGS="$CUDA_CPPFLAGS -gencode=arch=compute_30,code=compute_30"
fi
if [ $CUDA_VERSION_MAJOR -eq 5 ]; then
    export CUDA_CPPFLAGS="$CUDA_CPPFLAGS -gencode=arch=compute_10,code=compute_10"
    export CUDA_CPPFLAGS="$CUDA_CPPFLAGS -gencode=arch=compute_13,code=compute_13"
    export CUDA_CPPFLAGS="$CUDA_CPPFLAGS -gencode=arch=compute_20,code=compute_20"
    export CUDA_CPPFLAGS="$CUDA_CPPFLAGS -gencode=arch=compute_30,code=compute_30"
    export CUDA_CPPFLAGS="$CUDA_CPPFLAGS -gencode=arch=compute_35,code=compute_35"
fi
if [ $CUDA_VERSION_MAJOR -eq 6 ]; then
    export CUDA_CPPFLAGS="$CUDA_CPPFLAGS -gencode=arch=compute_10,code=compute_10"
    export CUDA_CPPFLAGS="$CUDA_CPPFLAGS -gencode=arch=compute_13,code=compute_13"
    export CUDA_CPPFLAGS="$CUDA_CPPFLAGS -gencode=arch=compute_20,code=compute_20"
    export CUDA_CPPFLAGS="$CUDA_CPPFLAGS -gencode=arch=compute_30,code=compute_30"
    export CUDA_CPPFLAGS="$CUDA_CPPFLAGS -gencode=arch=compute_35,code=compute_35"
fi
if [ $CUDA_VERSION_MAJOR -eq 7 ]; then
    export CUDA_CPPFLAGS="$CUDA_CPPFLAGS -gencode=arch=compute_20,code=compute_20"
    export CUDA_CPPFLAGS="$CUDA_CPPFLAGS -gencode=arch=compute_30,code=compute_30"
    export CUDA_CPPFLAGS="$CUDA_CPPFLAGS -gencode=arch=compute_35,code=compute_35"
    export CUDA_CPPFLAGS="$CUDA_CPPFLAGS -gencode=arch=compute_50,code=compute_50"
fi
if [ $CUDA_VERSION_MAJOR -eq 8 ]; then
    export CUDA_CPPFLAGS="$CUDA_CPPFLAGS -gencode=arch=compute_20,code=compute_20"
    export CUDA_CPPFLAGS="$CUDA_CPPFLAGS -gencode=arch=compute_30,code=compute_30"
    export CUDA_CPPFLAGS="$CUDA_CPPFLAGS -gencode=arch=compute_35,code=compute_35"
    export CUDA_CPPFLAGS="$CUDA_CPPFLAGS -gencode=arch=compute_50,code=compute_50"
    export CUDA_CPPFLAGS="$CUDA_CPPFLAGS -gencode=arch=compute_60,code=compute_60"
    export CUDA_CPPFLAGS="$CUDA_CPPFLAGS -gencode=arch=compute_62,code=compute_62"
fi
if [ $CUDA_VERSION_MAJOR -eq 9 ]; then
    export CUDA_CPPFLAGS="$CUDA_CPPFLAGS -gencode=arch=compute_30,code=compute_30"
    export CUDA_CPPFLAGS="$CUDA_CPPFLAGS -gencode=arch=compute_35,code=compute_35"
    export CUDA_CPPFLAGS="$CUDA_CPPFLAGS -gencode=arch=compute_50,code=compute_50"
    export CUDA_CPPFLAGS="$CUDA_CPPFLAGS -gencode=arch=compute_60,code=compute_60"
    export CUDA_CPPFLAGS="$CUDA_CPPFLAGS -gencode=arch=compute_62,code=compute_62"
    export CUDA_CPPFLAGS="$CUDA_CPPFLAGS -gencode=arch=compute_70,code=compute_70"
fi


# Turn off the gencodes for cuda versions. Above 6 - no 10 support.
# Depending on new the cuda version is, then different SMs are supported
if [ $CUDA_VERSION_MAJOR -gt 4 ]; then
    export CUDA_GT_4=1
fi

if [ $CUDA_VERSION_MAJOR -gt 6 ]; then
    export MAKE_ARGS="$MAKE_ARGS GENCODE_SM10="
    export MAKE_ARGS="$MAKE_ARGS GENCODE_SM13="
fi

if [ $CUDA_VERSION_MAJOR -gt 7 ]; then
    export NVCC_ADDITIONAL_ARGS="--cudart shared"
    export MAKE_ARGS="$MAKE_ARGS GENCODE_SM20="
fi

if [ $CUDA_VERSION_MAJOR -lt 5 ]; then
    export MAKE_ARGS="$MAKE_ARGS GENCODE_SM35="
    export MAKE_ARGS="$MAKE_ARGS GENCODE_SM50="
    export MAKE_ARGS="$MAKE_ARGS GENCODE_SM60="
    export MAKE_ARGS="$MAKE_ARGS GENCODE_SM62="
fi


if [ $CUDA_VERSION_MAJOR -lt 7 ]; then
    export MAKE_ARGS="$MAKE_ARGS GENCODE_SM50="
    export MAKE_ARGS="$MAKE_ARGS GENCODE_SM60="
    export MAKE_ARGS="$MAKE_ARGS GENCODE_SM62="
fi

if [ $CUDA_VERSION_MAJOR -lt 8 ]; then
    export MAKE_ARGS="$MAKE_ARGS GENCODE_SM60="
    export MAKE_ARGS="$MAKE_ARGS GENCODE_SM62="
fi

# 20 Deprecated in 9+
if [ $CUDA_VERSION_MAJOR -gt 8 ]; then
    export MAKE_ARGS="$MAKE_ARGS GENCODE_SM20="
fi

export CUDA_CPPFLAGS="$CUDA_CPPFLAGS $NVCC_ADDITIONAL_ARGS"
echo MAKE_ARGS=$MAKE_ARGS

export GPGPUSIM_BENCHMARKS_SETUP_ENVIRONMENT_WAS_RUN=1