load("//:http.bzl", "http_archive")
load("//:versions.bzl", "BSD_VERSIONS", "get_triple")

def toolchains_bsd_dependencies():
    http_archive(
        name = "org_llvm_cfe",
        build_file = "@com_github_edschouten_bazel_toolchains_bsd//:BUILD.cfe",
        sha256 = "a45b62dde5d7d5fdcdfa876b0af92f164d434b06e9e89b5d0b1cbc65dfe3f418",
        strip_prefix = "cfe-7.0.1.src",
        urls = ["https://releases.llvm.org/7.0.1/cfe-7.0.1.src.tar.xz"],
    )

    http_archive(
        name = "org_llvm_llvm_x86_64_apple_darwin",
        build_file = "@com_github_edschouten_bazel_toolchains_bsd//:BUILD.llvm",
        sha256 = "b3ad93c3d69dfd528df9c5bb1a434367babb8f3baea47fbb99bf49f1b03c94ca",
        strip_prefix = "clang+llvm-7.0.0-x86_64-apple-darwin",
        urls = ["https://releases.llvm.org/7.0.0/clang+llvm-7.0.0-x86_64-apple-darwin.tar.xz"],
    )

    http_archive(
        name = "org_llvm_llvm_x86_64_unknown_freebsd",
        build_file = "@com_github_edschouten_bazel_toolchains_bsd//:BUILD.llvm",
        sha256 = "95ceb933ccf76e3ddaa536f41ab82c442bbac07cdea6f9fbf6e3b13cc1711255",
        strip_prefix = "clang+llvm-7.0.0-amd64-unknown-freebsd11",
        urls = ["https://releases.llvm.org/7.0.0/clang+llvm-7.0.0-amd64-unknown-freebsd11.tar.xz"],
    )

    http_archive(
        name = "org_llvm_llvm_x86_64_unknown_linux_gnu",
        build_file = "@com_github_edschouten_bazel_toolchains_bsd//:BUILD.llvm",
        sha256 = "5c90e61b06d37270bc26edb305d7e498e2c7be22d99e0afd9f2274ef5458575a",
        strip_prefix = "clang+llvm-7.0.0-x86_64-linux-gnu-ubuntu-14.04",
        urls = ["https://releases.llvm.org/7.0.0/clang+llvm-7.0.0-x86_64-linux-gnu-ubuntu-14.04.tar.xz"],
    )

    for version, architectures in BSD_VERSIONS["freebsd"].items():
        for architecture, archives in architectures.items():
            if architecture == "aarch64":
                bsd_architecture = "arm64"
            elif architecture == "x86_64":
                bsd_architecture = "amd64"
            else:
                bsd_architecture = architecture
            for archive, sha256 in archives.items():
                http_archive(
                    name = "%s_%s" % (get_triple("freebsd", version, architecture), archive),
                    build_file = "@com_github_edschouten_bazel_toolchains_bsd//:BUILD.bsd",
                    sha256 = sha256,
                    urls = ["http://ftp.nluug.nl/FreeBSD/releases/%s/%s-RELEASE/%s.txz" %
                            (bsd_architecture, version, archive)],
                )

    for version, architectures in BSD_VERSIONS["netbsd"].items():
        for architecture, archives in architectures.items():
            bsd_architecture = "amd64" if architecture == "x86_64" else architecture
            for archive, sha256 in archives.items():
                http_archive(
                    name = "%s_%s" % (get_triple("netbsd", version, architecture), archive),
                    build_file = "@com_github_edschouten_bazel_toolchains_bsd//:BUILD.bsd",
                    copy_paths = {"usr/include/machine": "usr/include/" + bsd_architecture},
                    sha256 = sha256,
                    urls = ["http://ftp.nluug.nl/NetBSD/NetBSD-%s/%s/binary/sets/%s.tgz" %
                            (version, bsd_architecture, archive)],
                )

    for version, architectures in BSD_VERSIONS["openbsd"].items():
        for architecture, archives in architectures.items():
            bsd_architecture = "amd64" if architecture == "x86_64" else architecture
            for archive, sha256 in archives.items():
                http_archive(
                    name = "%s_%s" % (get_triple("openbsd", version, architecture), archive),
                    build_file = "@com_github_edschouten_bazel_toolchains_bsd//:BUILD.bsd",
                    sha256 = sha256,
                    urls = ["http://ftp.nluug.nl/OpenBSD/%s/%s/%s.tgz" %
                            (version, bsd_architecture, archive)],
                )
