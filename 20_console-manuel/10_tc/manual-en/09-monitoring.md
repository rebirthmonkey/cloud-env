## Overview

In this section, we will be provisioning/configuring the following:
1. Metrics with Cloud Product Monitoring
2. Metrics with Prometheus
3. Grafana Dashboard
4. Prometheus Alerts
5. Testing Alerts
6. Monitoring Concepts
7. Definining our SLIs and SLOs for app1
8. Monitoring Application
9. Alerting Application


In the previous section, we covered how we can configure the various methods to push and store our logs on Cloud Log Service. In this section, we'll be covering the different monitoring methods available on Tencent Cloud.

##  1. Metrics with Cloud Product Monitoring 

Tencent Cloud provides metrics of its various product offerings. For example, metrics of the CPU/Memory/Network/Storage related resources of Cloud Databases (MySQL, TcaplusDB, Redis, MongoDB), Network Gateways (NAT/VPN), Elastic IP, Object and File Storages etc.

The **Observability Platform** serves as the Hub for monitoring all Cloud Services on Tencent Cloud. If we select the **Cloud Virtual Machine** tab, we're able to see the various metrics of the **Cloud Virtual Machines** we've provisioned.

![](figures/09-monitoring.png)

## 2. Metrics with Prometheus

In the previous step, we saw the different metrics provided by Tencent Cloud Product Monitoring. In this step, we'll see how we can utilise these metrics in Prometheus.

Tencent Cloud provides a Managed Service for Prometheus for businesses that prefer using Prometheus as their metrics collection of choice

In this step, we will look at how we can provision a Managed Prometheus Instance, use the Cloud Product Monitoring Metrics on the Managed Prometheus Instance.

### Provisioning Prometheus Instance

Head to the **Managed Service for Prometheus** product page and click on **Create**

![](figures/09-monitoring-1.png)

Create the instance with the following parameters. Feel free to leave the **Grafana** field empty for now.

![](figures/09-monitoring-2.png)

After creating the Instance, we should see our Instance in the listing, click on the **Associate Cluster** button

![](figures/09-monitoring-3.png)

Before the Prometheus Instance can start collecting data, it needs to have the proper Access Policies setup and initialized.

Click on **Authorize TencentCloud Managed Service for Prometheus to Access TKE** and **Grant** the permissions. Similarly, also click on **Authorize TKE** and **Grant** the permissions.

![](figures/09-monitoring-4.png)

After you've granted the relevant permissions, click on **Next**

![](figures/09-monitoring-5.png)

Now we need to Initialize our instance with the proper resources and plugins to enable it to collect data. Click on the **Initialization** button to proceed.

![](figures/09-monitoring-6.png)

You will see that the Initialization is in progress and can take up to seven mins. Wait for the initialization to complete.

![](figures/09-monitoring-7.png)

### Cloud Product Monitoring Metrics

We will now show how you can integrate the Cloud Product Monitoring Metrics to your Managed Service for Prometheus.

After we've completed the Initialization, navigate to the **Integration Center** and click on **Quick Installation** under the **Cloud Monitor** Application

![](figures/09-monitoring-8.png)

Select the Region you've deployed your resources in and also select the relevant **Tencent Cloud Products** related metrics you would like to integrate to your Prometheus Instance.

For this example, we'll only be using  the CVM's Metrics, tick the check box for the **CVM** product and click on **Save** to proceed

![](figures/09-monitoring-9.png)
![](figures/09-monitoring-10.png)

After saving, you should be able to see the Integration created in the Integration List. Click on the **Metric** button to see the metrics imported to Prometheus

![](figures/09-monitoring-11.png)

Note that this may be shown as empty initially as the metrics take some time to populate

![](figures/09-monitoring-12.png)

### Tencent Kubernetes Engine Metrics

![](figures/09-monitoring-13.png)

Select the our TKE Cluster we provisioned for `app2` and click **OK**

![](figures/09-monitoring-14.png)

