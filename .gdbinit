set history save
handle SIG38 noprint
set follow-fork-mode child
set disassembly-flavor intel

python
from os.path import expanduser, join
sys.path.insert(0, join(expanduser("~"), '.gdb_printers', 'python'))
from libstdcxx.v6.printers import register_libstdcxx_printers
register_libstdcxx_printers (None)
end
