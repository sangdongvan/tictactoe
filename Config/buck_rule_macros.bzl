load("//Config:configs.bzl",
    "app_binary_configs",
    "app_info_plist_substitutions",
    "base_info_plist_substitutions",
    "demo_binary_configs",
)

load("//Config:utils.bzl",
    "library_configs",
    "dynamic_library_configs",
)

load(
    "//Config:functions.bzl",
    "get_basename",
    "get_basename_without_extension",
)

text_section_items = [
    "__text",
]

text_section_rename_linker_flags = [] #["-Wl,-rename_section,__TEXT,%s,__MEXT,%s" % (name, name) for name in text_section_items] + ["-Wl,-segprot,__MEXT,rx,rx"]

section_rename_linker_flags = text_section_rename_linker_flags

def apple_lib(
        name,
        visibility = ["PUBLIC"],
        srcs = [],
        headers = [],
        exported_headers = [],
        extra_xcode_files = [],
        deps = [],
        exported_deps = [],
        additional_linker_flags = None,
        exported_preprocessor_flags = [],
        exported_linker_flags = [],
        frameworks = [],
        weak_frameworks = [],
        tests = [],
        swift_version = None,
        modular = True,
        compiler_flags = None,
        platform_compiler_flags = None,
        swift_compiler_flags = None,
        warning_as_error = False,
        suppress_warnings = False,
        has_cpp = False,
        framework = False):
    swift_version = swift_version or native.read_config('swift', 'version')
    swift_compiler_flags = swift_compiler_flags or []

    resolved_frameworks = frameworks

    if native.read_config("xcode", "beta") == "True":
        warning_as_error = False

    if platform_compiler_flags != None:
        if compiler_flags != None:
            fail("compiler_flags and platform_compiler_flags are mutually exclusive")
        compiler_flags = []
        for i in range(len(platform_compiler_flags)):
            if warning_as_error:
                platform_compiler_flags[i][1].append("-Werror")
            elif suppress_warnings:
                platform_compiler_flags[i][1].append("-w")
    else:
        compiler_flags = compiler_flags or []
        if warning_as_error:
            compiler_flags.append("-Werror")
        elif suppress_warnings:
            compiler_flags.append("-w")

    if warning_as_error:
        swift_compiler_flags.append("-warnings-as-errors")
    elif suppress_warnings:
        swift_compiler_flags.append("-suppress-warnings")

    if framework:
        additional_linker_flags = additional_linker_flags or []
        if has_cpp:
            linker_flags = [
                "-lc++",
                "-lz"
            ]
        else:
            linker_flags = []

        if native.read_config("custom", "mode") == "project":
            resolved_linker_flags = linker_flags + additional_linker_flags + ["-Wl,-install_name,@rpath/lib%s.dylib" % (name)]
            resolved_frameworks = resolved_frameworks + ["$SDKROOT/System/Library/Frameworks/%s.framework" % x for x in weak_frameworks]
        else:
            resolved_linker_flags = linker_flags + additional_linker_flags + ["-Wl,-install_name,@rpath/%s.framework/%s" % (name, name)]
            for framework in weak_frameworks:
                resolved_linker_flags = resolved_linker_flags + ["-Wl,-weak_framework,%s" % framework]

        resolved_linker_flags = resolved_linker_flags + section_rename_linker_flags

        native.apple_library(
            name = name + "",
            srcs = srcs,
            header_namespace = name,
            module_name = name,
            soname = "lib" + name + ".dylib",
            headers = headers,
            exported_headers = exported_headers,
            deps = deps,
            exported_deps = exported_deps,
            extra_xcode_files = extra_xcode_files,
            frameworks = resolved_frameworks,
            tests = tests,
            visibility = visibility,
            swift_version = swift_version,
            configs = dynamic_library_configs(),
            modular = modular,
            compiler_flags = compiler_flags,
            platform_compiler_flags = platform_compiler_flags,
            swift_compiler_flags = swift_compiler_flags,
            preferred_linkage = "shared",
            #link_style = "static",
            linker_flags = resolved_linker_flags,
        )
    else:
        additional_linker_flags = additional_linker_flags or []
        if has_cpp:
            linker_flags = [
                "-lc++",
                "-lz"
            ]
        else:
            linker_flags = []

        resolved_exported_linker_flags = exported_linker_flags + linker_flags + additional_linker_flags

        if native.read_config("custom", "mode") == "project":
            resolved_frameworks = resolved_frameworks + ["$SDKROOT/System/Library/Frameworks/%s.framework" % x for x in weak_frameworks]
        else:
            for framework in weak_frameworks:
                resolved_exported_linker_flags = resolved_exported_linker_flags + ["-Wl,-weak_framework,%s" % framework]

        native.apple_library(
            name = name,
            srcs = srcs,
            headers = headers,
            exported_headers = exported_headers,
            deps = deps,
            exported_deps = exported_deps,
            exported_linker_flags = resolved_exported_linker_flags,
            extra_xcode_files = extra_xcode_files,
            frameworks = resolved_frameworks,
            tests = tests,
            visibility = visibility,
            swift_version = swift_version,
            configs = library_configs(),
            modular = modular,
            compiler_flags = compiler_flags,
            platform_compiler_flags = platform_compiler_flags,
            swift_compiler_flags = swift_compiler_flags,
            preferred_linkage = "static",
            exported_preprocessor_flags = exported_preprocessor_flags,
        )

