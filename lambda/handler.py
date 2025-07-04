import json
import boto3
import uuid
from datetime import datetime
from decimal import Decimal


dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("expenses")


class DecimalEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, Decimal):
            return float(obj)
        return super(DecimalEncoder, self).default(obj)

def lambda_handler(event, context):
    method = event.get("httpMethod", "GET")

    if method == "POST":
        return add_expense(event)
    elif method == "GET":
        return list_expenses()
    else:
        return {
            "statusCode": 405,
            "body": json.dumps({"error": "Method not allowed"})
        }

def add_expense(event):
    try:
        body = json.loads(event["body"])
        expense_id = str(uuid.uuid4())

        item = {
            "id": expense_id,
            "amount": Decimal(str(body.get("amount"))),
            "category": body.get("category"),
            "timestamp": datetime.utcnow().isoformat()
        }

        table.put_item(Item=item)

        return {
            "statusCode": 201,
            "body": json.dumps({"message": "Expense added", "id": expense_id})
        }

    except Exception as e:
        return {
            "statusCode": 400,
            "body": json.dumps({"error": str(e)})
        }

def list_expenses():
    try:
        response = table.scan()
        return {
            "statusCode": 200,
            "body": json.dumps({"expenses": response.get("Items", [])}, cls=DecimalEncoder)
        }
    except Exception as e:
        return {
            "statusCode": 400,
            "body": json.dumps({"error": str(e)})
        }
