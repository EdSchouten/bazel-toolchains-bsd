#!/usr/bin/env python
execfile("versions.bzl")

with open("CROSSTOOL", "w") as f:
    f.write("""major_version: "local"\nminor_version: ""\n""")

    for os, versions in sorted(BSD_VERSIONS.items()):
        for version, architectures in sorted(versions.items()):
            for architecture, archives in sorted(architectures.items()):
                f.write(
                    """toolchain {
  toolchain_identifier: "%(triple)s"
  host_system_name: "local"
  target_system_name: "%(triple)s"
  target_cpu: "%(triple)s"
  target_libc: "libc"
  compiler: "clang"
  abi_version: ""
  abi_libc_version: ""
  tool_path { name: "ar" path: "wrappers/llvm-ar" }
  tool_path { name: "cpp" path: "/usr/bin/false" }
  tool_path { name: "gcc" path: "wrappers/clang" }
  tool_path { name: "gcov" path: "/usr/bin/false" }
  tool_path { name: "ld" path: "/usr/bin/false" }
  tool_path { name: "nm" path: "/usr/bin/false" }
  tool_path { name: "objdump" path: "/usr/bin/false" }
  tool_path { name: "strip" path: "/usr/bin/false" }

  cxx_flag: "-std=c++17"
  unfiltered_cxx_flag: "--target=%(triple)s"
  unfiltered_cxx_flag: "-nostdinc"
  unfiltered_cxx_flag: "-isystem"
  unfiltered_cxx_flag: "external/org_llvm_cfe/lib/Headers"
  unfiltered_cxx_flag: "-isystem"
  unfiltered_cxx_flag: "external/%(triple)s_base/usr/include/c++/v1"
  unfiltered_cxx_flag: "-isystem"
  unfiltered_cxx_flag: "external/%(triple)s_base/usr/include"
  unfiltered_cxx_flag: "-Werror=date-time"

  linker_flag: "--target=%(triple)s"
  linker_flag: "-static"
  linker_flag: "-Bexternal/%(triple)s_base/usr/lib"
  linker_flag: "-Lexternal/%(triple)s_base/usr/lib"
  linker_flag: "-lc++"
  linker_flag: "-fuse-ld=lld"

  compilation_mode_flags {
    mode: DBG
    compiler_flag: "-g"
  }
  compilation_mode_flags {
    mode: OPT
    compiler_flag: "-g0"
    compiler_flag: "-O2"
    compiler_flag: "-DNDEBUG"
    compiler_flag: "-ffunction-sections"
    compiler_flag: "-fdata-sections"
    linker_flag: "-Wl,--gc-sections"
  }
}
"""
                    % {"triple": get_triple(os, version, architecture)}
                )

    f.write("""toolchain {
  toolchain_identifier: "x86_64-apple-darwin"
  abi_version: "local"
  abi_libc_version: "local"
  builtin_sysroot: ""
  compiler: "compiler"
  host_system_name: "local"
  needsPic: true
  supports_gold_linker: false
  supports_incremental_linker: false
  supports_fission: false
  supports_interface_shared_objects: false
  supports_normalizing_ar: false
  supports_start_end_lib: false
  target_libc: "macosx"
  target_cpu: "darwin"
  target_system_name: "local"
  cxx_flag: "-std=c++0x"
  linker_flag: "-undefined"
  linker_flag: "dynamic_lookup"
  linker_flag: "-headerpad_max_install_names"
  linker_flag: "-lstdc++"
  linker_flag: "-lm"
  cxx_builtin_include_directory: "/usr/local/include"
  cxx_builtin_include_directory: "/Library/Developer/CommandLineTools/usr/lib/clang/10.0.0/include"
  cxx_builtin_include_directory: "/Library/Developer/CommandLineTools/usr/include"
  cxx_builtin_include_directory: "/Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/usr/include"
  cxx_builtin_include_directory: "/Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/System/Library/Frameworks"
  cxx_builtin_include_directory: "/Library/Developer/CommandLineTools/usr/include/c++/v1"
  objcopy_embed_flag: "-I"
  objcopy_embed_flag: "binary"
  unfiltered_cxx_flag: "-no-canonical-prefixes"
  unfiltered_cxx_flag: "-Wno-builtin-macro-redefined"
  unfiltered_cxx_flag: "-D__DATE__=\\"redacted\\""
  unfiltered_cxx_flag: "-D__TIMESTAMP__=\\"redacted\\""
  unfiltered_cxx_flag: "-D__TIME__=\\"redacted\\""
  compiler_flag: "-U_FORTIFY_SOURCE"
  compiler_flag: "-fstack-protector"
  compiler_flag: "-Wall"
  compiler_flag: "-Wthread-safety"
  compiler_flag: "-Wself-assign"
  compiler_flag: "-fcolor-diagnostics"
  compiler_flag: "-fno-omit-frame-pointer"
  tool_path { name: "ar" path: "/usr/bin/libtool" }
  tool_path { name: "ld" path: "/usr/bin/ld" }
  tool_path { name: "cpp" path: "/usr/bin/cpp" }
  tool_path { name: "gcc" path: "/usr/bin/cc" }
  tool_path { name: "dwp" path: "/usr/bin/dwp" }
  tool_path { name: "gcov" path: "/usr/bin/gcov" }
  tool_path { name: "nm" path: "/usr/bin/nm" }
  tool_path { name: "objcopy" path: "/usr/bin/objcopy" }
  tool_path { name: "objdump" path: "/usr/bin/objdump" }
  tool_path { name: "strip" path: "/usr/bin/strip" }
  compilation_mode_flags {
    mode: DBG
    compiler_flag: "-g"
  }
  compilation_mode_flags {
    mode: OPT
    compiler_flag: "-g0"
    compiler_flag: "-O2"
    compiler_flag: "-D_FORTIFY_SOURCE=1"
    compiler_flag: "-DNDEBUG"
    compiler_flag: "-ffunction-sections"
    compiler_flag: "-fdata-sections"
  }
  linking_mode_flags { mode: DYNAMIC }
  feature {
    name: 'coverage'
    provides: 'profile'
    flag_set {
      action: 'preprocess-assemble'
      action: 'c-compile'
      action: 'c++-compile'
      action: 'c++-header-parsing'
      action: 'c++-module-compile'
      flag_group {
        flag: '-fprofile-instr-generate'
        flag: '-fcoverage-mapping'
      }
    }
    flag_set {
      action: 'c++-link-dynamic-library'
      action: 'c++-link-nodeps-dynamic-library'
      action: 'c++-link-executable'
      flag_group {
        flag: '-fprofile-instr-generate'
      }
    }
  }
  feature {
    name: 'fdo_optimize'
    provides: 'profile'
    flag_set {
      action: 'c-compile'
      action: 'c++-compile'
      expand_if_all_available: 'fdo_profile_path'
      flag_group {
        flag: '-fprofile-use=%{fdo_profile_path}'
        flag: '-fprofile-correction',
      }
    }
  }
}
""")
