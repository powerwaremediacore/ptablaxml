# Resources sources
resfiles = files([
	'window.ui',
])

gresg = find_program('gresg')
resources=custom_target('resources',
	command: [
		gresg,
		'--prefix', '/mx/pwmc/ptablaxml',
		'--file', '@OUTPUT@',
		'@INPUT@'
	],
	output : 'resources.xml',
	input : resfiles
)

glib_compile_resources = find_program ('glib-compile-resources')
resourcesc = custom_target ('resources-c',
	input : resources,
	output : 'resources.c',
	command : [
		glib_compile_resources,
		'--sourcedir='+meson.current_source_dir (),
		'--generate-source',
		'--target', '@OUTPUT@',
		'--internal',
		'@INPUT@'
	],
	depends : resources
)
resourcesh = custom_target ('resources-h',
	input : resources,
	output : 'resources.h',
	command : [
		glib_compile_resources,
		'--sourcedir='+meson.current_source_dir (),
		'--generate-source',
		'--target', '@OUTPUT@',
		'--internal',
		'@INPUT@'
	],
	depends : resources
)

resources_dep = declare_dependency ( sources : [ resourcesc, resourcesh])

valasources = files ([
	'main.vala',
	'window.vala',
	'ptx-reader.vala'
])

sources = files ([
])

inc_libh = include_directories ('.')
inc_libh_dep = declare_dependency (include_directories : inc_libh)
add_project_arguments(['--gresources', resources.full_path (),
                        '--gresourcesdir', meson.current_source_dir ()],
                      language: 'vala')

lib = executable(PROJECT_NAME,
	valasources+sources,
	version : PROJECT_VERSION,
	vala_args : '--target-glib=2.50',
	dependencies : [ gxml, gtk, resources_dep ],
	install : true,
	install_dir : [
		get_option('bindir'),
	])
