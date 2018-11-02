RM=/bin/rm -f
RMD=/bin/rm -Rf

.create-eks-cluster:
	mkdir -p $(CLUSTER_NAME)
	cp -R base_files/* $(CLUSTER_NAME)
	cd $(CLUSTER_NAME);ls;sed -i='' "s/<CLUSTER_NAME>/$(CLUSTER_NAME)/" variables.tf
	cd $(CLUSTER_NAME);ls;terraform init;terraform plan -out plan.txt;terraform apply plan.txt
	cd $(CLUSTER_NAME);ls;terraform output config_map_aws_auth  >  awsAuth.yaml;terraform output kubeconfig  >  $(CLUSTER_NAME)-config;
	cd $(CLUSTER_NAME);ls;mkdir -p  ~/.kube;sudo mv $(CLUSTER_NAME)-config ~/.kube
	cd $(CLUSTER_NAME);kubectl apply -f awsAuth.yaml
	cd $(CLUSTER_NAME);ls;rm plan.txt
	make -s .helm-install
	make -s CLUSTER_NAME=$(CLUSTER_NAME) .install-kubernetes-dashboard
	kubectl get pods -n kube-system


.install-terraform:
	echo $(SUDOPASSWORD) | sudo -S apt-get install unzip
	#sudo apt-get install unzip
	wget https://releases.hashicorp.com/terraform/0.11.8/terraform_0.11.8_linux_amd64.zip
	mkdir temp_for_zip_extract
	unzip terraform_0.11.8_linux_amd64.zip -d temp_for_zip_extract
	sudo mv temp_for_zip_extract/terraform /usr/local/bin/
	rm -R temp_for_zip_extract
	rm terraform_0.11.8_linux_amd64.zip
	#unzip terraform_0.11.8_linux_amd64.zip
	#sudo mv terraform /usr/local/bin/
	
.install-kubernetes-client:
	echo $(SUDOPASSWORD) | sudo -S sudo apt-get update && sudo apt-get install -y apt-transport-https
	curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
	sudo touch /etc/apt/sources.list.d/kubernetes.list 
	echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
	sudo apt-get update
	sudo apt-get install -y kubectl

.install-aws-iam-authenticator: 
	echo $(SUDOPASSWORD) | sudo -S apt-get update
	curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/linux/amd64/aws-iam-authenticator
	chmod +x ./aws-iam-authenticator
	sudo mv ./aws-iam-authenticator /usr/local/bin/aws-iam-authenticator


	
.install-aws-cli:
	echo $(SUDOPASSWORD) | sudo -S apt-get update
	sudo apt-get install unzip
	sudo apt-get install curl
	sudo apt-get install python3
	sudo apt install python3-distutils
	curl -O https://bootstrap.pypa.io/get-pip.py
	python3 get-pip.py --user
	#export PATH=~/.local/bin:$PATH
	#source ~/.profile
	curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
	unzip awscli-bundle.zip
	sudo /usr/bin/python3 awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
	#export PATH=~/.local/bin:$PATH
	#source ~/.profile
	rm -R awscli-bundle
	rm awscli-bundle.zip
	rm get-pip.py



.install-argo-cd:
	kubectl create namespace argocd
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v0.7.1/manifests/install.yaml
	sudo curl -L -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v0.7.1/argocd-linux-amd64
	sudo chmod +x /usr/local/bin/argocd

.delete-argo-cd:
	-kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v0.7.1/manifests/install.yaml	
	-kubectl delete namespace argocd
	-sudo $(RM) /usr/local/bin/argocd 	

.install-kubernetes-dashboard:
	echo $(CLUSTER_NAME)
	kubectl apply -f $(CLUSTER_NAME)/dashboard/kubernetes-dashboard.yaml
	

.install-kubernetes-dashboard_orig:
	kubectl apply -f dashboard/kubernetes-dashboard.yaml

.delete-kubernetes-dashboard:
	kubectl delete -f dashboard/kubernetes-dashboard.yaml

.install-istio-helm-tiller:
	#-${RMD} istio-1.0.0
	#curl -L https://git.io/getLatestIstio | ISTIO_VERSION=1.0.0 sh
	#cp istio-1.0.0/bin/istioctl ~/.local/bin
	kubectl create namespace istio-system
	helm install istio-1.0.0/install/kubernetes/helm/istio --debug --timeout 600 --wait --name istio --namespace istio-system --set grafana.enabled=true --set servicegraph.enabled=true --set prometheus.enabled=true --set tracing.enabled=true --set global.configValidation=false 

.install-istio-helm-template:
	#cp istio-1.0.0/bin/istioctl ~/.local/bin
	kubectl create namespace istio-system
	helm template istio-1.0.0/install/kubernetes/helm/istio --name istio --namespace istio-system --set grafana.enabled=true --set servicegraph.enabled=true --set prometheus.enabled=true --set tracing.enabled=true > istio-1.0.0/istio.yaml
	kubectl create -f istio-1.0.0/istio.yaml

.delete-istio-helm-tiller:
	-helm del --purge istio
	-kubectl -n istio-system delete job --all
	-kubectl delete -f istio-1.0.0/install/kubernetes/helm/istio/templates/crds.yaml -n istio-system
	-kubectl delete namespace istio-system
	-${RM} ~/.local/bin/istioctl

.delete-istio-helm-template:
	-kubectl delete -f istio-1.0.0/istio.yaml
	-kubectl -n istio-system delete job --all
	-kubectl delete -f istio-1.0.0/install/kubernetes/helm/istio/templates/crds.yaml -n istio-system
	-kubectl delete namespace istio-system
	-${RM} ~/.local/bin/istioctl


.install-helm-bin:
	#echo $(SUDOPASSWORD)
	curl -L https://storage.googleapis.com/kubernetes-helm/helm-v2.10.0-rc.2-linux-amd64.tar.gz | tar -xzv
	echo $(SUDOPASSWORD)  | sudo -S cp linux-amd64/helm /usr/local/bin
	#sudo -S cp linux-amd64/helm /usr/local/bin
	${RMD} linux-amd64
	helm home

.delete-helm-bin:
	-sudo ${RM} /usr/local/bin/helm


.helm-install:.install-helm-bin 
	echo $(SUDOPASSWORD)
	kubectl -n kube-system create serviceaccount tiller
	kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
	helm init --service-account=tiller
	-helm repo update

.helm-delete: 
	-helm reset
	-${RMD} ~/.helm
	-kubectl -n kube-system delete deployment tiller-deploy 
	-kubectl delete clusterrolebinding tiller
	-kubectl -n kube-system delete serviceaccount tiller
	-make .delete-helm-bin
	-echo 'helm deleted.'


#for ML model deployment with Seldon	
.install-s2i: .delete-s2i
	mkdir seldon
	curl -L https://github.com/openshift/source-to-image/releases/download/v1.1.10/source-to-image-v1.1.10-27f0729d-linux-amd64.tar.gz | tar -xzv -C seldon
	sudo cp seldon/s2i /usr/local/bin
	$(RMD) seldon
.delete-s2i:
	-$(RM) /usr/local/bin/s2i

#following target is used only for testing from local
.create-eks-cluster_local:
	echo $(SUDOPASSWORD) | mkdir -p $(CLUSTER_NAME)
	cp -R base_files/* $(CLUSTER_NAME)
	cd $(CLUSTER_NAME);ls;sed -i='' "s/<CLUSTER_NAME>/$(CLUSTER_NAME)/" variables.tf
	cd $(CLUSTER_NAME);ls;terraform init;terraform plan -out plan.txt;terraform apply plan.txt
	cd $(CLUSTER_NAME);ls;terraform output config_map_aws_auth  >  awsAuth.yaml;terraform output kubeconfig  >  $(CLUSTER_NAME)-config
	cd $(CLUSTER_NAME);ls;mv $(CLUSTER_NAME)-config ~/.kube
	cd $(CLUSTER_NAME);kubectl apply -f awsAuth.yaml
	cd $(CLUSTER_NAME);ls;rm plan.txt
	make -s SUDOPASSWORD=$(SUDOPASSWORD) .helm-install
	make -s CLUSTER_NAME=$(CLUSTER_NAME) .install-kubernetes-dashboard
	kubectl get pods -n kube-system
