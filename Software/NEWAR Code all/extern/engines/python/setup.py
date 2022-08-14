#Copyright 2014-2021 MathWorks, Inc.

from distutils.core import setup
from distutils.command.build_py import build_py
import os
import sys
import platform

# UPDATE_IF_PYTHON_VERSION_ADDED_OR_REMOVED : search for this string in codebase 
# when support for a Python version must be added or removed
_supported_versions = ['2.7', '3.7', '3.8', '3.9']
_ver = sys.version_info
_version = '{0}.{1}'.format(_ver[0], _ver[1])
if not _version in _supported_versions:
    raise EnvironmentError('MATLAB Engine for Python supports Python version'
                           ' 2.7, 3.7, 3.8, and 3.9, but your version of Python '
                           'is %s' % _version)
_dist = "dist"
_matlab_package = "matlab"
_engine_package = "engine"
_arch_filename = "_arch.txt"
_py_arch = platform.architecture()
_system = platform.system()
_py_bitness =_py_arch[0]

class BuildEngine(build_py):

    @staticmethod
    def _find_arch(predicate):
        _bin_dir = predicate
        _arch = None
        _archs = ["win64", "glnxa64", "maci64", "win32"]
        _arch_bitness = {"glnxa64": "64bit", "maci64": "64bit",
                         "win32": "32bit", "win64": "64bit"}
        _system_to_arch = {"Windows": "win64", "Linux": "glnxa64", "Darwin": "maci64"}
        _arch_from_system = _system_to_arch[_system]
        if os.access(os.path.join(_bin_dir, _arch_from_system), os.F_OK):
            _arch = _arch_from_system
        if _arch is None:
            raise EnvironmentError('The installation of MATLAB is corrupted.  '
                                   'Please reinstall MATLAB or contact '
                                   'Technical Support for assistance.')

        if _py_bitness != _arch_bitness[_arch]:
            raise EnvironmentError('%s Python does not work with %s MATLAB. '
                                   'Please check your version of Python' %
                                   (_py_bitness, _arch_bitness[_arch]))
        return _arch

    def _generate_arch_file(self, target_dir):
        _arch_file_path = os.path.join(target_dir, _arch_filename)
        _cwd = os.getcwd()
        _parent = os.pardir # '..' for Windows and POSIX
        _bin_dir = os.path.join(_cwd, _parent, _parent, _parent, 'bin')
        _engine_dir = os.path.join(_cwd, _dist, _matlab_package, _engine_package)
        _extern_bin_dir = os.path.join(_cwd, _parent, _parent, _parent, 'extern', 'bin')
        _arch = self._find_arch(_bin_dir)
        _bin_dir = os.path.join(_bin_dir, _arch)
        _engine_dir = os.path.join(_engine_dir, _arch)
        _extern_bin_dir = os.path.join(_extern_bin_dir, _arch)
        try:
            _arch_file = open(_arch_file_path, 'w')
            _arch_file.write(_arch + os.linesep)
            _arch_file.write(_bin_dir + os.linesep)
            _arch_file.write(_engine_dir + os.linesep)
            _arch_file.write(_extern_bin_dir + os.linesep)
            _arch_file.close()
        except IOError:
            raise EnvironmentError('You do not have write permission '
                                   'in %s ' % target_dir)

    def run(self):
        build_py.run(self)
        _target_dir = os.path.join(self.build_lib, _matlab_package, _engine_package)
        self._generate_arch_file(_target_dir)


if __name__ == '__main__':

    setup(
        name="matlabengineforpython",
        version="R2022a",
        description='A module to call MATLAB from Python',
        author='MathWorks',
        url='https://www.mathworks.com/',
        platforms=['Linux', 'Windows', 'MacOS'],
        package_dir={'': 'dist'},
        packages=['matlab','matlab.engine'],
        cmdclass={'build_py': BuildEngine}
    )
