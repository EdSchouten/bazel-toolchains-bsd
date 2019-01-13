load("@bazel_tools//tools/build_defs/repo:utils.bzl", "patch", "workspace_and_buildfile")

def _http_archive_impl(ctx):
    download_info = ctx.download(
        ctx.attr.urls,
        ".archive",
        ctx.attr.sha256,
    )
    strip_components = []
    if ctx.attr.strip_prefix:
        strip_components.append(
            "--strip-components=%d" % len(ctx.attr.strip_prefix.split("/")),
        )
    ctx.execute([
        "tar",
        "-xf",
        ".archive",
    ] + strip_components)
    for to_path, from_path in ctx.attr.copy_paths.items():
        r = ctx.execute([
            "cp",
            "-r",
            from_path,
            to_path,
        ])
        if r.return_code != 0:
            fail("%s\n%s\nFailed to copy directory" % (r.stdout, r.stderr))
    patch(ctx)
    workspace_and_buildfile(ctx)

http_archive = repository_rule(
    attrs = {
        "build_file": attr.label(allow_single_file = True),
        "build_file_content": attr.string(),
        "copy_paths": attr.string_dict(default = {}),
        "patch_args": attr.string_list(default = ["-p0"]),
        "patch_cmds": attr.string_list(default = []),
        "patch_tool": attr.string(default = "patch"),
        "patches": attr.label_list(default = []),
        "sha256": attr.string(),
        "strip_prefix": attr.string(),
        "urls": attr.string_list(),
        "workspace_file": attr.label(allow_single_file = True),
        "workspace_file_content": attr.string(),
    },
    local = False,
    implementation = _http_archive_impl,
)
