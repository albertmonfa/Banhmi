__version__ = '1.0'

try:
    import sys, os, traceback
    sys.path.extend([os.path.dirname(__file__)])

    from AppConfig import AppConfig
    from RunnerConfig import RunnerConfig
    from TCPSiteConfig import TCPSiteConfig

    __all__ = [
                'AppConfig',
                'RunnerConfig',
                'TCPSiteConfig'
              ]
except ImportError as e:
    traceback.print_exc()
    sys.exc_info()
    sys.exit(-1)
