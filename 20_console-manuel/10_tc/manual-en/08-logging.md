## Overview

In this section, we will be provisioning/configuring the following:
1. EdgeOne to Cloud Log Service Integration
2. Cloud Load Balancer to Cloud Log Service Integration
3. Cloud Virtual Machine to Cloud Log Service Integration
4. Tencent Kubernetes Engine to Cloud Log Service Integration
5. Tencent Database Redis to Cloud Log Service Integration
6. Tencent Database MySQL to Cloud Log Service Integration
7. NAT Gateway to Cloud Log Service
8. Log Aggregation of services on Cloud Log Service

In this section, we'll be creating multiple Log Topics to store and receive the logs of various services we've deployed. We'll be configuring logs for the following services:
- EdgeOne (`frontend`, `app1`)
- Cloud Load Balancer (`app1`, `app2`)
- Cloud Virtual Machine (`frontend`, `app1` via Scaling Group)
- Tencent Kubernetes Engine (`app2`)
- Tencent Database (`mysql`)

## 1. EdgeOne to Cloud Log Service

### Creating Log Topics

Recall that we previously deployed EdgeOne for the following apps:
- `frontend`
- `app1`

We'll now be configuring the Log Topics and Log Collection for the apps we've deployed. Head to the **Cloud Log Service** product page

![](figures/08-logging.png)

A Log Set contains multiple Log Topics that are related to each other. We're going to create a generic Log Topic for now, with the naming convention `<code>-edgeone`

Click on **Create Log Topic**

![](figures/08-logging-1.png)

Note that we will be creating a new Log Set in this step. Select the **Create LogSet** option to create a new log set named as `<code>`
> e.g. `ea54c6`

Fill in the parameters in as shown below

![](figures/08-logging-2.png)

Now that we've configured the Log Push, head to the Search and Analysis page under Cloud Log Service.

Select the Log Topic on the sidebar, in my case it is `ea54c6-eo-frontend`

You should now be able to see the logs produced by EdgeOne in the results.

![](figures/08-logging-3.png)

Now, do the same for `app1` EdgeOne deployments respectively
> e.g. `ea54c6-eo-app1`

Use the same LogSet that we create previously

### Configuring shipping task to push logs to Cloud Log Service

In the previous step, we created the **Log Topic** and **Log Set** for various Edge One logs
> e.g. `ea54c6-eo-app1`, `ea54c6-eo-frontend`, `ea54c6-edgeone`
> Now we've created the Log Topic, we'll configure EdgeOne to push its logs to these Log Topics

Head over to our EdgeOne Site's config page, and select **Real-time Logs** under the **Log Service**

Click on **Create shipping task** to create a new log shipping task

![](figures/08-logging-4.png)

Name the task name according to the following convention `<code>-frontend-acc`
> e.g. `ea54c6-frontend-acc`

![](figures/08-logging-5.png)

For the Delivery Content, select all the Pre-defined fields in the Pre-defined field list

![](figures/08-logging-6.png)

Select CLS as the destination address

![](figures/08-logging-7.png)

Select the appropriate Region, Logset name and Log Topic name

![](figures/08-logging-8.png)
![](figures/08-logging-9.png)

After creating the log delivery task, the below pop-up will be displayed.

Select the **One-click index configuration** option

![](figures/08-logging-10.png)

After which, head to the Log Topic and click on **Edit**

![](figures/08-logging-66.png)

Enable the Full-text Index, and scroll down to click on OK to save the changes

![](figures/08-logging-65.png)

Repeat the same configuration for `app1` as well for the whole of this step to configure log push from EdgeOne to Cloud Log Service
> e.g. `ea54c6-app1-acc`

## 2. Cloud Load Balancer to Cloud Log Service

Recall that we previously deployed Cloud Load Balancer for the following apps:
- `app1`
- `app2`

Now we'll be creating Log Topics for these deployments and configuring the Cloud Load Balancer to push their logs to Cloud Log Service.

### Creating Log Topics

