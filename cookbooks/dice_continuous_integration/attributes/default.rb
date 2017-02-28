# Cookbook Name:: dice_continuous_integration
# Attribute:: default
#
# Copyright 2017, XLAB d.o.o.
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

default['dice_ci']['plugin_hpi'] =
    'https://github.com/dice-project/DICE-Jenkins-Plugin/releases/download/0.2.2/dice-qt.hpi'
default['dice_ci']['plugin_checksum'] =
     '8fd98a0afc8ed97989fa929bdbe9be5a649275d2ebed89111f2099cf6ce82e06' # sha-256
