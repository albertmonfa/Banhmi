__version__ = '1.0'

try:
    import sys, os, traceback
    sys.path.extend([os.path.dirname(__file__)])

    from ObjectBase import  ObjectBase
    from Bootstrap import Bootstrap
    from GlobalRegistry import GlobalRegistry
    from Logging import Logging

    __all__ = [
                'ObjectBase',
                'GlobalRegistry',
                'Logging',
                'Bootstrap'
              ]
except ImportError as e:
    traceback.print_exc()
    sys.exc_info()
    sys.exit(-1)