def static_library(
        name,
        srcs = None,
        visibility = ["PUBLIC"],
        has_cpp = False,
        headers = [],
        exported_headers = [],
        extra_xcode_files = [],
        deps = [],
        additional_linker_flags = None,
        exported_preprocessor_flags = [],
        exported_linker_flags = [],
        frameworks = [],
        weak_frameworks = [],
        tests = [],
        info_plist = None,
        info_plist_substitutions = {},
        modular = True,
        compiler_flags = None,
        platform_compiler_flags = None,
        swift_compiler_flags = None,
        warning_as_error = False,
        suppress_warnings = True
    ):
    srcs = srcs or native.glob(["Sources/**/*.swift"])
    if has_cpp:
        srcs.extend(native.glob(["Sources/**/*.cpp"]))
        srcs.extend(native.glob(["Sources/**/*.mm"]))
        all_headers = native.glob(["Sources/**/*.hpp"])
        for header in all_headers:
            exported_headers.append(header)

    apple_lib(
        name = name,
        visibility = visibility,
        srcs = srcs,
        has_cpp = has_cpp,
        exported_headers = exported_headers,
        headers = headers,
        modular = modular,
        compiler_flags = compiler_flags,
        platform_compiler_flags = platform_compiler_flags,
        swift_compiler_flags = swift_compiler_flags,
        extra_xcode_files = extra_xcode_files,
        deps = deps,
        additional_linker_flags = additional_linker_flags,
        exported_preprocessor_flags = exported_preprocessor_flags,
        exported_linker_flags = exported_linker_flags,
        frameworks = frameworks,
        weak_frameworks = weak_frameworks,
        tests = tests,
        warning_as_error = warning_as_error,
        suppress_warnings = suppress_warnings
    )

def unit_test(
        name,
        srcs = None,
        deps = [],
        frameworks = [],
        info_plist = "//Config/BuckSupportFiles:TestInfo.plist",
        info_plist_substitutions = {},
        swift_compiler_flags = None
    ):
    srcs = srcs or native.glob(["Tests/**/*.swift"])
    info_plist_substitutions = info_plist_substitutions or base_info_plist_substitutions(name)

    native.apple_test(
        name = name,
        srcs = srcs,
        deps = deps,
        module_name = name,
        frameworks = [
            "$PLATFORM_DIR/Developer/Library/Frameworks/XCTest.framework"
        ] + frameworks,
        info_plist = info_plist,
        info_plist_substitutions = info_plist_substitutions,
        swift_version = native.read_config('swift', 'version'),
        swift_compiler_flags = swift_compiler_flags
    )

def unit_test_with_host_api(
        name,
        test_host_app,
        srcs = None,
        deps = [],
        frameworks = [],
        info_plist = "//Config/BuckSupportFiles:TestInfo.plist",
        info_plist_substitutions = {},
        swift_compiler_flags = None
    ):
    srcs = srcs or native.glob(["HostTests/**/*.swift"])
    info_plist_substitutions = info_plist_substitutions or base_info_plist_substitutions(name)

    native.apple_test(
        name = name,
        srcs = srcs,
        deps = deps,
        module_name = name,
        frameworks = [
            "$PLATFORM_DIR/Developer/Library/Frameworks/XCTest.framework"
        ] + frameworks,
        info_plist = info_plist,
        info_plist_substitutions = info_plist_substitutions,
        test_host_app = test_host_app,
        swift_version = native.read_config('swift', 'version'),
        swift_compiler_flags = swift_compiler_flags
    )

