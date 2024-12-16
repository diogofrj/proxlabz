# Instalar o cert-manager:

helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set crds.enabled=true \
  --version v1.16.2

# Instalar o traefik:

helm repo add traefik https://traefik.github.io/charts
helm repo update
# Instalar o Traefik com CRDs
helm install traefik traefik/traefik \
  --namespace traefik \
  --create-namespace \
  -f k8s/traefik-values.yaml \
  --set crds.enabled=true

kubectl get crds | grep traefik

# Instalar o cluster-issuer:
kubectl apply -f /home/diogo/k8s/cluster-issuer.yaml

# Instalar o teste-app:
kubectl apply -f /home/diogo/k8s/teste-app.yaml

# Para verificar se tudo está funcionando:
kubectl get pods -n traefik
kubectl get pods -n cert-manager
kubectl get certificates -A
kubectl get ingressroute

#Para verificar os logs do cert-manager:
kubectl logs -n cert-manager -l app=cert-manager

# Instalar o metallb:
helm install metallb metallb/metallb \
  --namespace metallb-system \
  --create-namespace

  # Aplique os arquivos de configuração
kubectl apply -f k8s/metallb-values.yaml


## CERT MANAGER
# Verificar certificados
kubectl get certificates -A

# Verificar solicitações de certificados
kubectl get certificaterequests -A

# Verificar status dos ClusterIssuers
kubectl get clusterissuers -A

# Ver detalhes de um certificado específico
kubectl describe certificate -n <namespace> <nome-do-certificado>


# Adicionar o repositório
helm repo add cert-manager-web-ui https://cert-manager.github.io/web-ui
helm repo update

# Instalar o UI
helm install cert-manager-web-ui cert-manager-web-ui/cert-manager-web-ui \
  --namespace cert-manager \
  --set=certmanager.namespace=cert-manager

# Aplicar o IngressRoute do Traefik Dashboard
kubectl apply -f k8s/traefik-dashboard.yaml

# Aplicar o IngressRoute do cert-manager-web-ui (se instalado)
kubectl apply -f k8s/certmanager-dashboard.yaml

Traefik Dashboard: https://traefik.lojadasdicas.com.br
Cert-manager UI (se instalado): https://certmanager.lojadasdicas.com.br
Lembre-se de:
Configurar os registros DNS para os subdomínios
Esperar a propagação do DNS
Aguardar a emissão dos certificados pelo Let's Encrypt

# Verificar certificados sendo emitidos
kubectl get certificates -A

# Verificar eventos do cert-manager
kubectl get events -n cert-manager


# Para o Traefik Dashboard
kubectl port-forward -n traefik $(kubectl get pods -n traefik --selector "app.kubernetes.io/name=traefik" --output=name) 9000:9000

# Para o cert-manager-web-ui (se instalado)
kubectl port-forward -n cert-manager svc/cert-manager-web-ui 9000:9000

Então você pode acessar:
Traefik Dashboard: http://localhost:9000/dashboard/
Cert-manager UI: http://localhost:9000 (se instalado)


kubectl create secret generic -n metallb-system metallb-memberlist --from-literal=secretkey="$(openssl rand -base64 128)"


---------------------------------------------------------------------------------------

# Adicionar repositório do MetalLB
helm repo add metallb https://metallb.github.io/metallb
helm repo update

# Instalar MetalLB
helm install metallb metallb/metallb \
  --namespace metallb-system \
  --create-namespace

# Criar secret necessário para o MetalLB
kubectl create secret generic -n metallb-system metallb-memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

