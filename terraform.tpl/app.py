import re
import time

import boto3


sns = boto3.client('sns')


def set_interval(rate):
    interval = re.search('rate\((.+?) seconds\)', rate).group(1)
    def decorator(function):
        def wrapper(*args, **kwargs):
            stopped = threading.Event()

            def loop(): # executed in another thread
                while not stopped.wait(interval): # until stopped
                    function(*args, **kwargs)

            t = threading.Thread(target=loop)
            t.daemon = True # stop if the program exits
            t.start()
            return stopped
        return wrapper
    return decorator


{% for interval, rate in second_intervals.items() %}
@set_interval("{{rate}}")
def {{interval}}(*args, **kwargs)
    response = sns.publish(
        TopicArn='{{topic_arn}}',
        Message='{{rate}}',
    )
{% endfor %}

def handler(event, context):
    time.sleep(60)
