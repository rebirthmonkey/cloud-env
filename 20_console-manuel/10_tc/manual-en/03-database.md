## Overview

In this section, we will be provisioning/configuring the following:
1. Provisioning MySQL
2. Configuring Private DNS for MySQL
3. Seeding MySQL
4. Provisioning Redis
5. Configuring Private DNS for Redis
6. Seeding Redis

Our main goal in this section is to deploy a MySQL and Redis Instance. To make them straight forward to find on the Private VPC, we will also be creating Private Domain records to reference the MySQL and Redis Instances. 

Finally, we will also be seeding the database/cache with the appropriate data that we'll be using for `app1` and `app2` in the later parts of this lab.

## 1. Provision MySQL

Head over to the **TencentDB for MySQL** Product Page and select **Instance List** under the **MySQL** Dropdown

![](figures/03-database.png)
![](figures/03-database-1.png)

Configure your basic configuration

| Param        | Value                                        |
| ------------ | -------------------------------------------- |
| Billing Mode | Pay as You go                                |
| Region       | Singapore                                    |
| Engine       | InnoDB                                       |
| Architecture | Two-Node                                     |
| Source AZ    | Singapore Zone 2                             |
| Replica AZ   | Singapore Zone 1                             |
| <br>Instance | Type: General<br>vCPU: 1-core<br>MEM: 2000MB |

![](figures/03-database-2.png)
![](figures/03-database-3.png)

Configure the Network and Database settings. For the purpose of this lab's deployment, we'll be setting the password to `P@ssw0rd`

![](figures/03-database-4.png)
![](figures/03-database-5.png)

Check that the configuration is correct before clicking the **Buy Now** button

![](figures/03-database-6.png)

You should see the database in the **Instance List** section.
Take note of the **Private IP Address** as we will be using it in the next step

![](figures/03-database-7.png)

## 2. Configuring Private DNS for MySQL

In this step, we will be creating a Private DNS Record for the MySQL Database.
Head over to the **Private DNS** Product Page and select **Private Domain List** Tab.

Click on the Private Domain we created previously

![](figures/03-database-8.png)

Click on the **Create Record** button

![](figures/03-database-9.png)

Fill in the new fields with the following values as show below:
- Host: `mysql.internal`
- Record Type: `A`
- Record Value: `<mysql-private-ip>`

![](figures/03-database-10.png)
![](figures/03-database-11.png)

We can test the record we've just created by running the `dig` command in the CVM we created in `02-frontend-cvm`

```bash
# mysql.internal.<your-domain>.<tld>
dig mysql.internal.tamlab.xyz
```

![](figures/03-database-12.png)

## 3. Seeding MySQL

 On the MySQL - Instance List Page, click on the **Log In** button
 
 ![](figures/03-database-13.png)
 
Enter the following credentials and login
- Account: `root`
- Password: `P@ssw0rd`

![](figures/03-database-14.png)

 After logging in, navigate to the **SQL Window** Tab

![](figures/03-database-15.png)

Copy the queries below and paste them into the Web Console, then press the **Execute** button