After clicking **OK**, we can see our integration setup as shown below. Click on the **Data Collection Configuration**

![](figures/09-monitoring-15.png)

We can now see the various metrics provided by different services within Tencent Kubernetes Engine by clicking the **Metric** text button of the different services

![](figures/09-monitoring-16.png)

![](figures/09-monitoring-17.png)

Once Prometheus is associated with the K8s cluster, Prometheus will automatically collect the indicators of the K8s cluster. These indicators include:
1. `cadvisor`: Container-level metrics such as CPU, Memory, Network, Disk, etc.
2. `eks-network`: Monitors network performance and resource-related indicators of super nodes
3. `kube-proxy`: Monitors the communication and load balancing status of Kubernetes Services deployed on non-super nodes
4. `kubelet`: Monitors the running status and resource status of containers and pods on non-Serverless cluster kubelet nodes
5. `serviceMonitor/kube-system/kube-state-metrics`: Monitors the information and status of resource objects in the cluster
6. `serviceMonitor/kube-system/node-exporter`: Monitors the relevant information and running status of non-Serverless cluster node hosts

In addition to these metrics, you can also define any number of `ServiceMonitors` or `PodMonitors` to collect you application metrics

Click on the **Data Collection Configuration** in your cluster association for Prometheus

![](figures/09-monitoring-18.png)

Select the **Customize Monitoring Configuration**

![](figures/09-monitoring-19.png)

Below is an example of how you can monitor the `app2` Kubernetes `Service` by using this feature.
> You do not have to create this, this is an example

![](figures/09-monitoring-20.png)

### Cloud Virtual Machine Metrics

For Cloud Virtual Machine (CVM) based deployments (e.g Auto Scaling) like `frontend` and `app1`, we can configure **Node Exporter** on the CVM instance to export its metrics through the `/metrics` endpoint

### Node Exporter Metrics

The Node Exporter is a pre-built binary that runs on a system to expose its various metrics with prometheus

To automate the setup of the Node Exporter, add the following lines to the `user_data` of your Auto Scaling Group or Cloud Virtual Machines.

```sh
# Download and set up node_exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz -O /tmp/node_exporter-1.3.1.linux-amd64.tar.gz
tar -xvf /tmp/node_exporter-1.3.1.linux-amd64.tar.gz -C /usr/local/bin/
mv /usr/local/bin/node_exporter-1.3.1.linux-amd64 /usr/local/bin/node_exporter

cat > /etc/systemd/system/node_exporter.service <<EOF
[Unit]
Description=Node Exporter

[Service]
ExecStart=/usr/local/bin/node_exporter/node_exporter
User=root
Restart=always
Type=simple

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable node_exporter.service
systemctl start node_exporter.service
systemctl status node_exporter.service
```

Note that existing instances will not run the newly added `user_data`, you will need to manually connect to the existing instances to execute them or use the Tencent Cloud Automation Tools as shown below:

Click on **Create command** to create a new command

![](figures/09-monitoring-21.png)

Enter the script for Node Exporter Installation in the **Command content** field and click on **OK**

![](figures/09-monitoring-22.png)

Click on **Execute** to run the command

![](figures/09-monitoring-23.png)

Select the instance you wish to run the command on, we're running the command on the `frontend` and `app1` instances.

Click **Execute command** to execute the installation script

![](figures/09-monitoring-24.png)

After executing, we are able to expand the Execution tasks to see the logs of the installation

![](figures/09-monitoring-25.png)

We can now visit the `http://<public-ip>:9100/metrics` endpoint. We will be able to see the metrics that the CVM Instance is exporting.

![](figures/09-monitoring-26.png)

Now that the CVM nodes have the Node Exporter installed, we can collect these Node Exporter metrics with the our Prometheus Instance

Head back to the **Integration Center** and select **Quick Installation** for **CVM Scrape Job**

![](figures/09-monitoring-27.png)

Enter the following for the **Job Configuration** and click **Save**

