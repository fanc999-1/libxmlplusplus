# examples

# Input: meson, xmlxx_own_dep, build_examples, generate_uac_manifest_py
# Output: -

# Generate the manifest file to embed for 32-bit builds for tests to run
# (on 32-bit Windows, execucatables that have 'update' in their filenames
#  are considered to trigger UAC, which will get into our way)

dom_update_namespace_extra_objs = []
if host_machine.system() == 'windows' and host_machine.cpu_family() == 'x86'
  uac_exe_pkg = 'libxml++'
  uac_exe_name = 'dom_update_namespace'
  dom_update_namespace_rc = custom_target(
    '@0@.rc'.format(uac_exe_name),
    output: '@0@.rc'.format(uac_exe_name),
    command: [generate_uac_manifest_py,
              '-p=@0@'.format(uac_exe_pkg),
              '-n=@0@'.format(uac_exe_name),
              '--pkg-version=@0@'.format(meson.project_version()),
              '--output-dir=@OUTDIR@'],
  )
  dom_update_namespace_extra_objs += import('windows').compile_resources(dom_update_namespace_rc)
endif


example_programs = [
# [[dir-name], exe-name, [sources], [arguments], [extra_objs]]
  [['dom_build'], 'example', ['main.cc'], [], []],
  [['dom_parse_entities'], 'example', ['main.cc'], [], []],
  [['dom_parser'], 'example', ['main.cc'], [], []],
  [['dom_parser_raw'], 'example', ['main.cc'], [], []],
  [['dom_read_write'], 'example', ['main.cc'],
    ['example.xml', meson.current_build_dir() / 'dom_read_write_example_output.xml'], []],
  [['dom_update_namespace'], 'example', ['main.cc'], [], dom_update_namespace_extra_objs],
  [['dom_xinclude'], 'example', ['main.cc'], [], []],
  [['dom_xpath'], 'example', ['main.cc'], [], []],
  [['dtdvalidation'], 'example', ['main.cc'], [], []],
  [['import_node'], 'example', ['main.cc'], [], []],
  [['sax_exception'], 'example', ['main.cc', 'myparser.cc'], [], []],
  [['sax_parser'], 'example', ['main.cc', 'myparser.cc'], [], []],
  [['sax_parser_build_dom'], 'example', ['main.cc', 'svgparser.cc',
    'svgdocument.cc', 'svgelement.cc'], [], []],
  [['sax_parser_entities'], 'example', ['main.cc', 'myparser.cc'], [], []],
  [['schemavalidation'], 'example', ['main.cc'], [], []],
  [['textreader'], 'example', ['main.cc'], [], []],
]

foreach ex : example_programs
  dir = ''
  foreach dir_part : ex[0]
    dir = dir / dir_part
  endforeach
  ex_name = (dir / ex[1]).underscorify()
  ex_sources = []
  foreach src : ex[2]
    ex_sources += dir / src
  endforeach
  foreach obj : ex[4]
    ex_sources += obj
  endforeach

  exe_file = executable(ex_name, ex_sources,
    dependencies: xmlxx_own_dep,
    implicit_include_directories: false,
    build_by_default: build_examples
  )

  if build_examples
    # Some programs can find their input file(s) only if the current directory,
    # when they are executed, is the program's own source directory.
    # To make these program invocations as consistent as possible, and to avoid
    # having to specify parameters for the programs, the programs are executed
    # from their own source directory.
    #
    # dom_read_write shall write its output file in the build directory.
    # It's necessary to specify parameters when the input file and the output
    # file are located in different directories.

    test(ex_name, exe_file,
      workdir: meson.current_source_dir() / dir,
      args: ex[3],
    )
  endif
endforeach
