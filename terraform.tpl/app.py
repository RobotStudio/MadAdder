# -*- coding: utf-8 -*-

"""Lambda application to process sending sub-minute events to SNS."""

import re
import time
import json
import threading

import boto3


sns = boto3.client('sns')


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
def {{interval}}():
    rate = """{{rate}}"""
    interval = """{{interval}}"""
    seconds = float(re.search(r'rate\((\d+) seconds*\)', rate).group(1))
    count = 60/seconds

    while count > 0:
        send_message(interval, rate)
        count -= 1
        time.sleep(seconds)

{% endfor %}
def handler(event, context):
    intervals_funcs = [{% for interval, rate in second_intervals.items() %}
        threading.Thread(target={{interval}}),{% endfor %}
    ]

    for thread in intervals_funcs:
        thread.start()

    for thread in intervals_funcs:
        thread.join()
