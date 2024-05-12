# Making my first proper nixpkg

THIS GUIDE IS NOT COMPLETE, PLUS IT'S JUST RANDOM RAMBLINGS WHILE I TESTED
STUFF.

I wanted to package [llamafile](https://github.com/Mozilla-Ocho/llamafile) with
source building enabled. An easy way would have been to just fetch the correct
binary, which is super easy due to cosmopolitan use. But I will learn more by
packaging it from source.

This should work for osx and linux, but only NixOS has been tested. For windows
users I suggest closing the browser tab.

## Getting the source

First find the source repository, which in this case was in github and then
figure out the versioning scheme. With nix it's safe to use tags as it'll hash
the content. FOR MOST OTHER SOFTWARE PLAIN TAGS ARE NOT FUCKING OKAY TO USE AS
THEY CAN CHANGE. Unless you're doing consulting, then of course use the tool
that causes the most billable hours and just say 'it is what it is, gotta do the
work', while telling yourself tooling hasn't improved since the 1980.

After some nobel prize winning detective work we'll start with a derivation like
this:

```nix
let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-unstable";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in
{
  llamafile = pkgs.callPackage ./llamafile.nix { };
}
```

```nix
# llamafile.nix
{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
  pname = "llamafile";

  # Just to fuck with you, many nix packages call this variable a version, but
  # what I think it actually is, is the git object id. It could reference a tag,
  # a commit, a note. But fuck naming, right?
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "Mozilla-Ocho";
    repo = "llamafile";
    rev = version;

    # Setting this as empty
    hash = "";
  };
}
```

Now what's a derivation you ask? Who knows, you can read it from the reference
manual five times and end up where you started. Just trust me bro.

## How to build this shit?

```bash
cd llamafile-dir
nix-build -A llamafile
```

I guess this builds the variable defined in `default.nix`. Maybe those are
automatically some sort of outputs? I don't fucking know.

## First error! Generating your first sha for a package

Now, nothing spells progress better than getting a new error message. Remember
kids, only people who don't do shit in their lives don't fail.

After building you should receive something like this:

```shell
➜ llamafile git:(master) nix-build -A llamafile
warning: found empty hash, assuming 'sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA='
these 2 derivations will be built:
  /nix/store/7sl10852i2yih4ffwp98yzpl2kdvybzm-source.drv
  /nix/store/yifg5iq1a8j4w3vfqzch6a83r0ryw89w-llamafile-0.8.4.drv
building '/nix/store/7sl10852i2yih4ffwp98yzpl2kdvybzm-source.drv'...

trying https://github.com/Mozilla-Ocho/llamafile/archive/0.8.4.tar.gz
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100 2844k    0 2844k    0     0  3476k      0 --:--:-- --:--:-- --:--:-- 3476k
unpacking source archive /build/0.8.4.tar.gz
error: hash mismatch in fixed-output derivation '/nix/store/7sl10852i2yih4ffwp98yzpl2kdvybzm-source.drv':
         specified: sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
            got:    sha256-j7iPq1H3eB++aEMp2lbhMSO90t3DLFqgDQ4dseS9v7E=
```

Grab the sha in the mesasge, if you cannot find it then grab the power cord off
the wall. Add this SHA to the derivation and we should have something like this:

```shell
{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
  pname = "llamafile";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "Mozilla-Ocho";
    repo = "llamafile";
    rev = version;
    hash = "sha256-j7iPq1H3eB++aEMp2lbhMSO90t3DLFqgDQ4dseS9v7E=";
  };
}
```

Now this is progress! Nothing works, but such is progress.

## First missing dependency!

Run build again and you might get the following error:


```
➜ llamafile git:(master) nix-build -A llamafile
this derivation will be built:
  /nix/store/0l87n8wxxaz16yrmyb4qj3gxyh93ah16-llamafile-0.8.4.drv
building '/nix/store/0l87n8wxxaz16yrmyb4qj3gxyh93ah16-llamafile-0.8.4.drv'...
Running phase: unpackPhase
unpacking source archive /nix/store/gcah7xq30yqam1nrcidapr1g8r6gs3cv-source
source root is source
Running phase: patchPhase
Running phase: updateAutotoolsGnuConfigScriptsPhase
Running phase: configurePhase
no configure script, doing nothing
Running phase: buildPhase
build flags: SHELL=/nix/store/h3bhzvz9ipglcybbcvkxvm4vg9lwvqg4-bash-5.2p26/bin/bash
.cosmocc/3.3.6/bin/mkdeps -o o//depend -r o// llamafile/addnl.c llamafile/bincompare.c llamafile/check_cpu.c llamafile/cuda.c llamafile/extract.c llamafile/get_app_dir.c llamafile/get_tmp_dir.c llamafile/gpu.c llamafile/has.c llamafile/help.c llamafile/is_file_newer_than.c llamafile/launch_browser.c llamafile/llamafile.c llamafile/log.c llamafile/metal.c llamafile/pick_a_warp_kernel.c llamafile/schlep.c llamafile/security.c llamafile/slicehf.c llamafile/x.c llamafile/zip.c llamafile/zipalign.c llamafile/zipcheck.c llamafile/debug.cpp llamafile/explain_a_warp_kernel.cpp llamafile/flags.cpp llamafile/iqk_mul_mat.cpp llamafile/sgemm.cpp llamafile/sgemm_matmul_test.cpp llamafile/sgemm_sss_test.cpp llamafile/sgemm_vecdot_test.cpp llamafile/simple.cpp llamafile/tinyblas_cpu_mixmul_amd_avx.cpp llamafile/tinyblas_cpu_mixmul_amd_avx2.cpp llamafile/tinyblas_cpu_mixmul_amd_avx512f.cpp llamafile/tinyblas_cpu_mixmul_amd_avxvnni.cpp llamafile/tinyblas_cpu_mixmul_amd_fma.cpp llamafile/tinyblas_cpu_mixmul_amd_zen4.cpp llamafile/tinyblas_cpu_mixmul_arm80.cpp llamafile/tinyblas_cpu_mixmul_arm82.cpp llamafile/tinyblas_cpu_sgemm_amd_avx.cpp llamafile/tinyblas_cpu_sgemm_amd_avx2.cpp llamafile/tinyblas_cpu_sgemm_amd_avx512f.cpp llamafile/tinyblas_cpu_sgemm_amd_avxvnni.cpp llamafile/tinyblas_cpu_sgemm_amd_fma.cpp llamafile/tinyblas_cpu_sgemm_amd_zen4.cpp llamafile/tinyblas_cpu_sgemm_arm80.cpp llamafile/tinyblas_cpu_sgemm_arm82.cpp llamafile/tinyblas_cpu_unsupported.cpp llamafile/tokenize.cpp llamafile/compcap.cu llamafile/cudaprops.cu llamafile/tester.cu llamafile/tinyblas.cu llamafile/tinyblas_test.cu llama.cpp/ggml-alloc.c llama.cpp/ggml-backend.c llama.cpp/ggml-quants-amd-avx.c llama.cpp/ggml-quants-amd-avx2.c llama.cpp/ggml-quants-amd-avx512.c llama.cpp/ggml-quants-arm80.c llama.cpp/ggml-vector-amd-avx.c llama.cpp/ggml-vector-amd-avx2.c llama.cpp/ggml-vector-amd-avx512.c llama.cpp/ggml-vector-amd-avx512bf16.c llama.cpp/ggml-vector-amd-f16c.c llama.cpp/ggml-vector-amd-fma.c llama.cpp/ggml-vector-arm80.c llama.cpp/ggml-vector-arm82.c llama.cpp/ggml.c llama.cpp/stb_image.c llama.cpp/build-info.cpp llama.cpp/common.cpp llama.cpp/console.cpp llama.cpp/ggml-quants.cpp llama.cpp/ggml-vector.cpp llama.cpp/grammar-parser.cpp llama.cpp/json-schema-to-grammar.cpp llama.cpp/llama.cpp llama.cpp/sampling.cpp llama.cpp/unicode-data.cpp llama.cpp/unicode.cpp llama.cpp/llava/clip.cpp llama.cpp/llava/llava-cli.cpp llama.cpp/llava/llava-quantize.cpp llama.cpp/llava/llava.cpp llama.cpp/server/macsandbox.cpp llama.cpp/server/server.cpp llama.cpp/main/embedding.cpp llama.cpp/main/main.cpp llama.cpp/imatrix/imatrix.cpp llama.cpp/quantize/quantize.cpp llama.cpp/perplexity/perplexity.cpp llamafile/ansiblas.h llamafile/bench.h llamafile/cuda.h llamafile/debug.h llamafile/float.h llamafile/fp16.h llamafile/gemm.h llamafile/half.h llamafile/llamafile.h llamafile/log.h llamafile/macros.h llamafile/micros.h llamafile/naive.h llamafile/numba.h llamafile/sgemm.h llamafile/tester.h llamafile/tinyblas.h llamafile/tinyblas_cpu.h llamafile/version.h llamafile/x.h llamafile/zip.h llama.cpp/base64.h llama.cpp/common.h llama.cpp/console.h llama.cpp/ggml-alloc.h llama.cpp/ggml-backend-impl.h llama.cpp/ggml-backend.h llama.cpp/ggml-common.h llama.cpp/ggml-cuda.h llama.cpp/ggml-impl.h llama.cpp/ggml-metal.h llama.cpp/ggml-quants.h llama.cpp/ggml-vector.h llama.cpp/ggml.h llama.cpp/grammar-parser.h llama.cpp/json-schema-to-grammar.h llama.cpp/json.h llama.cpp/llama.h llama.cpp/llamafile.h llama.cpp/log.h llama.cpp/sampling.h llama.cpp/stb_image.h llama.cpp/unicode-data.h llama.cpp/unicode.h llama.cpp/llava/clip.h llama.cpp/llava/llava.h llama.cpp/server/httplib.h llama.cpp/server/macsandbox.h llama.cpp/server/oai.h llama.cpp/server/server.h llama.cpp/server/utils.h     llamafile/tinyblas_cpu_mixmul.inc llamafile/tinyblas_cpu_sgemm.inc llama.cpp/ggml-quants.inc llama.cpp/ggml-vector.inc
/nix/store/h3bhzvz9ipglcybbcvkxvm4vg9lwvqg4-bash-5.2p26/bin/bash: line 1: .cosmocc/3.3.6/bin/mkdeps: No such file or directory
build/download-cosmocc.sh .cosmocc/3.3.6 3.3.6 26e3449357f31b82489774ef5c2d502a711bb711d4faf99a5fd6c96328a1c205
build/download-cosmocc.sh: fatal error: you need the unzip command
please download https://cosmo.zip/pub/cosmos/bin/unzip and put it on the system path
download terminated.
make: *** [build/config.mk:54: .cosmocc/3.3.6] Error 1
error: builder for '/nix/store/0l87n8wxxaz16yrmyb4qj3gxyh93ah16-llamafile-0.8.4.drv' failed with exit code 2;
       last 10 log lines:
       > no configure script, doing nothing
       > Running phase: buildPhase
       > build flags: SHELL=/nix/store/h3bhzvz9ipglcybbcvkxvm4vg9lwvqg4-bash-5.2p26/bin/bash
       > .cosmocc/3.3.6/bin/mkdeps -o o//depend -r o// llamafile/addnl.c llamafile/bincompare.c llamafile/check_cpu.c llamafile/cuda.c llamafile/extract.c llamafile/get_app_dir.c llamafile/get_tmp_dir.c llamafile/gpu.c llamafile/has.c llamafile/help.c llamafile/is_file_newer_than.c llamafile/launch_browser.c llamafile/llamafile.c llamafile/log.c llamafile/metal.c llamafile/pick_a_warp_kernel.c llamafile/schlep.c llamafile/security.c llamafile/slicehf.c llamafile/x.c llamafile/zip.c llamafile/zipalign.c llamafile/zipcheck.c llamafile/debug.cpp llamafile/explain_a_warp_kernel.cpp llamafile/flags.cpp llamafile/iqk_mul_mat.cpp llamafile/sgemm.cpp llamafile/sgemm_matmul_test.cpp llamafile/sgemm_sss_test.cpp llamafile/sgemm_vecdot_test.cpp llamafile/simple.cpp llamafile/tinyblas_cpu_mixmul_amd_avx.cpp llamafile/tinyblas_cpu_mixmul_amd_avx2.cpp llamafile/tinyblas_cpu_mixmul_amd_avx512f.cpp llamafile/tinyblas_cpu_mixmul_amd_avxvnni.cpp llamafile/tinyblas_cpu_mixmul_amd_fma.cpp llamafile/tinyblas_cpu_mixmul_amd_zen4.cpp llamafile/tinyblas_cpu_mixmul_arm80.cpp llamafile/tinyblas_cpu_mixmul_arm82.cpp llamafile/tinyblas_cpu_sgemm_amd_avx.cpp llamafile/tinyblas_cpu_sgemm_amd_avx2.cpp llamafile/tinyblas_cpu_sgemm_amd_avx512f.cpp llamafile/tinyblas_cpu_sgemm_amd_avxvnni.cpp llamafile/tinyblas_cpu_sgemm_amd_fma.cpp llamafile/tinyblas_cpu_sgemm_amd_zen4.cpp llamafile/tinyblas_cpu_sgemm_arm80.cpp llamafile/tinyblas_cpu_sgemm_arm82.cpp llamafile/tinyblas_cpu_unsupported.cpp llamafile/tokenize.cpp llamafile/compcap.cu llamafile/cudaprops.cu llamafile/tester.cu llamafile/tinyblas.cu llamafile/tinyblas_test.cu llama.cpp/ggml-alloc.c llama.cpp/ggml-backend.c llama.cpp/ggml-quants-amd-avx.c llama.cpp/ggml-quants-amd-avx2.c llama.cpp/ggml-quants-amd-avx512.c llama.cpp/ggml-quants-arm80.c llama.cpp/ggml-vector-amd-avx.c llama.cpp/ggml-vector-amd-avx2.c llama.cpp/ggml-vector-amd-avx512.c llama.cpp/ggml-vector-amd-avx512bf16.c llama.cpp/ggml-vector-amd-f16c.c llama.cpp/ggml-vector-amd-fma.c llama.cpp/ggml-vector-arm80.c llama.cpp/ggml-vector-arm82.c llama.cpp/ggml.c llama.cpp/stb_image.c llama.cpp/build-info.cpp llama.cpp/common.cpp llama.cpp/console.cpp llama.cpp/ggml-quants.cpp llama.cpp/ggml-vector.cpp llama.cpp/grammar-parser.cpp llama.cpp/json-schema-to-grammar.cpp llama.cpp/llama.cpp llama.cpp/sampling.cpp llama.cpp/unicode-data.cpp llama.cpp/unicode.cpp llama.cpp/llava/clip.cpp llama.cpp/llava/llava-cli.cpp llama.cpp/llava/llava-quantize.cpp llama.cpp/llava/llava.cpp llama.cpp/server/macsandbox.cpp llama.cpp/server/server.cpp llama.cpp/main/embedding.cpp llama.cpp/main/main.cpp llama.cpp/imatrix/imatrix.cpp llama.cpp/quantize/quantize.cpp llama.cpp/perplexity/perplexity.cpp llamafile/ansiblas.h llamafile/bench.h llamafile/cuda.h llamafile/debug.h llamafile/float.h llamafile/fp16.h llamafile/gemm.h llamafile/half.h llamafile/llamafile.h llamafile/log.h llamafile/macros.h llamafile/micros.h llamafile/naive.h llamafile/numba.h llamafile/sgemm.h llamafile/tester.h llamafile/tinyblas.h llamafile/tinyblas_cpu.h llamafile/version.h llamafile/x.h llamafile/zip.h llama.cpp/base64.h llama.cpp/common.h llama.cpp/console.h llama.cpp/ggml-alloc.h llama.cpp/ggml-backend-impl.h llama.cpp/ggml-backend.h llama.cpp/ggml-common.h llama.cpp/ggml-cuda.h llama.cpp/ggml-impl.h llama.cpp/ggml-metal.h llama.cpp/ggml-quants.h llama.cpp/ggml-vector.h llama.cpp/ggml.h llama.cpp/grammar-parser.h llama.cpp/json-schema-to-grammar.h llama.cpp/json.h llama.cpp/llama.h llama.cpp/llamafile.h llama.cpp/log.h llama.cpp/sampling.h llama.cpp/stb_image.h llama.cpp/unicode-data.h llama.cpp/unicode.h llama.cpp/llava/clip.h llama.cpp/llava/llava.h llama.cpp/server/httplib.h llama.cpp/server/macsandbox.h llama.cpp/server/oai.h llama.cpp/server/server.h llama.cpp/server/utils.h     llamafile/tinyblas_cpu_mixmul.inc llamafile/tinyblas_cpu_sgemm.inc llama.cpp/ggml-quants.inc llama.cpp/ggml-vector.inc
       > /nix/store/h3bhzvz9ipglcybbcvkxvm4vg9lwvqg4-bash-5.2p26/bin/bash: line 1: .cosmocc/3.3.6/bin/mkdeps: No such file or directory
       > build/download-cosmocc.sh .cosmocc/3.3.6 3.3.6 26e3449357f31b82489774ef5c2d502a711bb711d4faf99a5fd6c96328a1c205
       > build/download-cosmocc.sh: fatal error: you need the unzip command
       > please download https://cosmo.zip/pub/cosmos/bin/unzip and put it on the system path
       > download terminated.
       > make: *** [build/config.mk:54: .cosmocc/3.3.6] Error 1
       For full logs, run 'nix log /nix/store/0l87n8wxxaz16yrmyb4qj3gxyh93ah16-llamafile-0.8.4.drv'.
```

Ah, missing dependency! If you come from a python background, then you'll
remember this to be a feature or batteries included 'work that just needs to be
done'. Drop some virtualenvs and other python tooling on the floor that doesn't
work to pray respects for useless work done during the years. ONWARDS!

We see, that Cosmopolitan tries to force some random ass universal binary for
unzip, which we'll ignore for now.

Define unzip as a dependency like so:

```nix
{ stdenv, fetchFromGitHub, unzip }:
stdenv.mkDerivation rec {
  pname = "llamafile";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "Mozilla-Ocho";
    repo = "llamafile";
    rev = version;
    hash = "sha256-j7iPq1H3eB++aEMp2lbhMSO90t3DLFqgDQ4dseS9v7E=";
  };

  buildInputs = [
    unzip
  ];
}
```

Now at this point you might think, what the actual fuck. This does work. Of
course in documentation this is totally skipped and just trust me bro.

If we reference back to the `default.nix`, we'll find this line
`pkgs.callPackage ./llamafile.nix { };`. What this does is passes attributes
from `pkgs` to the function in `llamafile.nix`. In other words all the
attributes in `pkgs` are available as parameters in our file.

Build it and see that we still get errors but not about unzip. Progress BABYYY!
At this point mute the python developers in slack complaining about broken
environments, today is a good day, let's not ruin it.

## Tackling the other errors

From here it's just the normal downhill as with all other packaging endeavour:

* cosmopolitan version in nixpkgs is old as balls
* building cosmopolitan was completely redone
* cosmpopolitan relies on prebuild binaries in the repository
* there's no guides or readme how to bootstrap it
  * It seems to have it's own binaries in the repo we should use
* like any other sane github project, releases are not documented
  * I'm guessing some contributor just builds a zip by hand, what a world

And this is why you never pick your demo project based on some youtube ass
looking guide. Always pick something complex. People always make guides for the
easiest of shit. You will get the wrong impression of the tools and thinking
it's easy. IT'S NEVER FUCKING EASY.

TODO(tatu): complete writing the guide:
* Building from source didn't work (user error 100%)
  * Issue being it tried to access something from `build/`
* I cut corners to just fetch the zip files and use those
* Stripping cosmopolitan binaries breaks them
  * I tried this and at least `strip --strip-all` breaks cosmo binaries
