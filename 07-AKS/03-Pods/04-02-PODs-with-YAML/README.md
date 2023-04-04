
## Step-02: Create Simple Pod Definition using YAML 
- We are going to create a very basic pod definition
- **02-pod-definition.yml**
```yml
apiVersion: v1 # String
kind: Pod  # String
metadata: # Dictionary
  name: myapp-pod
  labels: # Dictionary 
    app: myapp         
spec:
  containers: # List
    - name: myapp
      image: stacksimplify/kubenginx:1.0.0
      ports:
        - containerPort: 80
```
- **Create Pod**
```
# Create Pod
kubectl create -f 02-pod-definition.yml
[or]
kubectl apply -f 02-pod-definition.yml

# List Pods
kubectl get pods
```

## Step-03: Create a LoadBalancer Service
- **03-pod-LoadBalancer-service.yml**
```yml
apiVersion: v1
kind: Service
metadata:
  name: myapp-pod-loadbalancer-service  # Name of the Service
spec:
  type: LoadBalancer
  selector:
  # Loadbalance traffic across Pods matching this label selector
    app: myapp
  # Accept traffic sent to port 80    
  ports: 
    - name: http
      port: 80    # Service Port
      targetPort: 80 # Container Port
```
- **Create LoadBalancer Service for Pod**
```
# Create Service
kubectl apply -f 03-pod-LoadBalancer-service.yml

# List Service
kubectl get svc

# Access Application
http://<Load-Balancer-Service-IP>

```



