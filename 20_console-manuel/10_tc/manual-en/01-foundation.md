## Overview

In this section, we will be provisioning/configuring the following:
1. Project
2. Virtual Private Cloud
3. Security Group
4. SSH Key
5. Cloud Object Storage Bucket
6. API Access Key
7. Public Domain DNS
8. Private Domain DNS

In this section, we aim to create certain core resources that will be used regularly throughout the later sections of this lab.

## 1. Project

Before we start creating resources, we want to ensure that we tag and assign the resources to the proper projects when creating them.

On the navigation bar, click on **Products** and select **Account Centre** under the **Cloudproduct** section.

![](figures/01-foundation.png)

Click on the **Create** button to create a new Project

![](figures/01-foundation-1.png)

Fill in the name for your **Project**, for the purpose of this deployment, you may follow the convention of `<code>-lab`

Click on the **Submit** buton when you're done to create the Project

![](figures/01-foundation-2.png)

## 2. Virtual Private Cloud

Virtual Private Cloud (VPCs) and Subnets are the means of connectivity between the different resources we provision on Tencent Cloud.

Before we provision the other resources, we will first provision the Network that meets our organisational needs.

Select the **Products** tab on the navigation bar, next click on the **Virtual Private Cloud** product in the **Networking** section

![](figures/01-foundation-3.png)

Click on the **Create** button

![](figures/01-foundation-4.png)

Below are some of the parameters associated with VPCs and Subnets provisioning:

| Parameter                     | Description                                                                                                                                                                |
| ----------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| VPC Name                      | It is recommended that you name the VPC appropriately as multiple VPCs could possibly have the same name, possibly causing confusions like deletion of the wrong resource. |
| VPC CIDR                      | For the purpose of this demo, we've set the CIDR to `10.0.0.0/16`, this would usually be set to the customer's network conventions                                         |
| Subnet CIDR                   | When creating a VPC in the Web Console, you must create at least one subnet in the VPC, we've setup the CIDR range to be `10.0.1.0/24` for the purpose of this demo        |
| Subnet Availability Zone (AZ) | When creating a Subnet, you need to select an AZ that resource placed in the Subnet will be provisioned in<br>                                                             |

Fill in the required fields and create the VPC and Subnet.

Below are the naming conventions we'll follow
- VPC: `<code>-lab-vpc-<country-code>`
- Subnet: `<code>-lab-sn-<country-code>z<az-no>`

![](figures/01-foundation-5.png)
![](figures/01-foundation-6.png)

After creating the VPC(s), head over to the **Subnets Tab**. You should already see the Subnet that we previously created in **Singapore AZ 1**.

We'll now be creating the Subnets in **Availability Zone 2, 3 and 4**.

Click on the **Create** button to create the VPC

![](figures/01-foundation-7.png)

Name the other Subnets appropriately, with each subnet in different AZ(s)

![](figures/01-foundation-8.png)

## 3. Security Group

Security Groups protect the resources their assigned to, only allowing the IPs or Resources stated in its Allow List to access them, and denying the resources stated in its Deny List.

![](figures/01-foundation-9.png)

Create a Security Group with the custom template

![](figures/01-foundation-10.png)
![](figures/01-foundation-11.png)
### Adding Rules

After creating your Security Group, add the relevant rules to allow specific traffic to your resources

![](figures/01-foundation-12.png)

#### Inbound Rules

In the example below, we'll be adding some common External and Internal IPs into the Allow List of the Inbound Rules.

```bash
# Our VPC subnet's IP
10.0.0.0/16
```

![](figures/01-foundation-13.png)
![](figures/01-foundation-14.png)

Besides the VPC's IP CIDR, you should also add your current IP Address into the range to allow only traffic from you to access the system.

To find out your Public IP Address, you can run the following command on your terminal:

```bash
curl ifconfig.co
xxx.xxx.xxx.xxx # Your Public IP
```

After finding out your Public IP, you can add it to the Allow List

![](figures/01-foundation-15.png)

#### Outbound Rules

For the purpose of this deployment, we will allow all outbound traffic for our Security Group

![](figures/01-foundation-16.png)
![](figures/01-foundation-17.png)

## 4. Public Domain DNS



## 5. Private Domain DNS

When designing an Architecture with a Database, it is common that the Database is only reachable within the Private Network and not publicly exposed to the internet.

Even when the database is not publicly exposed, it is a good practice to access it via an assigned sub domain name rather than directly by its IP. This enables us to easily switch the underlying instance without the need of changing the configuration of associated applications that connect to it.

To create a internally resolvable hostname in the VPC, we will need to create a Private Domain. Head over to the **Private Domain** Product Page and select the **Private Domain List** on the Sidebar.

![](figures/01-foundation-18.png)

Click on the **Create Private Domain** button to create a new Private Domain

![](figures/01-foundation-19.png)

When creating a Private Domain for private hostname resolution, it is also a good practice to create Private Domain of a Public Domain you own.

This enables your organisation to dictate the publicly resolvable subdomains and the ones that are only privately resolvable within the VPC:
- `mysql.internal.tamlab.xyz` - The convention may be `*.internal.tamlab.xyz` is only internally resolvable within the VPC
- `frontend.tamlab.xyz` - Since `frontend.tamlab.xyz` is not part of the subdomain `*.internal.tamlab.xyz`, it is assumed to be publicly resolvable

Furthemore, we are able to choose the VPCs that are able to resolve the Private Domain we're creating. For this lab deployment, we'll select the previously created VPC.

![](figures/01-foundation-20.png)

We can now see the Private zone we've just created in the Private Domain List

![](figures/01-foundation-21.png)
## 6. SSH Key

In this step, we'll create an SSH Key which will be use to log into systems we'll setup later.

Navigate to the **SSH Key Tab** and click on the **New** button

![](figures/01-foundation-22.png)
![](figures/01-foundation-23.png)

After clicking **OK**, a file containing the **SSH Key Pair's** Private key will be downloaded.

Take note that you shouldn't share this file, and should treat its contents as if it was a password to an important account.

## 7. Cloud Object Storage Bucket

In this lab, we will be using various artifacts that we've built locally to deploy certain services (e.g config files and binary executables).

For the purpose of this lab, we've decide to use a Cloud Object Storage (COS) Bucket. In this step, we will be creating one that we will be using in the later parts of the lab. 

To create a COS Bucket, head to the **Cloud Object Storage** Product page and click on the **Bucket List** Tab

![](figures/01-foundation-24.png)

Click on **Create Bucket**

![](figures/01-foundation-25.png)

Create the bucket with the prefix name `<code>-lab`
You may also refer to the other configuration below.

![](figures/01-foundation-26.png)
![](figures/01-foundation-27.png)
![](figures/01-foundation-28.png)

You have now successfully created the COS Bucket.

![](figures/01-foundation-29.png)
![](figures/01-foundation-30.png)

## 8. API Access Key

In this step, we'll create an API Access Key. One common use of an API Access Key is to upload files to COS Buckets using the command line utility `coscmd`

Navigate to the **Cloud Access Management** Product page

![](figures/01-foundation-31.png)

Click on **Create Key** to create a new API Key

![](figures/01-foundation-32.png)

You will be presented with a screen that shows you your API Key and an option to download as a CSV file or Copy it onto your clipboard.

For now, download the the as a CSV File by clicking the **Download CSV File** Text button.

![](figures/01-foundation-33.png)

