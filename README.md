# Enable AWS Security Hub
One of the widgets on the AWS console home is the "Security" widget. I do all my work in one region on the account and want to setup a better security posture. Thought it would be nice to enable this widget. So I used Terraform for all the resources. There is a module from AWS, but I wanted to see the resources indivually and feel this is cleaner.

To enable **AWS Security Hub**, need to first enable **AWS Config** which is states when you click the `Get Started` button in the widget. This codebase sets up and enables **AWS Config**. This it enabled **AWS Security Hub** with the selected subscriptions. There is no alerting on this. I only did this to populate the widget and see things I can fix.

## Usage
Update the setting in [backend.tf](backend.tf) and [variables.tf](variables.tf) to suit your use case (can use ENV variabes.) I do use the variable `project` a lot in my Terraform Configs as it helps to track what resources are to what repo without checking tags.

Once you have the **Backend** and variables worked out. execute the regular Terraform commands:
```
terraform init
terraform plan
terraform apply
```

To remove everything simply use the **destroy**
```
terraform destroy
```

## Notes
I have a couple pieces in the code for multi-region, but need to work that out more. As I only use one region, it's not big priority right now.
