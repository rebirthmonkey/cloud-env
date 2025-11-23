## Overview

In this section, we will be provisioning/configuring the following:
1. Creating Edge One Site
2. Configuring Edge One Site
3. Configuring HTTPS on Edge One Site
4. Adding Security Group to CVM
5. Testing Edge One Site

In this section, we'll be using Edge One to improve the speed of our frontend application deployed in `02-frontend`

Edge one has both **Global Acceleration** and **Content Delivery Network** capabilities. In this section, we'll only be covering the **Content Delivery Network** feature 

## 1. Creating Edge One Site

Head to the **Edge One** Product page

![](figures/07-cdn.png)

Click on the **Add site** button

![](figures/07-cdn-1.png)

Enter the domain that you're using to deploy this lab
> e.g. `tamlab.xyz`

![](figures/07-cdn-2.png)

Select the appropriate plan for your use case and click on **Next**

![](figures/07-cdn-3.png)
![](figures/07-cdn-4.png)

Select the **Region** that you're deploying your resource in.

For the **Access Mode**, select the **CNAME Access** Mode.

Click on **Next** to proceed.

![](figures/07-cdn-5.png)

Verify the ownership of your domain by creating the CNAME Record

![](figures/07-cdn-6.png)
![](figures/07-cdn-7.png)

Click on **Complete** to finish the configuration

![](figures/07-cdn-8.png)

## 2. Configuring Edge One Site

Now we will be configuring our newly created Edge One site to accelerate the frontend we deployed on `02-frontend`

Click on **Add domain name** to add a new domain

![](figures/07-cdn-9.png)

We'll create an Origin Group, click on **Create origin group**

![](figures/07-cdn-10.png)

Add the domain we've previously configured `<code>-frontend-<region>.<your-domain>.<tld>` to the Origin Group
> e.g. `ea54c6-frontend-ap-singapore.tamlab.xyz`

![](figures/07-cdn-11.png)
![](figures/07-cdn-12.png)
![](figures/07-cdn-13.png)

Set the Origin Protocol as HTTPS and set the Origin port to 443. Click **Next** to proceed

![](figures/07-cdn-14.png)

For the recommended configurations, select **website acceleration**. Click **Next** to proceed to the last step

![](figures/07-cdn-15.png)

In this last step, you will need to configure a CNAME record for the domain we've just registered.

![](figures/07-cdn-16.png)

Head to your DNS Provider's page to create the CNAME record. If you've follow section `02-frontend`, the record would already be there, simply modify it to the desired result above.

![](figures/07-cdn-17.png)

After editing/creating the CNAME Record, click on **Complete**

![](figures/07-cdn-16.png)

The creation process will take some time

![](figures/07-cdn-19.png)

## 3. Configuring HTTPS on Edge One Site

After the Status shows **Activated**, click on the **Edit** button under the HTTPS certificate column

![](figures/07-cdn-20.png)

Select **Free certificate** option and click **OK**

![](figures/07-cdn-21.png)

Similarly, the configuration will also take some time to take effect and the **Status** will be shown as **Activated**

![](figures/07-cdn-22.png)

## 4. Adding Security Group to CVM

In this step, we'll create a new Security Group to add to the CVM that our `02-frontend` Web App is running on.

![](figures/07-cdn-23.png)
![](figures/07-cdn-24.png)

If you're using an Auto Scaling Group deployment for `02-frontend`, you will need to edit its Launch Config to add the Security Group.

But if you're using a CVM based deployment, click into the CVM's details and select its Security Groups

![](figures/07-cdn-25.png)

Add the newly created Security Group and click **OK**

![](figures/07-cdn-26.png)

## 5. Testing Edge One Site

You should now be able to access the domain at `<code>-frontend.<your-domain>.<tld>`

![](figures/07-cdn-27.png)

Lets conduct a quick test to see EO's benefits in loading times.
Open your Browser's Developer console by pressing `F12` and refresh the page after

![](figures/07-cdn-28.png)

We can see that the load time of the page from EO is `280ms`

Lets now try to access the site directly by accessing `<code>-frontend-<region>.<your-domain>.<tld>`

We can see that the site takes significantly longer to load at `1.77s`

![](figures/07-cdn-29.png)