```sql
CREATE DATABASE IF NOT EXISTS `app1`;
USE `app1`;

DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
`id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
`instanceID` varchar(32) DEFAULT NULL,
`name` varchar(45) NOT NULL,
`status` int(1) DEFAULT 1 COMMENT '1:可用，0:不可用',
`nickname` varchar(30) NOT NULL,
`password` varchar(255) NOT NULL,
`email` varchar(256) NOT NULL,
`phone` varchar(20) DEFAULT NULL,
`isAdmin` tinyint(1) unsigned NOT NULL DEFAULT 0 COMMENT '1: administrator\\\\n0: non-administrator',
`extendShadow` longtext DEFAULT NULL,
`loginedAt` timestamp NULL DEFAULT NULL COMMENT 'last login time',
`createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
`updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
PRIMARY KEY (`id`),
UNIQUE KEY `idx_name` (`name`),
UNIQUE KEY `instanceID_UNIQUE` (`instanceID`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8;

LOCK TABLES `user` WRITE;
INSERT INTO `user` VALUES (1,'user','admin',1,'admin','P@ssw0rd','admin@foxmail.com','1812884xxxx',1,'{}',now(),'2021-05-27 10:01:40','2021-05-05 21:13:14');
UNLOCK TABLES;

CREATE DATABASE IF NOT EXISTS `app2`;
USE `app2`;

DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
`id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
`instanceID` varchar(32) DEFAULT NULL,
`name` varchar(45) NOT NULL,
`status` int(1) DEFAULT 1 COMMENT '1:可用，0:不可用',
`nickname` varchar(30) NOT NULL,
`password` varchar(255) NOT NULL,
`email` varchar(256) NOT NULL,
`phone` varchar(20) DEFAULT NULL,
`isAdmin` tinyint(1) unsigned NOT NULL DEFAULT 0 COMMENT '1: administrator\\\\n0: non-administrator',
`extendShadow` longtext DEFAULT NULL,
`loginedAt` timestamp NULL DEFAULT NULL COMMENT 'last login time',
`createdAt` timestamp NOT NULL DEFAULT current_timestamp(),
`updatedAt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
PRIMARY KEY (`id`),
UNIQUE KEY `idx_name` (`name`),
UNIQUE KEY `instanceID_UNIQUE` (`instanceID`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8;

LOCK TABLES `user` WRITE;
INSERT INTO `user` VALUES (1,'user','admin',1,'admin','P@ssw0rd','admin@foxmail.com','1812884xxxx',1,'{}',now(),'2021-05-27 10:01:40','2021-05-05 21:13:14');
UNLOCK TABLES;
```


![](figures/03-database-16.png)

After executing the queries, you should see the results below.

![](figures/03-database-17.png)

## 4. Provisioning Redis

Navigate to the Redis - Instance List Page and click on **Create instance**

![](figures/03-database-18.png)

| Params             | Value                    |
| ------------------ | ------------------------ |
| Billing Mode       | Pay as You Go            |
| Region             | Singapore                |
| Compatible Version | 5.0                      |
| Architecture       | Standard Architecture    |
| Memory             | 1GB                      |
| Replica Quantity   | 2 (1 master, 2 replicas) |
| AZ                 | Multi-AZ Deployment      |

![](figures/03-database-19.png)
![](figures/03-database-20.png)

Set the password to `P@ssw0rd`

![](figures/03-database-21.png)

You should see the Redis instance being created in the Instance List Tab

![](figures/03-database-22.png)

Take note of the Private IP Address of the Redis Instance after it has been created as we will need it in the next step.

In my demo deployment, we can see the Private IP is `10.0.1.8`

![](figures/03-database-23.png)

## 5. Configuring Private DNS for Redis

Head over to the **Private Domain** Page and select the previously created Private Domain

![](figures/03-database-24.png)

We can now add another record for the Redis Cache as well. Click on the **Add Record** Button

![](figures/03-database-25.png)

Key in the relevant fields:
- Host: `redis.internal`
- Record Type: `A`
- Record Value: `<redis-private-ip>`

Save the record by clicking on the **Save** button

![](figures/03-database-26.png)

We should now see the record we've just created in the listing

![](figures/03-database-27.png)

We can test the record we've just created by running the `dig` command in the CVM we created in `02-frontend-cvm`

```bash
# redis.internal.<your-domain>.<tld>
dig redis.internal.tamlab.xyz
```

![](figures/03-database-28.png)

## 6. Seeding Redis

Click on the **Log In** button to login to the Redis Instance

![](figures/03-database-29.png)

Enter the `P@ssw0rd` in the Password field

![](figures/03-database-30.png)

After logging in, navigate to the **Command Line** Page

![](figures/03-database-31.png)

Execute the following commands line by line with the **Execute** button, you should see a result below when you're done

```redis
select 0
```

```redis
sadd groupset group1 group2 group3
```

```redis
smembers groupset
```

![](figures/03-database-32.png)

