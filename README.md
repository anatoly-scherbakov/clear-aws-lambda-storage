# Clear AWS Lambda Storage

## Prerequisites

```bash
sudo apt-get install awscli jq
```

## Usage

```bash
./clear_lambda_storage.sh
# or
AWS_PROFILE=your-profile-name ./clear_lambda_storage.sh
```

## Problem

After happily using AWS Lambda for a while, comes a moment where you stumble across a deployment error sounding something like this:

> Code storage limit exceeded

Reason for this is [75 GB limit](https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-limits.html) on function and layer storage in AWS Lambda.

By default, on every deployment of a Lambda function a new version of it is created, and previous version (together with its deployment package) is preserved.

## Preventing AWS from creating versions per release

If you were using Terraform, you probably used something like this in your Lambda functions:

```hcl
resource "aws_lambda_function" "this" {
  # ...
  publish = true
}
```

Just remove the `publish` key; by default it is `False` so Terraform normally protects you from this problem.

## Cleaning up existing versions

There is a [good write-up from some company named Epsagon](https://epsagon.com/blog/free-lambda-code-storage-exceeded/) about the issue; they also wrote a Python utility to clean existing versions per Lambda function which can be found [on Github](https://github.com/epsagon/clear-lambda-storage/). I decided, however, to write a smaller and simpler tool for the same purpose in Bash; that's how this tool came into existence.

## Literature

- [list-functions](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/lambda/list-functions.html) and [list-versions-by-function](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/lambda/list-versions-by-function.html) @ AWS CLI
- [jq manual](https://stedolan.github.io/jq/manual/)
