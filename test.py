#!/usr/bin/env python3
from conjur import Client
import pymysql

client = Client(url='https://`<IP>`:8443',
                account='myConjurAccount',
                login_id="Darren@mysql",
                api_key="API KEY",
                ssl_verify=False)

ip=client.get('mysql/ip').decode('utf-8')
username=client.get('mysql/username').decode('utf-8')
password=client.get('mysql/password').decode('utf-8')

db = pymysql.connect(host='<IP>', port=6033, user=username, passwd=password, db='test', charset='utf8')

cursor = db.cursor()

sql = 'SELECT VERSION()'

cursor.execute(sql)

data = cursor.fetchone()

print ("Database version : %s " % data)

db.close()
