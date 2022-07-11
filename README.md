## 朋昶數位科技實習專案 
## Conjur實作

### 使用環境 
> GCP上架設虛擬機器，CPU 8 核心 、 RAM 32 GB

### 操作步驟

sudo apt-get update

sudo apt install docker-compose -y

sudo gpasswd -a $USER docker ; newgrp docker

git clone https://github.com/cyberark/conjur-quickstart.git

cd conjur-quickstart/

docker-compose pull

docker-compose run --no-deps --rm conjur data-key generate > data_key

export CONJUR_DATA_KEY="$(< data_key)"

docker-compose up -d

docker ps -a

docker-compose exec conjur conjurctl account create myConjurAccount > admin_data

docker-compose exec client conjur init -u conjur -a myConjurAccount

docker-compose exec client conjur authn login -u admin

cd conf/policy/

vi mysql.yml

cd ..
cd ..

docker-compose exec client conjur policy load root policy/mysql.yml > mysql_data

ip=34.145.126.91
username=darren
password=darrentest
echo $ip,$username,$password

docker-compose exec client conjur variable values add mysql/ip ${ip}
docker-compose exec client conjur variable values add mysql/username ${username}
docker-compose exec client conjur variable values add mysql/password ${password}

curl -d "3fw7na7wzm2d018342131w6s8yw3s7p3vzzmkaskz133ej3pskpcy" -k https://34.145.126.91:8443/authn/myConjurAccount/host%2Fmysql%2FmyDemoApp/authenticate > conjur_token

CONT_SESSION_TOKEN=$(cat /home/darrenli840214/conjur-quickstart/conjur_token| base64 | tr -d '\r\n')                                                  

VAR_VALUE_IP=$(curl -s -k -H "Content-Type: application/json" -H "Authorization: Token token=\"$CONT_SESSION_TOKEN\"" https://34.145.126.91:8443/secrets/myConjurAccount/variable/mysql%2Fip)

VAR_VALUE_USER=$(curl -s -k -H "Content-Type: application/json" -H "Authorization: Token token=\"$CONT_SESSION_TOKEN\"" https://34.145.126.91:8443/secrets/myConjurAccount/variable/mysql%2Fusername)

VAR_VALUE_PASSWD=$(curl -s -k -H "Content-Type: application/json" -H "Authorization: Token token=\"$CONT_SESSION_TOKEN\"" https://34.145.126.91:8443/secrets/myConjurAccount/variable/mysql%2Fpassword)


echo "The retrieved value is: $VAR_VALUE_IP"
echo "The retrieved value is: $VAR_VALUE_USER"
echo "The retrieved value is: $VAR_VALUE_PASSWD"
