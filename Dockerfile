# Base Dockerfile for AWS Lambda Python 3.14
FROM public.ecr.aws/lambda/python:3.14

# Set working directory
WORKDIR ${LAMBDA_TASK_ROOT}

# Copy dependencies file first (cache layer)
COPY requirements.txt ${LAMBDA_TASK_ROOT}/

# Install Python dependencies
RUN pip install --no-cache-dir --root-user-action=ignore --upgrade pip && \
    pip install --no-cache-dir --root-user-action=ignore -r requirements.txt

# Copy Lambda function code
COPY lambda_function.py ${LAMBDA_TASK_ROOT}/

# Set Lambda function handler
# Format: file.function
CMD ["lambda_function.lambda_handler"]
