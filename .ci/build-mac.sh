#!/bin/sh -ex

# brew update
# brew install llvm@13 sdl2 nasm qt@5 ninja cmake glew git p7zip create-dmg ccache

export MACOSX_DEPLOYMENT_TARGET=11.6
export CXX=clang++
export CC=clang
# export Qt5_DIR="/usr/local/opt/qt@5/lib/cmake/Qt5"
# export PATH="/usr/local/opt/llvm@13/bin:/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/Library/Apple/usr/bin"
# export LDFLAGS="-L/usr/local/opt/llvm@13/lib -Wl,-rpath,/usr/local/opt/llvm@13/lib"
# export CPPFLAGS="-I/usr/local/opt/llvm@13/include -msse -msse2 -mcx16 -no-pie"

export Qt5_DIR="/opt/homebrew/opt/qt@5"

# export PATH="/opt/homebrew/opt/llvm@15/bin:/opt/homebrew/bin:/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/Library/Apple/usr/bin"
# export LDFLAGS="-L/opt/homebrew/opt/llvm/lib/c++ -Wl,-rpath,/opt/homebrew/opt/llvm/lib/c++ -L/opt/homebrew/opt/zlib/lib -L/opt/homebrew/opt/z3/lib"
# export CPPFLAGS="-I/opt/homebrew/opt/llvm/include -msse -msse2 -mcx16 -no-pie -I/opt/homebrew/opt/zlib/include -I/opt/homebrew/opt/z3/include"

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/Library/Apple/usr/bin"
export LDFLAGS=""
export CPPFLAGS="-msse -msse2 -mcx16 -no-pie"

clang++ --version
# git submodule update --init --recursive --depth 1

# 3rdparty fixes
sed -i '' "s/extern const double NSAppKitVersionNumber;/const double NSAppKitVersionNumber = 1343;/g" 3rdparty/hidapi/hidapi/mac/hid.c

[ -d build ] || mkdir build
cd build || exit 1

cmake .. \
    -DUSE_DISCORD_RPC=OFF -DUSE_VULKAN=ON -DUSE_ALSA=OFF -DUSE_PULSE=OFF -DUSE_AUDIOUNIT=ON \
    -DLLVM_CCACHE_BUILD=OFF -DLLVM_TARGETS_TO_BUILD="AArch64;X86" -DLLVM_BUILD_RUNTIME=OFF -DLLVM_BUILD_TOOLS=OFF \
    -DLLVM_INCLUDE_DOCS=OFF -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_INCLUDE_TESTS=OFF -DLLVM_INCLUDE_TOOLS=OFF \
    -DLLVM_INCLUDE_UTILS=OFF -DLLVM_USE_PERF=OFF -DLLVM_ENABLE_Z3_SOLVER=OFF \
    -DUSE_NATIVE_INSTRUCTIONS=OFF \
    -DUSE_SYSTEM_MVK=OFF \
    -DUSE_SYSTEM_FFMPEG=ON \
    -G Ninja

ninja; build_status=$?;

echo $build_status

# cd ..

# {   [ "$CI_HAS_ARTIFACTS" = "true" ];
# } && SHOULD_DEPLOY="true" || SHOULD_DEPLOY="false"

# if [ "$build_status" -eq 0 ] && [ "$SHOULD_DEPLOY" = "true" ]; then
#     .ci/deploy-mac.sh
# fi
