# Mad Adder
AWS cloud scheduler with second-level precision based on Terraform, CloudWatch, Lambda, and SNS.

    +------------+      +----------+      +-------+
    |            |      |          |      |       |
    | CloudWatch |      | Lambda   |      | SNS   |
    |            +----->+ Interval +----->+ cron  |
    |  1 Minute  |      | Notifier |      | Topic |
    | Granularity|      |          |      |       |
    |            |      +----------+      +-------+
    +------------+

Using CloudWatch to trigger Lambda execution at a given intervals, the Lambda app(s) then trigger SNS notifications at second-level granularity.  The SNS topic can then spawn Lambda functions to do your bidding.

## Deployment

1. Configure the `shadowconf.hcl` file in the project root as needed.
2. Execute `shadow fax *.tf.tpl`.
3. Run `terraform init`, `plan`, and `apply` in the project root to create the
   SNS topic.
4. Add the `topic_arn` to the `shadowconf.hcl` file in the project root.
5. Execute `shadow fax terraform.tpl` to generate the `terraform` directory.
6. Change into the `terraform` directory and execute `terraform init`, `plan`,
   and `apply`.
