# mytfrepo
Build AWS web app running apache web server.


Builds Following Services

    VPC
    Ineternget Gateway
    Public Subnet (for load balancers)
    Private Subnet (for web server, other services)
    Nat Gateway
    NACLs
    Security Groups
    Classic Load Banacers
    Launch Configuriguration
    Auto Scaling Group
    
    To Run this
    Create "terraform.tfvars" with following variables
      access_key = "YourAccess Key"
      secret_key = "YoourSecret Key"
      region     = "Your Region"
      key_name = "Your EC2 Key Name"
      ip_range = "Your Public IP"

if you have already setup your aws profile for cli then remove access key and secret key from variables.

