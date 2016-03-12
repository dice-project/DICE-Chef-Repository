#
# Cookbook Name:: hadoop-upstream
# Attribute:: default
#
# Copyright 2016, XLAB
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Package binaries
default["apache-mirror"] = "http://172.16.93.126:8000"
#default["apache-mirror"] = "http://www-eu.apache.org"
default["hadoop-version"] = "hadoop-2.7.2"
default["sha256-checksum"] =
  "49ad740f85d27fa39e744eb9e3b1d9442ae63d62720f0aabdae7aa9a718b03f7"

# GLobal settings for installation
default["prefix"] = "/opt"
default["conf-dir"] = "/etc/hadoop"

# Per service settings
default["core-site"]["fs.defaultFS"] = "hdfs://#{node["fqdn"]}"
default["hdfs-site"]["dfs.namenode.name.dir"] = "file:///home/hdfs/namenode"
default["hdfs-site"]["dfs.datanode.data.dir"] = "file:///home/hdfs/datanode"
default["yarn-site"]["yarn.resourcemanager.hostname"] = node["fqdn"]

default["hadoop-env"]["JAVA_HOME"] = "/usr/lib/jvm/java-7-oracle"
default["hadoop-env"]["HADOOP_CONF_DIR"] = node["conf-dir"]
default["hadoop-env"]["HADOOP_LOG_DIR"] = "/var/log/hadoop/hdfs"
default["hadoop-env"]["HADOOP_NAMENODE_OPTS"] =
  "-Dhadoop.security.logger=INFO,RFAS "\
  "-Dhdfs.audit.logger=INFO,NullAppender"
default["hadoop-env"]["HADOOP_DATANODE_OPTS"] =
  "-Dhadoop.security.logger=ERROR,RFAS"
default["hadoop-env"]["HADOOP_SECONDARYNAMENODE_OPTS"] =
  "-Dhadoop.security.logger=INFO,RFAS "\
  "-Dhdfs.audit.logger=INFO,NullAppender"
default["hadoop-env"]["HADOOP_PORTMAP_OPTS"] = "-Xmx512m"
default["hadoop-env"]["HADOOP_CLIENT_OPTS"] = "-Xmx512m"
default["hadoop-env"]["HADOOP_PID_DIR"] = "/var/run/"