def ui_test(
        name,
        srcs = None,
        deps = [],
        frameworks = [],
        info_plist = "//Config/BuckSupportFiles:TestInfo.plist",
        info_plist_substitutions = {},
        ui_test_target_app = None,
        swift_compiler_flags = None
    ):
    srcs = srcs or native.glob(["UITests/**/*.swift"])
    info_plist_substitutions = info_plist_substitutions or base_info_plist_substitutions(name)

    native.apple_test(
        name = name,
        srcs = srcs,
        deps = deps,
        module_name = name,
        frameworks = [
            "$PLATFORM_DIR/Developer/Library/Frameworks/XCTest.framework",
            "$SDKROOT/System/Library/Frameworks/Foundation.framework",
            "$SDKROOT/System/Library/Frameworks/UIKit.framework"
        ] + frameworks,
        info_plist = info_plist,
        info_plist_substitutions = info_plist_substitutions,
        test_host_app = None,
        is_ui_test = True,
        ui_test_target_app = ui_test_target_app,
        swift_version = native.read_config('swift', 'version'),
        swift_compiler_flags = swift_compiler_flags
    )

def prebuilt_framework(path):
    basename_without_extension = get_basename_without_extension(path)
    native.prebuilt_apple_framework(
        name = basename_without_extension,
        framework = path,
        preferred_linkage = "shared",
        visibility = ["PUBLIC"],
    )

def framework(
        name,
        visibility = ["PUBLIC"],
        has_cpp = False,
        headers = [],
        exported_headers = [],
        extra_xcode_files = [],
        deps = [],
        exported_deps = [],
        additional_linker_flags = None,
        frameworks = [],
        weak_frameworks = [],
        info_plist = None,
        info_plist_substitutions = {},
        modular = True,
        compiler_flags = None,
        platform_compiler_flags = None,
        swift_compiler_flags = None,
        warning_as_error = False,
        suppress_warnings = True,
        framework = True
    ):
    srcs = native.glob(["Sources/**/*.swift"])
    if has_cpp:
        srcs.extend(native.glob(["Sources/**/*.cpp"]))
        srcs.extend(native.glob(["Sources/**/*.mm"]))
        all_headers = native.glob(["Sources/**/*.hpp"])
        for header in all_headers:
            exported_headers.append(header)
    apple_lib(
        name = name,
        srcs = srcs,
        has_cpp = has_cpp,
        exported_headers = exported_headers,
        headers = headers,
        modular = modular,
        compiler_flags = compiler_flags,
        platform_compiler_flags = platform_compiler_flags,
        swift_compiler_flags = swift_compiler_flags,
        extra_xcode_files = extra_xcode_files,
        deps = deps,
        exported_deps = exported_deps,
        additional_linker_flags = additional_linker_flags,
        frameworks = frameworks,
        weak_frameworks = weak_frameworks,
        warning_as_error = warning_as_error,
        suppress_warnings = suppress_warnings,
        framework = framework
    )
    

CXX_SRC_EXT = ["mm", "cpp", "S"]
def apple_cxx_lib(
        srcs = [],
        additional_exported_linker_flags = [],
        **kwargs):
    c_srcs, cxx_srcs = [], []

    cxx_compile_flags = native.read_config("cxx", "cxxflags").split(" ")
    cxx_compile_flags.append("-w")

    for file_ in srcs:
        if file_.split(".")[-1] in CXX_SRC_EXT:
            cxx_srcs.append((file_, cxx_compile_flags))
        else:
            c_srcs.append(file_)
    apple_lib(
        srcs = c_srcs + cxx_srcs,
        exported_linker_flags = [
            "-lc++",
            "-lz"
        ] + additional_exported_linker_flags,
        **kwargs
    )

