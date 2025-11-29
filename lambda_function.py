"""
Lambda function for AWS Lambda Python 3.14
"""


def lambda_handler(event, _context):
    """
    Default handler for AWS Lambda function

    Args:
        event: Event data that triggered the function
        context: Execution context information

    Returns:
        dict: Lambda function response
    """
    return {
        'statusCode': 200,
        'body': {
            'message': 'Hello from AWS Lambda Python 3.14!',
            'event': event
        }
    }