```
job_name: cvm-node-exporter-ea54c6
metrics_path: /metrics
cvm_sd_configs:
- region: ap-singapore
  ports:
  - 9100
  filters:         
  - name: tag:tamlab
    values: 
    - ea54c6
relabel_configs: 
- source_labels: [__meta_cvm_instance_state]
  regex: RUNNING
  action: keep
- regex: __meta_cvm_tag_(.*)
  replacement: $1
  action: labelmap
- source_labels: [__meta_cvm_region]
  target_label: region
  action: replace 
```

Take note that in the Job Configuration, we're specifying that we want to scrape for the metrics of instances with the tags of key: `tamlab` and  value: `ea54c6`

Feel free to change the configuration as needed to match your tags.

![](figures/09-monitoring-28.png)

After saving, you should be able to see the Integration in the list shown. You will also be able to click the **Metrics** button to see the various metrics being collected

![](figures/09-monitoring-29.png)
![](figures/09-monitoring-30.png)

### Application Metrics

When developing applications, you can choose to instrument your applications with Telemetry libraries which enable the developer to expose application specific metrics to services such as Prometheus.

`app1` has already been instrumented, and we can see this by visiting the endpoint of `app1`
> e.g. `https://ea54c6-app1.tam-lab.xyz/metrics`

![](figures/09-monitoring-31.png)

We can collect these metrics by using **CVM Scrape Job**. Click on **Quick Installation** to create another Installation

![](figures/09-monitoring-32.png)

Below is an example configuration of how you would setup scraping for the metrics of `app1`. Note that it assumes you have tagged your CVMs with the relevant tags.
> e.g. `app1` AS CVMs have been tagged with key: `tamlab-app`, value: `ea54c6-app1`

```
job_name: cvm-app1-ea54c6
metrics_path: /metrics
cvm_sd_configs:
- region: ap-singapore
  ports:
  - 8888
  filters:         
  - name: tag:tamlab-app
    values:
    - ea54c6-app1
relabel_configs: 
- source_labels: [__meta_cvm_instance_state]
  regex: RUNNING
  action: keep
- regex: __meta_cvm_tag_(.*)
  replacement: $1
  action: labelmap
- source_labels: [__meta_cvm_region]
  target_label: region
  action: replace
```

![](figures/09-monitoring-33.png)

You will also be able to view the metrics by clicking the **Metrics** button 

![](figures/09-monitoring-34.png)
![](figures/09-monitoring-35.png)

## 3. Grafana Dashboard

You organisation may prefer to use Grafana due to certain business reasons. In this step, we will be covering how you can provision your own Managed Service for Grafana Instance and connect it to Prometheus

### Provisioning Grafana Instance

Note that Grafana instance are a Monthly subscription based product, therefore take note that you should avoid creating multiple instance if there is already one that you can use for testing purposes.
> Having said that, do not test on crucial instances that handle production monitoring workloads

Head to the **Managed Service for Grafana** tab and click on the **Create** button to create a Grafana Instance.

![](figures/09-monitoring-36.png)

Enter the following parameters and ensure that you give it a secure password as this will be publicly accessible from the internet.

![](figures/09-monitoring-37.png)
![](figures/09-monitoring-38.png)

Now that we've created our Grafana Instance, we can head over to the Prometheus Instance and associate our Grafana Instance with it. Click on the **Associate with TCMG** button

![](figures/09-monitoring-39.png)

Select the Grafana Instance we've provisioned and click **OK**

![](figures/09-monitoring-40.png)

After associating our Grafana Instance with Prometheus, we can head to our Grafana Dashboard by clicking the **Grafana Address**

![](figures/09-monitoring-41.png)

You will need to login to the system by entering the username and password previously configured

![](figures/09-monitoring-42.png)

After Logging in, click on the Settings Icon and select Data Sources.

![](figures/09-monitoring-43.png)

You should see the Prometheus Data Source in the list of Data Sources configured. In the next steps, we will be using this Data Source to create Dashboards