# ============================================================================
# App Macros
# ============================================================================
def application(
        product_name,
        srcs = None,
        info_plist = None,
        info_plist_substitutions = None,
        visibility = None,
        prebuilt_framework_deps = [],
        deps = [],
        build_phrase_deps = [],
        resource_deps = [],
    ):

    srcs = srcs or native.glob(["Sources/**/*.swift"])
    info_plist = info_plist or "Info.plist"
    info_plist_substitutions = info_plist_substitutions or app_info_plist_substitutions()

    native.apple_library(
        name = "AppLibrary",
        configs = library_configs(),
        swift_version = native.read_config("swift", "version"),
        srcs = srcs,
        deps = deps,
    )

    native.apple_binary(
        name = "AppBinary",
        configs = app_binary_configs(),
        swift_version = native.read_config("swift", "version"),
        srcs = [
            "//Config/BuckSupportFiles:Empty.swift",
        ],
        deps = [
            ":AppLibrary",
        ]
        + build_phrase_deps
        + resource_deps,
    )

    native.apple_bundle(
        name = "AppBundle",
        visibility = ["PUBLIC"],
        extension = "app",
        binary = ":AppBinary",
        product_name = product_name,
        info_plist = info_plist,
        info_plist_substitutions = app_info_plist_substitutions(),
        deps = prebuilt_framework_deps,
    )

    # Package

    native.apple_package(
        name = "AppPackage",
        bundle = ":AppBundle",
    )
# ============================================================================
# End App Macros
# ============================================================================

# ============================================================================
# Start Demo Macros
# ============================================================================
def demo(
        name,
        srcs = None,
        prebuilt_framework_deps = [],
        deps = [],
        build_phrase_deps = [],
        resource_deps = [],
    ):
    srcs = srcs or native.glob(["Demo/**/*.swift"])

    demo_library_name = name + "Library"
    demo_binary_name = name + "Binary"
    demo_bundle_name = name + "Bundle"

    native.apple_library(
        name = demo_library_name,
        configs = library_configs(),
        swift_version = native.read_config("swift", "version"),
        srcs = srcs,
        deps = deps,
    )

    native.apple_binary(
        name = demo_binary_name,
        configs = demo_binary_configs(name),
        swift_version = native.read_config("swift", "version"),
        srcs = [
            "//Config/BuckSupportFiles:Empty.swift",
        ],
        deps = [
            ":" + demo_library_name,
        ]
        + build_phrase_deps
        + resource_deps,
    )

    native.apple_bundle(
        name = demo_bundle_name,
        visibility = ["PUBLIC"],
        extension = "app",
        binary = ":" + demo_binary_name,
        product_name = name,
        info_plist = "//Config/BuckSupportFiles:TestInfo.plist",
        info_plist_substitutions = base_info_plist_substitutions(name = name),
        deps = prebuilt_framework_deps,
    )

    # Package

    native.apple_package(
        name = "DemoPackage",
        bundle = ":" + demo_bundle_name,
    )
# ============================================================================
# End Demo Macros
# ============================================================================

def exports_files(files):
    for file in files:
        basename = get_basename(file)
        native.genrule(
            name = file,
            srcs = [file],
            out = basename,
            cmd = "cp $SRCDIR/" + file + " $OUT",
            visibility = ["PUBLIC"],
        )

def framework_binary_dependencies(names):
    result = []
    for name in names:
        result.append(name + "#shared")
    return result

def framework_bundle_dependencies(names):
    result = []
    if native.read_config("custom", "mode") == "project":
        for name in names:
            pass
    else:
        for name in names:
            result.append(name + "#shared")
    return result

def gen_header_targets(header_paths, prefix, flavor, source_rule, source_path):
    result = dict()
    for header_path in header_paths:
        name = prefix + header_path.replace('/', '_sub_')
        native.genrule(
            name = name + flavor,
            cmd = 'cp $(location :' + source_rule + ')/' + source_path + '/' + header_path + ' $OUT',
            out = name,
        )
        result[header_path] = ':' + name + flavor
    return result

def merge_maps(dicts):
    result = dict()
    for d in dicts:
        for key in d:
            if key in result and result[key] != d[key]:
                fail(
                    "Conflicting files in file search paths. " +
                    "\"%s\" maps to both \"%s\" and \"%s\"." %
                    (key, result[key], d[key]),
                )
        result.update(d)
    return result

def basename(p):
    return p.rpartition("/")[-1]

def glob_map(glob_results):
    result = dict()
    for path in glob_results:
        file_name = basename(path)
        if file_name in result:
            fail('\"%s\" maps to both \"%s\" and \"%s\"' % (file_name, result[file_name], path))
        result[file_name] = path
    return result

def glob_sub_map(prefix, glob_specs):
    result = dict()
    for path in native.glob(glob_specs):
        if not path.startswith(prefix):
            fail('\"%s\" does not start with \"%s\"' % (path, prefix))
        file_key = path[len(prefix):]
        if file_key in result:
            fail('\"%s\" maps to both \"%s\" and \"%s\"' % (file_key, result[file_key], path))
        result[file_key] = path
    return result
