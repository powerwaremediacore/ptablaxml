project('ptablaxml', [ 'vala', 'c'], version : '0.2.0')

PROJECT_NAME = 'ptablaxml'
API_VERSION = '0'
PROJECT_VERSION = '0.2.0'
VERSIONED_PROJECT_NAME = PROJECT_NAME+'-'+API_VERSION
CAMEL_CASE_NAME = 'Ptx'
VERSIONED_CAMEL_CASE_NAME = CAMEL_CASE_NAME +'-'+ API_VERSION

gxml = dependency('gxml-0.16')
gtk = dependency('gtk+-3.0')

VALADEPS = 'gxml-0.16'
PCDEPS = 'gxml-0.16'

inc_rooth = include_directories ('.')
inc_rooth_dep = declare_dependency (include_directories : inc_rooth)

#subdir('po')
subdir('src')
#subdir('data')
#subdir('docs')
#subdir('tests')
