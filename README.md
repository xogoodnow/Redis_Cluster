
<div align="center">
    <h1>Production Ready Redis Cluster</h1>
    <i>A Redis-cluster implementation for production use</i>

</div>

### Components Used

| Name:Version            | Documentation                                                                                     | Purpose                                 | Alternatives                       | Advantages                                                                                                                                                                              |
|-------------------------|---------------------------------------------------------------------------------------------------|-----------------------------------------|------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Terraform 1.5.4         | [Docs](https://developer.hashicorp.com/terraform?product_intent=terraform)                        | Hardware Provisioner <br/>Initial Setup | `Salt` `Ansible`                   | 1. Easy syntax<br/>2. Sufficient community and documentation<br/>3. Much better suited for hardware provisioning                                                                        |
| Hetzner Provider 1.42.1 | [Docs](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs)                   | Deploying servers                       | `Vultr` `DigitalOcean`             | 1. Cheaper :)<br/>2. Good community overlooking provider                                                                                                                                |
| Ansible 2.15.2          | [Docs](https://docs.ansible.com/)                                                                 | Automating Tasks                        | `Salt`                             | 1. No footprint on target hosts                                                                                                                                                         |
| Ubuntu  22.04           | [Docs](https://www.google.com/search?client=safari&rls=en&q=ubuntu+image+22.04&ie=UTF-8&oe=UTF-8) | Operating system                        | `Debian` `Centos`                  | 1. Bigger community<br/>2. Faster releases than debian<br/>3. Bigger community than any other OS<br/>4. Not cash grapping like centos (Yet :))                                          |
| Victoriametrics latest  | [Docs](https://victoriametrics.github.io/)                                                        | Time-series Database                    | `InfluxDB` `Prometheus`            | 1. High performance<br/>2. Cost-effective<br/>3. Scalable<br/>4. Handles massive volumes of data <br/>5. Good community and documentation                                               |
| vmalert latest          | [Docs](https://victoriametrics.github.io/vmalert.html)                                            | Evaluating Alerting Rules               | `Prometheus Alertmanager`          | 1. Works well with VictoriaMetrics<br/>2. Supports different datasource types                                                                                                           |
| vmagent latest          | [Docs](https://victoriametrics.github.io/vmagent.html)                                            | Collecting Time-series Data             | `Prometheus`                       | 1. Works well with VictoriaMetrics<br/>2. Supports different data source types                                                                                                          |
| Alertmanager latest     | [Docs](https://prometheus.io/docs/alerting/latest/alertmanager/)                                  | Handling Alerts                         | `ElastAlert` `Grafana Alerts`      | 1. Handles alerts from multiple client applications<br/>2. Deduplicates, groups, and routes alerts<br/>3. Can be plugged to multiple endpoints (Slack, Email, Telegram, Squadcast, ...) |
| Grafana latest          | [Docs](https://grafana.com/docs/grafana/latest/)                                                  | Monitoring and Observability            | `Prometheus` `Datadog` `New Relic` | 1. Create, explore, and share dashboards with ease  <br/>2.Huge community and documentation<br/>3. Easy to setup and manage<br/>4. Many out of the box solutions for visualization      |
| Redis latest            | [Docs](https://redis.io/docs/getting-started/installation/)                                       | In-memory key–value database            | `Memcached` `Couchbase`            | 1. As fast as they come (since it is in memory)  <br/>2.Easily escalable (casandra is amazing as well)<br/>3. Caching capability                                                        |
| Nodeexporter latest     | [Docs](https://prometheus.io/docs/guides/node-exporter/)                                          | Hardware and OS Metrics                 | `cAdvisor` `Collectd`              | 1. Measure various machine resources<br/>2. Pluggable metric collectors <br/>3. Basic standard for node monitoing                                                                       |
| Redis exporter latest   | [Docs](https://github.com/oliver006/redis_exporter)                                        | Monitoring Redis Clusters               | `NoN I Know of`                    | 1. Works well with Redis<br/>2. Exposes Redis metrics properly<br/>3. Supports mo nitoring redis cluster<br/>4. Supported by bitnami (good community)                                   |
| Docker latest           | [Docs](https://docs.docker.com/)                                                                  | Application Deployment and Management   | `containerd` `podman`              | 1. Much more bells and wistels are included out of the box comparing to alternatives<br/>2. Awsome community and documentation <br/>3. Easy to work with                                |



## Before you begin
> **Note**
> Each ansible role has a general and a specific Readme file. It is encouraged to read them before firing off
> 
> p.s: Start with the readme file of main setup playbook
* Create an Api on hetzner
* Create a server as terraform and ansible provisioner (Needless to say that ansible and terraform must be installed)
* Clone the project
* In modular_terraform folder create a terraform.tfvars 
    - The file must contain the following variables
      - hcloud_token "APIKEY"
      - image_name = "ubuntu-22.04"
      - server_type = "cpx31"
      - location = "hel1"
* Run terraform init to create the required lock file
* Before firing off, run terraform plan to see if everything is alright
* Run terraform apply
* Go Drink a cup of coffe and come back in 10 minutes or so (Hopefully everything must be up and running by then (: )


## Known issues
* No proper dashbaords for redis are being preloaded dashboards
* No automation for scaling or maintenance
* No audit logging (to see when,who made what changes on the cluster)
* Terraform is limited to Hetzner
* Grafana datasource must be set manually <http://IP_ADDRESS_:8428>




## Work flow
* Run the following command for terraform to install dependencies and create the lock file
``` bash
terraform init
```
![image](https://s3.ir-thr-at1.arvanstorage.ir/kangredis/redis_terraform_init.gif)


* Run the following command and check if there are any problems with terraform
``` bash
terraform plan
```
![image](https://s3.ir-thr-at1.arvanstorage.ir/kangredis/redis_terraform_plan.gif)

* Apply terraform modules and get started
``` bash
terraform apply
```
![image](https://s3.ir-thr-at1.arvanstorage.ir/kangredis/redis_terraform_apply.gif)


* Check the Redis cluster
``` bash
redis-cli -c -h localhost -p 7000 -a "YOUR_PASSWORD" 
```
![image](https://s3.ir-thr-at1.arvanstorage.ir/kangredis/redis_cluster.gif)




* Check if Grafana works
* > **Note**
> All dashboard are provisioned 
> To add custom dashbaord on load, add it to /Ansible/roles/Victoria_Metrics/files/Grafana/provisioning/dashboards as a .json file. It would automatically be loaded to Grafana
> Just keep in mind that you have to also copy the dashbaord using ansible to the remote destination

![image](https://s3.ir-thr-at1.arvanstorage.ir/kangredis/redis_grafana.gif)


* To Clean up everything (including the nodes themselvs)
``` bash
terraform destroy
```
![image](https://s3.ir-thr-at1.arvanstorage.ir/kangredis/redis_terraform_destroy.gif)