Follow the steps in the first section of this guide to create the respective Log Topics
> e.g. `ea54c6-clb-app1` and `ea54c6-clb-app2`

![](figures/08-logging-11.png)

After we've create the Log Topics, we'll configure the Log Push on the Cloud Load Balancer Page. 

### Configuring Log Push from Cloud Load Balancer

We'll start by configuring the Cloud Load Balancer for `app1`. Head to its Instance details page and click on the Pencil Icon beside the **Cloud Log Service** section under **Access log**

![](figures/08-logging-12.png)

Select the Log Set and Log Topic we created for this Cloud Load Balancer
> e.g. `ea54c6-clb-app1`

Click **OK** to create the Log Push configuration

![](figures/08-logging-13.png)

Note that Log Indexing is not configured by default for Cloud Load Balancer Log Push configurations. 

When we head to the Log Topic's page, we'll see that **Index Status** is **Disabled**

Click on the **Edit** button to edit the index status

![](figures/08-logging-14.png)

Enable the **Index Status** option and **Use recommended configurations** option, then click **OK**

![](figures/08-logging-15.png)

You should see the **Index Status** Enabled now.

Now click on the **Reindexing** button to reindex the Logs

![](figures/08-logging-16.png)

You should see a date range picker pop up, select the date range appropriately and click **Start**

![](figures/08-logging-17.png)

The reindexing process will take some time depending on the size of your logs. 

![](figures/08-logging-18.png)

### View Logs

After your logs have been reindexed, you can head back to the Search and Analysis Page and you will be able to see the reindexed logs

![](figures/08-logging-19.png)

## 3. Cloud Virtual Machine to Cloud Log Service

Recall that we previously deployed Cloud Virtual Machines for the following apps:
- `frontend`
- `app1` (via Scaling Group)

### Creating Log Topics

Let us start by creating the Log Topics for the respective CVM deployments:
> e.g. `ea54c6-cvm-frontend` and `ea54c6-cvm-app1`

![](figures/08-logging-20.png)

### Configuring Log Listener and Tencent Automation Tools (as required)

To capture logs on a CVM Instance, we can install a tool called **LogListener** to capture and send the logs. 

To read more about the LogListener, you can go to the following documentation which explains how you can manually deploy the LogListener on a CVM: 

https://www.tencentcloud.com/document/product/614/17414 

We'll be installing the LogListener using the **Batch deployment of CVM Instances** feature in the Cloud Log Service Console, head to the Machine Group Management Tab and click on **Batch deployment of CVM Instances**

![](figures/08-logging-21.png)

In some deployments, you might see the message, `Auto installation is not supported` and `Install TAT first` as per the example below

![](figures/08-logging-22.png)

This is due to the CVM Instance not having the Tencent Automation Tools (TAT) installed. To install the TAT, you will have to connect to the instance and install it manually. 

https://www.tencentcloud.com/document/product/1147/46042

```bash
# Download and install TAT
wget -O - https://tat-gz-1258344699.cos.ap-guangzhou.myqcloud.com/install_agent.sh | sh
```

After installing the TAT, you will see the CVM that was previously greyed out can be selected now.

Now, key in your **SecretId** and **SecretKey** that you generated in `01-core-resources` and select enter `<code>-cvm-<service>` for the **Machine label**
> Take note to enter your specific code and service you're deploying for in the Machine label field e.g. ea54c6-cvm-frontend

![](figures/08-logging-23.png)

You will see the statuses of the installations for the Log Listener on this page, wait for all the CVM Instances to finish installing their Log Listeners before clicking **Next**

![](figures/08-logging-24.png)

Finally, you will be able to see the machine group configuration page. Click on the Create Machine Group option and enter the following.

When you're done configuring, click **Join** to proceed

![](figures/08-logging-25.png)

You should now be able to see the Machine Group you've just created

![](figures/08-logging-26.png)

### Collection Configuration

