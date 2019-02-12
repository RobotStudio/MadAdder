# -*- coding: utf-8 -*-

"""Lambda application to process sending sub-minute events to SNS."""

import re
import time
import json
import threading

import boto3


sns = boto3.client('sns')


def set_interval(rate):
    seconds = re.search('rate\((\d+) seconds*\)', rate).group(1)

    def decorator(function):
        def wrapper(*args, **kwargs):
            stopped = threading.Event()

            def loop():  # executed in another thread
                while not stopped.wait(seconds):  # until stopped
                    function(*args, **kwargs)

            thread = threading.Thread(target=loop)
            thread.daemon = True  # stop if the program exits
            thread.start()
            return stopped
        return wrapper
    return decorator


def send_message(interval, rate):
    return sns.publish(
        TopicArn='{{topic_arn}}',
        Message=json.dumps({
            "default": f"{interval}: {rate}",
        }),
        MessageStructure='json',
        MessageAttributes={

            'cron_interval': {
                'DataType': 'String',
                'StringValue': interval,
            },

            'cron_rate': {
                'DataType': 'String',
                'StringValue': rate,
            },

        },
    )

{% for interval, rate in second_intervals.items() %}
@set_interval("{{rate}}")
def {{interval}}(*args, **kwargs):
    send_message("""{{interval}}""", """{{rate}}""")

{% endfor %}
def handler(event, context):
    time.sleep(59)
