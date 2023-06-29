# Terraform import for qumulo
## Description
This project will create a terraform `imports.tf` file which contains all wished qumulo configuration, ready to be imported to terraform.

The script `qumulo-import.sh` will lookup all qumulo internal IDs for the desired qumulo api-resource. It then generates the `imports.tf` file which will look like this:
```
import {
    to = qumulo_nfs_export.qumulo_nfs_export_ID
    id = ID
}
...
```

Afterwards one can simply use the file to generate terraform code and to import exisitng qumulo configuration into the terraform state.

# Usage
## Requirements
- Terraform v1.5 or higher.
- jq
- curl

## Configure Terraform Provider
### Example (provider.tf)
```
provider "qumulo" {
    host = "myqumuloclusterhost"
    password = "mypassword"
    port = 8000
    username = "myusername"
}

terraform {
  required_providers {
    qumulo = {
      source = "Qumulo/qumulo"
      version = ">= 0.1.1"    
    }
  }
}
```
## Install Qumulo Provider
```
$ terraform init
```

## Execute script
### Example
```
$ bash qumulo-import.sh
http/s proxy environment variables set for curl? (y/n): y
Please enter Qumulo Cluster DNS-Name: my-cool-qumulocluster.intern.de
Please enter Qumulo API-Username: my-api-user
Please enter the Password: 
Please enter Qumulo API Resource-URI which you want to import: /v2/nfs/exports/
Please enter the target qumulo terraform resource (eg.: qumulo_nfs_export): qumulo_nfs_export
```
## Generate Terraform Configuration
```
$ terraform plan -generate-config-out=generated.tf
```
## Apply import to terrafrom state
```
$ terraform apply
```
# Note
This project currently does not support terraform `for_each` iteration. (Terraform iteration creates indecies within the terrafrom state. The imported resources will be overwritten if, terraform tries to manage the imported resources with a resource, that is managed by a for_each loop.)