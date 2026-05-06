#!/bin/bash

cat <<EOF > lonely-wolf.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: lonely-wolf
  name: lonely-wolf
spec:
  replicas: 3
  selector:
    matchLabels:
      app: lonely-wolf
  strategy: {}
  template:
    metadata:
      labels:
        app: lonely-wolf
    spec:
      containers:
      - image: busybox
        name: busybox
        resources: {}
status: {}
EOF