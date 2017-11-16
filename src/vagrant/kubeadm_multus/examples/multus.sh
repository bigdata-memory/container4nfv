#!/bin/bash
#
# Copyright (c) 2017 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -ex

#workaroud to fix dns pod issue
times=0

while [ $times -lt "3" ]
do
    kubectl get pods -n kube-system | grep kube-dns | grep -v Run | sed "s/ .*//" | \
        xargs -I {} kubectl delete pod -n kube-system {}
    sleep 20
    times+=1
done

kubectl apply -f /vagrant/examples/busybox.yaml
r="0"
while [ $r -ne "2" ]
do
   r=$(kubectl get pods | grep Running | wc -l)
   sleep 20
done
kubectl get pods --all-namespaces
kubectl get pods | grep Run | sed "s/ .*//" | xargs -I {} kubectl exec -i {} ip a