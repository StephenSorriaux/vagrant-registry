# Vagrant-registry
A self-hosted Vagrant registry running with Docker.

## How to use
* Launch the container with ```docker run -d -p 8080:8080 -e NGINX_HOST=localhost -e NGINX_PORT=8080 ssorriaux/vagrant-registry:latest```.
* If you don't want to lose your data, bind the /var/www folder to a host folder ie ```-v /my/folder/:/var/www```.
* You can change any Nginx configuration by overriding the ```/etc/nginx/nginx.conf.template``` file. Usage of environment variable in the template is possible.
* For each vagrant box, upload your json catalog to ```http://www.example.com/vagrant/<name-of-box>/<name-of-box>.json```
* Upload your .box file to ```http://www.example.com/vagrant/<name-of-box>/boxes/<name-of-box>_<box-version>.box```. Be sure that your catalog has the correct link for your version.

## How to upload catalog and boxes
Using a PUT HTTP request: ```curl -XPUT -L --upload-file /path/to/my/catalog/or/box http://www.example.com/vagrant/<name-of-box>/correct/path/```
Be aware that, for every new boxes, you will need to update the catalog of the concerned box.

## Catalog example
```
{
    "name": "my-box",
    "description": "This box is awesome.",
    "versions": [{
        "version": "0.1.0",
        "providers": [{
                "name": "virtualbox",
                "url": "http://www.example.com/vagrant/my-box/boxes/my-box_0.1.0.box",
                "checksum_type": "sha1",
                "checksum": "d3597dccfdc6953d0a6eff4a9e1903f44f72ab94"
        }]
    },{
        "version": "0.1.1",
        "providers": [{
                "name": "virtualbox",
                "url": "http://www.example.com/vagrant/my-box/boxes/my-box_0.1.1.box",
                "checksum_type": "sha1",
                "checksum": "0b530d05896cfa60a3da4243d03eccb924b572e2"
        }]
    }]
}
```

## Configuring a Vagrantfile
Based on the previous catalog, you can retrieve your ```my-box``` Vagrant box using this simple Vagrantfile:

```
Vagrant.configure("2") do |config|
  config.vm.box = "my-box"
  config.vm.box_version = "0.1.0"
  config.vm.box_url = "http://www.example.com/vagrant/my-box/"
end
```
After using ```vagrant up``` you can check the container logs to see the requests made by vagrant:
```
172.17.0.1 - - [22/Aug/2018:19:39:20 +0000] "HEAD /vagrant/my-box/ HTTP/1.1" 200 0 "-" "Vagrant/2.1.2 (+https://www.vagrantup.com; ruby2.4.4)"
172.17.0.1 - - [22/Aug/2018:19:39:20 +0000] "GET /vagrant/my-box/ HTTP/1.1" 200 406 "-" "Vagrant/2.1.2 (+https://www.vagrantup.com; ruby2.4.4)"
172.17.0.1 - - [22/Aug/2018:19:39:21 +0000] "GET /vagrant/my-box/boxes/my-box_0.1.0.box HTTP/1.1" 200 432941463 "-" "Vagrant/2.1.2 (+https://www.vagrantup.com; ruby2.4.4)"
172.17.0.1 - - [22/Aug/2018:19:39:57 +0000] "GET /vagrant/my-box/ HTTP/1.1" 200 406 "-" "Vagrant/2.1.2 (+https://www.vagrantup.com; ruby2.4.4)"
```

## Next steps
* Add auth configuration
* Manage box with name containing '/'
* An easy way to update catalog and upload new boxes

## Source
Inspired from https://github.com/hollodotme/Helpers/blob/master/Tutorials/vagrant/self-hosted-vagrant-boxes-with-versioning.md
