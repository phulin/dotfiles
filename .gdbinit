set history save
handle SIG38 noprint
set follow-fork-mode child

python
#sys.path.insert(0, '/home/phulin/.gdb_printers/4.8.2-ubuntu')
#from libstdcxx.v6.printers import register_libstdcxx_printers
#register_libstdcxx_printers (None)
end
