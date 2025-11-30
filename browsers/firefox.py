"""
Firefox browser configuration for AWS Lambda.
"""

import os
from tempfile import mkdtemp

from selenium import webdriver
from selenium.webdriver.firefox.options import Options as FirefoxOptions
from selenium.webdriver.firefox.service import Service as FirefoxService


def create_driver() -> webdriver.Firefox:
    """
    Create and configure Firefox WebDriver for AWS Lambda.

    Returns:
        webdriver.Firefox: Configured Firefox WebDriver instance.
    """
    profile_dir = mkdtemp()
    os.environ["TMPDIR"] = profile_dir
    os.environ["MOZ_HEADLESS"] = "1"
    os.environ["MOZ_HEADLESS_WIDTH"] = "1280"
    os.environ["MOZ_HEADLESS_HEIGHT"] = "1696"

    options = FirefoxOptions()
    service = FirefoxService(
        "/opt/geckodriver/geckodriver", log_path=os.devnull
    )

    options.binary_location = "/opt/firefox/firefox"
    options.add_argument("--headless")
    options.add_argument("--width=1280")
    options.add_argument("--height=1696")
    options.add_argument("--no-remote")
    options.add_argument("--disable-gpu")

    options.set_preference("dom.ipc.processCount", 1)
    options.set_preference("browser.cache.disk.enable", False)
    options.set_preference("browser.cache.memory.enable", False)
    options.set_preference("browser.cache.offline.enable", False)
    options.set_preference("network.http.use-cache", False)
    options.set_preference("media.navigator.streams.fake", True)
    options.set_preference("media.navigator.permission.disabled", True)
    options.set_preference("dom.webnotifications.enabled", False)
    options.set_preference("dom.push.enabled", False)
    options.set_preference("toolkit.telemetry.enabled", False)
    options.set_preference("browser.safebrowsing.enabled", False)
    options.set_preference("browser.safebrowsing.malware.enabled", False)
    options.set_preference("browser.download.folderList", 2)
    options.set_preference("browser.download.manager.showWhenStarting", False)
    options.set_preference("browser.download.dir", profile_dir)

    return webdriver.Firefox(options=options, service=service)
