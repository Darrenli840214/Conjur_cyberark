## 朋昶數位科技實習專案：Conjur實作

### 使用環境 
> GCP上架設虛擬機器，CPU 8 核心 、 RAM 32 GB

### 目標
> 安裝好 Conjur/ MySQL  
> 在Conjur上將 MySQL 的 IP/ USERNAME / PASSWORD 設置上去，並限制由SERVER A取得  
> 在SERVER A 上以Python 實作一支 Script，透過 Conjur 的 REST API 取得MySQL 登入資訊後，登入MySQL 執行一個DB QUERY  

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

ip=`<你的IP>`
username=`<你設定的MySQL用戶>`
password=`<你設定的MySQL密碼>`
echo $ip,$username,$password

docker-compose exec client conjur variable values add mysql/ip ${ip}
docker-compose exec client conjur variable values add mysql/username ${username}
docker-compose exec client conjur variable values add mysql/password ${password}

curl -d `"你的MyDemoApp的API KEY"` -k https://`<你的IP:8443>`/authn/myConjurAccount/host%2Fmysql%2FmyDemoApp/authenticate > conjur_token

CONT_SESSION_TOKEN=$(cat /home/`你的電腦使用者名稱`/conjur-quickstart/conjur_token| base64 | tr -d '\r\n')                                                  

VAR_VALUE_IP=$(curl -s -k -H "Content-Type: application/json" -H "Authorization: Token token=\"$CONT_SESSION_TOKEN\"" https://`<你的IP:8443>`/secrets/myConjurAccount/variable/mysql%2Fip)

VAR_VALUE_USER=$(curl -s -k -H "Content-Type: application/json" -H "Authorization: Token token=\"$CONT_SESSION_TOKEN\"" https://`<你的IP:8443>`/secrets/myConjurAccount/variable/mysql%2Fusername)

VAR_VALUE_PASSWD=$(curl -s -k -H "Content-Type: application/json" -H "Authorization: Token token=\"$CONT_SESSION_TOKEN\"" https://`<你的IP:8443>`/secrets/myConjurAccount/variable/mysql%2Fpassword)


echo "The retrieved value is: $VAR_VALUE_IP"
echo "The retrieved value is: $VAR_VALUE_USER"
echo "The retrieved value is: $VAR_VALUE_PASSWD"
