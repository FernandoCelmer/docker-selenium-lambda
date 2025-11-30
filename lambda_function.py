"""
Lambda function for AWS Lambda Python 3.14 with Selenium.
"""

import os
from typing import Any, Dict

from browsers import create_driver


def lambda_handler(event: Dict[str, Any], _context: Any) -> Dict[str, Any]:
    """
    Default handler for AWS Lambda function with Selenium.

    Args:
        event: Event data that triggered the function.
        _context: Execution context information.

    Returns:
        dict: Lambda function response with status code and body.
    """
    browser = os.environ.get("BROWSER", "chromium").lower()

    driver = create_driver(browser)

    driver.set_page_load_timeout(30)
    driver.implicitly_wait(10)
    driver.get('https://github.com/FernandoCelmer/docker-selenium-lambda')

    title = driver.title
    driver.quit()

    return {
        "statusCode": 200,
        "body": {
            "message": "Selenium test successful",
            "browser": browser,
            "page_title": title,
            "event": event,
        },
    }