![](figures/09-monitoring-44.png)

### Pre-defined Grafana Dashboards

When using the Managed Service for Prometheus with the Managed Service for Grafana, we're able to install pre-defined Dashboards to view the metrics provided by the Cloud Monitor Integration.

In your Prometheus Instance's detail page, head to the **Data Collection** tab and **Integration Center** sub tab. Select **Dashboard Operation** and click on **Install/Upgrade**

![](figures/09-monitoring-45.png)

After Installing, head back to your Grafana **Search dashboards** page and you should see many pre-defined dashboards for the Cloud Product Monitoring Metrics in the **cloud_monitor** folder.

Recall that in the example for Prometheus, we've only setup Cloud Monitor for CVM Metrics. Click on **CVM** to look at the pre-defined dashboard

![](figures/09-monitoring-46.png)

You should see the different metrics available as shown below

![](figures/09-monitoring-47.png)

### Custom Grafana Dashboards

Grafana also allows us to build our own custom dashboards, should we have the requirement.

Click on **New** dropdown and select **New Dashboard**

![](figures/09-monitoring-48.png)

Save the dashboard by clicking the **Save** icon and name the dashboard appropriately

![](figures/09-monitoring-49.png)
![](figures/09-monitoring-50.png)

Click on **Add a new panel** to create a new chart

![](figures/09-monitoring-51.png)

Select the **Prometheus** Data Source. Grafana comes with a built in Query Builder to help you easily build the queries with the Data in Prometheus.

Below is an example of a query you can build with `app1` collected metrics by Prometheus. Click on **Apply** to save the Chart in the Dashboard

![](figures/09-monitoring-52.png)

Your final dashboard should look something like the Dashboard below

![](figures/09-monitoring-53.png)

## 4. Prometheus Alerts

We're also able to create Alerts with Prometheus, head over to the **Alarm Management** tab and click on **Create Alerting Rule**

![](figures/09-monitoring-54.png)

Create the Alert Rule as show below. Click on **Save** to proceed

![](figures/09-monitoring-55.png)

We can now see the created alert in the Alerting Rule Lists

![](figures/09-monitoring-56.png)

## 5. Testing Alerts

We can also test this alarm by connecting to the `frontend` instance and running the following commands

```bash
sha1sum /dev/zero &
```

![](figures/09-monitoring-57.png)

You should see the CPU Usage start to increase which would in turn trigger the alarm later on

![](figures/09-monitoring-58.png)

When the alarm gets triggered, you will receive an email on the user with the template. The example below is the alarm email for Prometheus Alerts

![](figures/09-monitoring-59.png)

After you have received both emails, kill both of the jobs we started by running the following command

```
# you can use the jobs command to see the id of the two commands you're running in the background
jobs

# you will see the id in the previous step in square brackets [1] and [2]
# run the kill command with the ids
kill %1 %2

# check the jobs again, you will see the background processes have been terminated
jobs
```

![](figures/09-monitoring-60.png)

## 6. Monitoring Concepts

In the starting parts of this section, we've covered how you can use the monitoring platform on Tencent Cloud with Grafana and Prometheus.

In this section we'll be covering the concepts behind monitoring and what are some of the best practices. This part heavily references some Site Reliability Engineering practices that Google adopts to enable us to understand what is wrong with our systems.

> Note that Site Reliability is a entire discipline in and of itself and that we will not be able to cover all elements of it. 

> We will reference some recommended practices indicated in Google's SRE Book, but when implementing it for your organisation, you may want to consider further view points brought up by the book. We've also indicated links to the chapters that the content has been referenced from.

### What Metrics to Monitor?

There are **4 Golden Signals** as described by google in their SRE Book:
1. Latency - How quickly your system responds to requests
2. Traffic - Measure of how much demand is being placed on your system (e.g. RPS)
3. Error - Failed requests or request that don't meet the SLO/SLA
4. Saturation - How much of your total capacity of resource are used
> https://sre.google/sre-book/monitoring-distributed-systems/#the-four-golden-signals

