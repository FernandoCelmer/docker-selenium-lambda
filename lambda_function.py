"""
Lambda function for AWS Lambda Python 3.14 with Selenium
"""

from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
from tempfile import mkdtemp


def lambda_handler(event, _context):
    """
    Default handler for AWS Lambda function with Selenium

    Args:
        event: Event data that triggered the function
        context: Execution context information

    Returns:
        dict: Lambda function response
    """
    options = webdriver.ChromeOptions()
    service = webdriver.ChromeService("/opt/chromedriver")

    options.binary_location = '/opt/chrome/chrome'
    options.add_argument("--headless=new")
    options.add_argument('--no-sandbox')
    options.add_argument("--disable-gpu")
    options.add_argument("--window-size=1280,1696")
    options.add_argument("--single-process")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--disable-dev-tools")
    options.add_argument("--no-zygote")
    options.add_argument(f"--user-data-dir={mkdtemp()}")
    options.add_argument(f"--data-path={mkdtemp()}")
    options.add_argument(f"--disk-cache-dir={mkdtemp()}")
    options.add_argument("--remote-debugging-port=9222")

    driver = webdriver.Chrome(options=options, service=service)
    driver.set_page_load_timeout(30)
    driver.implicitly_wait(10)
    driver.get('https://github.com/FernandoCelmer/docker-selenium-lambda')

    title = driver.title
    driver.quit()

    return {
        'statusCode': 200,
        'body': {
            'message': 'Selenium test successful',
            'page_title': title,
            'event': event
        }
    }
