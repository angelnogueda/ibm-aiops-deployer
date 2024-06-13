export downloadKey=xyz
export salesKey=xyz
export adminPassword=CHANGEME
export licenseFile=./license.json
export dhparamspem=./dhparams.pem
export tokensecret=uQOkH+Y4wU_0


# Install DOCKER

#sudo nano /etc/apt/sources.list
#http://archive.ubuntu.com/ubuntu
# sudo nano /etc/resolv.conf

sudo apt-get update
sudo apt-get -y install \
ca-certificates \
curl \
gnupg \
lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io


sudo groupadd docker
sudo usermod -aG docker $USER



# Install Instana
echo "deb [arch=amd64] https://self-hosted.instana.io/apt generic main" > /etc/apt/sources.list.d/instana-product.list
wget -qO - "https://self-hosted.instana.io/signing_key.gpg" | sudo apt-key add -
sudo apt-get update
sudo apt-get install instana-console


sudo mkdir -p /mnt/data
sudo mkdir -p /mnt/traces
sudo mkdir -p /mnt/metrics
sudo mkdir -p /var/log/instana

instana init

instana license download -k xyz
instana license import
instana license verify



instana repair
instana update
instana restore
instana configure admin






export DOWNLOAD_KEY=<download_key>

cat << EOF > /etc/yum.repos.d/Instana-Product.repo
[instana-product]
name=Instana-Product
baseurl=https://_:$DOWNLOAD_KEY@artifact-public.instana.io/artifactory/rel-rpm-public-virtual/
enabled=1
gpgcheck=0
gpgkey=https://_:$DOWNLOAD_KEY@artifact-public.instana.io/artifactory/api/security/keypair/public/repositories/rel-rpm-public-virtual
repo_gpgcheck=1
EOF

yum clean expire-cache -y

yum update -y

yum install -y instana-console

yum versionlock add instana-console