It is said that if you monitor all the 4 Golden Signals and page human when one is problematic, then you would be decently covered by monitoring.

### SLI

Service Level Indicators (SLIs) are the carefully selected quantitative metrics that we're capturing.
> https://sre.google/sre-book/service-level-objectives/

Ideally we won't want to just use all the metrics because we have them. Rather we should be looking at what we think the "users would want services to promised of", below are some examples from the SRE Book:
- Number of successful HTTP requests / total HTTP requests (success rate)
- Number of gRPC calls that completed successfully in < 100 ms / total gRPC requests
- Number of search results that used the entire corpus / total number of search results, including those that degraded gracefully
- Number of “stock check count” requests from product searches that used stock data fresher than 10 minutes / total number of stock check requests
- Number of “good user minutes” according to some extended list of criteria for that metric / total number of user minutes
> https://sre.google/workbook/implementing-slos/#what-to-measure-using-slis

While many numbers can function as an SLI, we generally recommend treating the SLI as the ratio of two numbers: `the number of good events` / `the total number of events`.
> e.g. `Number of successful HTTP requests / total HTTP requests (success rate)` where `successful HTTP request` are good events and and `total HTTP requests` are total number of events

Depending on your service's characteristics (e.g. Request Driven, Pipeline or Storage), there may be different desirable Types of SLIs users might want to have:

| Type of service | Type of SLI  | Description                                                                                                                                                                                                                                                                                                                                                                                                                |
| --------------- | ------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Request-driven  | Availability | The proportion of requests that resulted in a successful response.                                                                                                                                                                                                                                                                                                                                                         |
| Request-driven  | Latency      | The proportion of requests that were faster than some threshold.                                                                                                                                                                                                                                                                                                                                                           |
| Request-driven  | Quality      | If the service degrades gracefully when overloaded or when backends are unavailable, you need to measure the proportion of responses that were served in an undegraded state. For example, if the User Data store is unavailable, the game is still playable but uses generic imagery.                                                                                                                                     |
| Pipeline        | Freshness    | The proportion of the data that was updated more recently than some time threshold. Ideally this metric counts how many times a user accessed the data, so that it most accurately reflects the user experience.                                                                                                                                                                                                           |
| Pipeline        | Correctness  | The proportion of records coming into the pipeline that resulted in the correct value coming out.                                                                                                                                                                                                                                                                                                                          |
| Pipeline        | Coverage     | For batch processing, the proportion of jobs that processed above some target amount of data. For streaming processing, the proportion of incoming records that were successfully processed within some time window.                                                                                                                                                                                                       |
| Storage         | Durability   | The proportion of records written that can be successfully read. Take particular care with durability SLIs: the data that the user wants may be only a small portion of the data that is stored. For example, if you have 1 billion records for the previous 10 years, but the user wants only the records from today (which are unavailable), then they will be unhappy even though almost all of their data is readable. |
> https://sre.google/workbook/implementing-slos/#a-worked-example

### SLO

An SLO is a Service Level Objective: A target value or range of values for a Service Level that is measured by an SLI. 

If the SLI is `success rate of requests`, then the SLO can be something like  `success rate of requests >= 90% over a month`, or in other forms such as `lower bound <= SLI <= upper bound`

A team within an organisation would usually have a certain set of defined SLO that they want to uphold to ensure the quality of the services internally. Part of an SRE's job is to maintain the SLOs, and it is often also said that "One could even claim that without SLOs, there is no need for SREs"
> https://sre.google/workbook/implementing-slos/#why-sres-need-slos

There is no hard and fast rule how to define what is an SLO to your business. However, these SLOs defined often are close to the 4 Golden Signals defined previously.

For Example, Home Depot (a company in America) uses the VALET acronym to represent their SLO needs. VALET stands for 
- Volume (Traffic)
- Availability
- Latency
- Errors
- Tickets
> https://sre.google/workbook/slo-engineering-case-studies/

