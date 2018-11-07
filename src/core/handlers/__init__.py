__version__ = '1.0'

try:
    import sys, os
    sys.path.append(os.path.dirname(__file__))

    from DeleteHandler import DeleteHandler
    from DownloadHandler import DownloadHandler
    from UploadHandler import UploadHandler
    from StatusHandler import StatusHandler
    from HealthcheckHandler import HealthcheckHandler

    __all__ = [
                'DeleteHandler',
                'DownloadHandler',
                'UploadHandler',
                'StatusHandler',
                'HealthcheckHandler',
              ]
except ImportError as e:
    print(e)
    pass
