# Mad Adder
AWS cloud scheduler with second-level precision based on Terraform, CloudWatch, Lambda, and SNS.

    +------------+                        +-------+
    |            |                        |       |
    | CloudWatch |                        | SNS   |
    |   Events   +---+--------------------> cron  |
    | 1+ Minute  |   |                    | Topic |
    | Granularity|   |                    |       |
    |            |   |   +----------+     +---^---+
    +------------+   |   |          |         |
                     |   | Lambda   |         |
                     +---> Seconds  +---------+
                         | Notifier |
                         |          |
                         +----------+

Using CloudWatch to trigger Lambda execution at a given intervals, the Lambda app(s) then trigger SNS notifications at second-level granularity.  The SNS topic can then spawn Lambda functions to do your bidding.
