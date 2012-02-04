python
import sys
sys.path.insert(0, '/home/dskut/packages/gdb_pretty_printer')

from libstdcxx.v6.printers import register_libstdcxx_printers
from stlport.printers import register_stlport_printers
from arcadia.arcgdb import reg

register_libstdcxx_printers (None)
register_stlport_printers (None)
reg()
end