We'll now configure the Log Topic to collect the logs from Log Listener. Head to the Log Topics we've created
> e.g. `ea54c6-cvm-frontend` details page

Click on the **Collection Configuration** tab and click **Create**

![](figures/08-logging-27.png)

Select the CVM Product

![](figures/08-logging-28.png)

Select the Machine Group Name we previously configured

![](figures/08-logging-29.png)

Enter the following details in when configuring the Collection Configuration, make sure to select the appropriate **Extraction Mode**. We're using Nginx for this example, so we've selected the Nginx Log Template. 

Take note that you will have to verify the log format by entering an example log record. To ensure that your parsing works as expected, connect to the CVM instance and copy a line of the `/var/log/nginx/access.log` file and paste it in the **Verify the extraction result** field

Below is an example row that you may use (take note that you should ideally use the logs that your system has produced to ensure that they're able to be parsed properly)

```
127.0.0.1 - - [24/Jun/2024:15:21:36 +0800] "GET / HTTP/1.1" 200 644 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.119 Safari/537.36"
```

![](figures/08-logging-30.png)

After clicking **Verify** you should be able to see an example of the **Extraction Result** along with the extracted Keys and Values

Feel free to make any adjustments if your logs are not parsing properly. To proceed to the next step, click on the **Next** button

![](figures/08-logging-31.png)

Enable indexing by clicking on the toggle box of **Index Status** toggle button. Make any relevant changes as required and click on **Submit** to proceed.

![](figures/08-logging-32.png)
![](figures/08-logging-33.png)

Head over to the **Index Configuration** tab and click **Reindexing** to reindex the logs. Similarly, the reindexing will take some time as well.

![](figures/08-logging-34.png)
![](figures/08-logging-35.png)

### View Logs

Head to the Search and Analysis page and you'll be able to see the parsed logs as shown below

![](figures/08-logging-36.png)


## 4. Tencent Kubernetes Engine to Cloud Log Service

Recall that we previously deployed Tencent Kubernetes Engine for the following apps:
- `app2`

### Creating Log Topics

Head to the Cloud Log Service product page and create a new Log Topic with the relevant name
> e.g. `ea54c6-tke-app2`

![](figures/08-logging-37.png)

### Configuring Log Collection

Head to the Tencent Kubernetes Engine product page and select the **Log Collection** tab under **Cluster Ops**

You may need to enable the Log Collection service, click on the **Log Collection** text button

![](figures/08-logging-38.png)

Tick the **Enable log collection** option and click **Confirm**

![](figures/08-logging-39.png)

Click on the Create button to create a new Log collection rule

![](figures/08-logging-40.png)

![](figures/08-logging-41.png)
![](figures/08-logging-42.png)

Select the Extraction Mode as JSON. Click **Done** to proceed

![](figures/08-logging-43.png)

After creating the log collection policy, you should see the following result

![](figures/08-logging-44.png)

After creating the Log Topic configure, enable Indexing

![](figures/08-logging-45.png)

Click on **Edit**

![](figures/08-logging-46.png)

Enable the **Index Status** and click **OK**

![](figures/08-logging-47.png)

After enabling Indexing, head back to the Index Configuration tab and select **Reindexing**.
This process might take some time

![](figures/08-logging-48.png)
![](figures/08-logging-49.png)
![](figures/08-logging-50.png)

## 5. Tencent Database Redis to Cloud Log Service

We've previously also deployed a Redis Cache. However, integrations for Redis to Cloud Log Services are not supported for now.

## 6. Tencent Database MySQL to Cloud Log Service

Recall that we previously deployed MySQL on Tencent Database. In this part, we'll be configuring MySQL.

![](figures/08-logging-51.png)

Head to the Operation Log page and select Log Delivery. Click on the **Authorize now** button to create the roles to enable the push of logs to Cloud Log Service

![](figures/08-logging-52.png)

Click on **Grant** to authorize the role

![](figures/08-logging-53.png)

After granting the relevant permission, you should see the following page on the Tencent DB MySQL Instance. Click on the Pencil Icon beside the Delivery Status

![](figures/08-logging-54.png)

Configure the Slow Log Delivery with the following Log Set and Log Topics. Take note this currently doesn't support pre-created Log Sets and Log Topics, therefore we'll be creating new ones as shown below.
> e.g. `cloud_ea54c6_mysql_topic`

![](figures/08-logging-55.png)

After configuring, you should see the Log Set and Log Topic name on the Log Delivery page as shown below

![](figures/08-logging-56.png)

## 7. NAT Gateway to Cloud Log Service

![](figures/08-logging-58.png)

## 8. Log Aggregation of services on Cloud Log Service

After we've setup all the relevant logging for the various deployments, we're able to see all the logs at the same time by going to the Search and Analysis page

We can select the **Multi-topic** toggle button and select all the topics we would like to view. In the example below, we can see we're able to view all the request associated to the different services we've configured Cloud Log Service for.

![](figures/08-logging-57.png)

### Our Test Scenario

The main object of this log aggregation is to help us identify if the systems that we've setup are working as expected.

For the purpose of this lab, we'll be using the following scenario to test the system and view the respective logs
1. Visit the website at `<code>-frontend.tam-lab.net`
2. Register for a new account
3. Login to the new account

A flow diagram of this sequence can be found below:

![](figures/08-logging-59.svg)

From this we can tell that there are mainly the following entities involved:
- EdgeOne
- Frontend CVM
- App2
- MySQL
- Redis

However, take note that although there are many components in this flow, we might only be able to see some of the components in action as there are limited logging features.
### Executing the Test Scenario

Visit your frontend at `https://<code>-frontend.tam-lab.net` and click on the **Register** button

![](figures/08-logging-59.png)

Enter a username (e.g. `ea54c6-user`) and a password of your choice, remember the password you've used as we'll be logging in later with it. Click **Submit** to register for an account.

![](figures/08-logging-60.png)

You should see the message below **You have registered** when the registration is successful. Next, click on the **Back to Login** button to test the logging in function.

![](figures/08-logging-61.png)

Enter your previously created username and password, and finally click the **Submit** button. You should see a successful 

![](figures/08-logging-63.png)

You should see the message as shown below

![](figures/08-logging-64.png)

### Viewing our Logs

Now, head to our Search and Analysis Page. As mentioned previously, the EdgeOne to Frontend CVM requests due to the caching policies and rules configured on your EdgeOne instance.

We will be focusing on the Browser to App2 and App2 to MySQL request related logs.

Select All logsets and the Frontend, TKE (App2) and MySQL Topics

![](figures/08-logging-67.png)

Now, we need to know what we want to search for. For frontend logs, we can ideally search for them by our IP Address. Run the following command to find your IP Address:

```sh
curl ifconfig.co
```

![](figures/08-logging-68.png)

Change to the Statement mode and  enter your IP Address in the search bar

![](figures/08-logging-72.png)

We should see all the records show up for the Browser to EdgeOne flow

![](figures/08-logging-73.png)

Next, we will additionally search for our username that we used previously. In the example below, I used the username `ea54c6-soonann` so I will search for that as another criteria.

![](figures/08-logging-74.png)

In the output of the search, we can see the following in the respective lines:
1. App2 Storing token generated from Login in Redis (Login storing token)
2. App2 running SELECT on MySQL to get the username that matches `ea54c6-soonann` (Login process)
3. App2 running INSERT into MySQL for the username and password for the user `ea54c6-soonann` (Registration process)
4. App2 running SELECT on MySQL to check if `ea54c6-soonann` is already an existing user
5. EdgeOne receiving a request from IP `118.201.89.106` requesting for the Frontend Web Page

Take note that we do not see the Logs from the following products due to the limitations:
- Frontend CVM (As this was a Cache Hit on the CDN)
- MySQL Logs (As MySQL only supports exporting Slow Logs to CLS)
- Redis Logs (As Redis does not support CLS integration for its logs)