### Error budgets

When working with SLOs, it is impractical to define an SLO as 100% as it is often not a reasonable and realistic goal due to the nature of technological services.
> https://sre.google/workbook/implementing-slos/#reliability-targets-and-error-budgets

A service may for example have a 99.9% SLO, what this means is that it has 0.1% of possible errors. If we put these into hours, we know can now say that our service needs to be 99.9% reliable over a period of 30 days and that it can have up to (`30 days x 24h x 0.1% = 0.72h = ~43m`) 43 mins of downtime.

We can now see that we have an allowance of 43 mins over 30 days and that we can use in various ways. This 43 mins of downtime is also commonly known as the **Error Budget**

### Alerting on SLOs

Now that we know how SLOs drive the work of SREs, we need to also understand that SREs are humans. Every time the pager goes off, the SRE should be able to react with a sense of urgency. But more than often, they can only react with a sense of urgency a few times a day before becoming fatigued.
> https://sre.google/sre-book/monitoring-distributed-systems/#tying-these-principles-together-nqsJfw

To clear up some terminology, we will now explain some concepts to help ourselves understand the reason behind building the alerts in a certain way:
- `Window` - A Time Period in which we evaluate a metric over (e.g. 15 mins window means the last 15 min of readings of a metric)
- `Burn rate` - Burn rate is how fast, relative to the SLO, the service consumes the error budget
- `Error budget` - The amount of allowable errors (e.g. 1 - SLO)
- `Reset` - The amount of time that alerts need to stop fire after an event has been resolved
- `Page` - Alert/call an engineer on shift to solve the issue
- `Ticket` - A ticket on a ticketing system containing issues of a system
> https://sre.google/workbook/alerting-on-slos/

## 7. Defining our SLIs and SLOs for `app1`

We'll now begin to define the different SLIs and SLOs of `app1`. We will do it by asking ourselves the following questions:

- What are the resources used?
- What are the metrics available for such resources?
- What are the SLIs/SLOs defined?
- Alerting on SLOs

### What are the resources used by `app1`?

`app1` currently uses  the following resources:
1. Cloud Load Balancer (CLB)
2. Cloud Virtual Machines (CVM)

### What are the metrics available for such resources?

To find out what are the metrics that the Cloud Product Monitoring integration imports to our Prometheus instance, we can check the Cloud Product Monitoring product page for CLB and CVM:
- CLB - https://www.tencentcloud.com/document/product/248/10997
- CVM - https://www.tencentcloud.com/document/product/248/6843

### What are the SLIs/SLOs defined?

