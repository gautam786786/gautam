# Linux

**Check that service enabled by run:-->**.
systemctl --no-page -t service -a | grep apache2
 
**enable it and start-->:**
stemctl enable apache2 && systemctl start apache2

**Check that service works:-->**
systemctl status apache2

**logs-->**
journalctl --no-page -u apache2.service Note. -f key works with journalctl well as with tail

[![Image](https://www.stacksimplify.com/course-images/azure-aks-ingress-domain-name-based-routing.png "Azure AKS Kubernetes - Masterclass")](https://www.udemy.com/course/aws-eks-kubernetes-masterclass-devops-microservices/?referralCode=257C9AD5B5AF8D12D1E1)


