BSD_VERSIONS = {
    "freebsd": {
        "11.2": {
            "i386": {"base": "9c8be09d549f6365a43f8a86529110c1ebac4263ac357c8aa25b753d65b1460c"},
            "x86_64": {"base": "a002be690462ad4f5f2ada6d01784836946894ed9449de6289b3e67d8496fd19"},
        },
        "12.0": {
            "aarch64": {"base": "b212d0ff7a349069706ae46e4312c5bdecd173c034c7b0cf2b68094a22a24261"},
            "i386": {"base": "933df25a1b5093f056f000a305144d007785175aa7b9cc197cfaf3096142840d"},
            "x86_64": {"base": "360df303fac75225416ccc0c32358333b90ebcd58e54d8a935a4e13f158d3465"},
        },
    },
    "netbsd": {
        "8.0": {
            "x86_64": {"comp": "07eb16adcf48120619af9eae7232f4cabf4df7daaa05acd9d5bc0336c3a55645"},
        },
    },
    "openbsd": {
        "6.4": {
            "x86_64": {
                "base64": "dacd17fb88673c16d4bd18f787c08e83c1c61904ec4a61d962aaee31a5dc5b1f",
                "comp64": "b67944691edd6feaac8acafbf890cf852df9df26d0dc1973c875ab8c1ac017ac",
            },
        },
    },
}

def get_triple(os, version, architecture):
    return "%s-unknown-%s%s" % (architecture, os, version)
