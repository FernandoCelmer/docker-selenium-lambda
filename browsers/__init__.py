"""
Browser drivers module for AWS Lambda Selenium.
"""

import os
from typing import Optional, Union

from selenium import webdriver

from .chromium import create_driver as create_chromium_driver
from .firefox import create_driver as create_firefox_driver
from .tor import create_driver as create_tor_driver


def create_driver(
    browser: Optional[str] = None,
) -> Union[webdriver.Chrome, webdriver.Firefox]:
    """
    Create WebDriver instance based on browser type.

    Args:
        browser: Browser type ("chromium", "firefox", or "tor").
                 If None, uses BROWSER environment variable.

    Returns:
        WebDriver instance (Chrome or Firefox).

    Raises:
        ValueError: If browser type is not supported.
    """
    if browser is None:
        browser = os.environ.get("BROWSER", "chromium").lower()

    if browser == "firefox":
        return create_firefox_driver()
    elif browser == "tor":
        return create_tor_driver()
    elif browser == "chromium":
        return create_chromium_driver()
    else:
        raise ValueError(f"Unsupported browser: {browser}")