Since our service is an Request-driven one, we'll aim for SLIs of these types:
- Availability
- Latency
- Quality (Not applicable for our application as we don't have a degraded state)

We can look at these metrics with the following categories as a start:

| Service Type | SLI                                                                                                                                          | SLO                                                            | SLO Metric Name    |
| ------------ | -------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------- | ------------------ |
| Availability | `total failed request (non 5xx requests) / total requests`                                                                                   | 99.9% success                                                  | slo_app1_error_req |
| Latency      | `count of responses with less than 100ms / count of all responses`<br><br>`count of responses with less than 200ms / count of all responses` | 90% of the requests < 100ms<br><br>99% of the requests < 200ms | slo_app1_error_res |

Although the above examples show two possible SLOs, we'll be focusing on the first SLO `slo_app1_error_req` as the Tencent Cloud's Observability Metrics do no provide high enough resolution to give us the required metrics for calculation.

## 8. Monitoring Application

Head to the Grafana Instance we've previously created and create a new dashboard

![](figures/09-monitoring-61.png)

For consistency and a more visually coherent dashboard, we'll be using the following settings for all of our panels:

| Section       | Setting                | Value               |
| ------------- | ---------------------- | ------------------- |
| Panel Options | Transparent Background | Enabled             |
| Legend        | Visibility             | Enabled             |
| Axis          | Scale                  | Logarithmic Base 10 |
| Graph styles  | Fill opacity           | 70                  |
| Graph styles  | Gradient mode          | Opacity             |
| Graph styles  | Stack series           | Normal              |

The next few sections will cover specifics on the queries used to create the Grafana Charts.

### Traffic

This graph shows the average requests per second over multiple time windows, specifically 1 hour and 5 min windows. We'll be using this small and large window strategy to help us visually see the differences between the active and sustained loads

![](figures/09-monitoring-62.png)

The first query averages over a window of 5 mins of the different total requests per sec values

```
avg_over_time(qce_lb_public_totalreq_sum{load_balancer_name="ea54c6-lab"}[5m])
```

The second window does the same but with a 1 hour window

```
avg_over_time(qce_lb_public_totalreq_sum{load_balancer_name="ea54c6-lab"}[1h])
```

### Latency

![](figures/09-monitoring-63.png)

The first query displays the short window of 5 mins for the average response + request times, while the second query shows a longer 1 hour window.

```
avg_over_time(qce_lb_public_rspavg_avg{load_balancer_name="ea54c6-lab"}[5m]) + avg_over_time(qce_lb_public_reqavg_avg{load_balancer_name="ea54c6-lab"}[5m])
```

```
avg_over_time(qce_lb_public_rspavg_avg{load_balancer_name="ea54c6-lab"}[1h]) + avg_over_time(qce_lb_public_reqavg_avg{load_balancer_name="ea54c6-lab"}[1h])
```

### Error

As stated in the SLO section, we noted that we want a 99.9% SLO for our Load Balancer, where only 0.1% of our requests are allowed to fail.

This translates to the following chart with the below queries:

![](figures/09-monitoring-64.png)

In this query, we calculate over a 5 minute window the `total count of successful request / total count of requests`, after which we clamp the values between `0.000001` and `1` to ensure our graph is able to visually display when there are 0% errors.

> We have to clamp because Grafana does not setting 0 as the minimum on the logarithmic scale which means when there is 0 error rate, the line will always be outside of the chart

```
clamp(
    1 - sum_over_time(
	    qce_lb_public_succreq_sum{load_balancer_name="ea54c6-lab"}[5m]
	) / (
        sum_over_time(
	        qce_lb_public_totalreq_sum{load_balancer_name="ea54c6-lab"}[5m]
        ) * 60
    ),
    0.000001,
    1
)
```

We do the same for the 1 hour window

```
clamp(
    1 - sum_over_time(
	    qce_lb_public_succreq_sum{load_balancer_name="ea54c6-lab"}[1h]
	) / (
        sum_over_time(
	        qce_lb_public_totalreq_sum{load_balancer_name="ea54c6-lab"}[1h]
        ) * 60
    ),
    0.000001,
    1
)
```

### Saturation

Next, we monitor the saturation of the network link for the Load Balancer

![](figures/09-monitoring-65.png)

Using this query, we can find the network bandwidth utilised by the Load Balancer

```
qce_lb_public_outtrafficvipratio_max{load_balancer_name="ea54c6-lab"} + qce_lb_public_intrafficvipratio_max{load_balancer_name="ea54c6-lab"}
```


We can also get the Source NAT Port Utilisation metrics of the Load Balancer. The Source Net Address Translation Port Utilisation's calculation is as follows 
`Port utilization = number of concurrent SNAT connections / (number of SNAT IPs * 55,000 * number of real servers)` 
> https://www.tencentcloud.com/document/product/248/10997

When a TCP/UDP Connection is opened, a port is allocated to the connection. These ports are a limiting factor of the number of concurrent connections that can be opened at any given time. The SNAT Port Utilisation metric tells us how much of the total ports we've utilised

![](figures/09-monitoring-66.png)

```
qce_lb_public_concurconnvipratio_max{load_balancer_name="ea54c6-lab"}
```

After the previous steps, you should have the following dashboard as shown below. Take note that you should save the Dashboard to ensure that it persists

![](figures/09-monitoring-67.png)

Your instance may not be receiving traffic right now as there are likely no active users on it. What we can do is to simulate some artificial traffic on the system with the following command:

```sh
ab -n 30000 -c 10 -v debug -f ALL https://ea54c6-app1.tam-lab.net/
```

Let the command run for some time and refresh your Grafana Dashboard after 10 mins, you should see the metrics on the Dashboard change accordingly

![](figures/09-monitoring-68.png)

## 9. Alerting Application

In the previous section `6. Monitoring Concepts`, we talked about how we can Alert on SLOs. In this section, we'll build the respective alerts for the various Dashboards we've built with the Golden Signals.

####  Traffic

The first alert rule that we'll be creating is as follows:

![](figures/09-monitoring-69.png)

```
avg_over_time(qce_lb_public_totalreq_sum{load_balancer_name="ea54c6-lab"}[5m]) > 60 
and 
avg_over_time(qce_lb_public_totalreq_sum{load_balancer_name="ea54c6-lab"}[1h]) > 60
```

This rule will trigger an alarm when the average requests over 5m window and 1h window both goes over 60 (note that 60 is an arbitrary number that can be tweaked to your requirements)

This multi window strategy allows us to alert only when there is both immediate high load and also sustained high load at the same time. However, note that we've indicated the severity of this alert is only considered `warning`, which suggests that this alert should not have paged anyone.

### Latency

For the latency alert, we'll take the same approach with the dual window using the averaged values over time of the two 5m and 1h windows.

In this example, we'll use 1 as the threshold, where 1 represents 1 second.

![](figures/09-monitoring-70.png)

```
avg_over_time(qce_lb_public_rspavg_avg{load_balancer_name="ea54c6-lab"}[5m]) + avg_over_time(qce_lb_public_reqavg_avg{load_balancer_name="ea54c6-lab"}[5m]) > 1
and
avg_over_time(qce_lb_public_rspavg_avg{load_balancer_name="ea54c6-lab"}[1h]) + avg_over_time(qce_lb_public_reqavg_avg{load_balancer_name="ea54c6-lab"}[1h]) > 1
```

### Error

We'll also do the same for the error ratio we've previously created for the dashboard

![](figures/09-monitoring-71.png)

```
clamp(
	1 - sum_over_time(
		qce_lb_public_succreq_sum{load_balancer_name="ea54c6-lab"}[5m]
	) / (
			sum_over_time(
				qce_lb_public_totalreq_sum{load_balancer_name="ea54c6-lab"}[5m]
			) * 60
		),
	0.000001,
	1
) > 0.001
and 
clamp(
	1 - sum_over_time(
		qce_lb_public_succreq_sum{load_balancer_name="ea54c6-lab"}[1h]
	) / (
			sum_over_time(
				qce_lb_public_totalreq_sum{load_balancer_name="ea54c6-lab"}[1h]
			) * 60
		),
	0.000001,
	1
) > 0.001
```

In this example, we're using 0.001 = 0.1% as the threshold before alerting, as our SLO has been set to 99.9% and if we consume more than 0.1% error rate at any given time, we're consuming our Error Budget

### Saturation

Similarly we'll also be taking the dual window approach for detecting saturation

![](figures/09-monitoring-72.png)

```
avg_over_time(qce_lb_public_outtrafficvipratio_max{load_balancer_name="ea54c6-lab"}[5m]) + avg_over_time(qce_lb_public_intrafficvipratio_max{load_balancer_name="ea54c6-lab"}[5m]) > 85
and
avg_over_time(qce_lb_public_outtrafficvipratio_max{load_balancer_name="ea54c6-lab"}[1h]) + avg_over_time(qce_lb_public_intrafficvipratio_max{load_balancer_name="ea54c6-lab"}[1h]) > 85
```

In this example we're taking 85% as the threshold of the max utilisation for a sustained period before alerting.
