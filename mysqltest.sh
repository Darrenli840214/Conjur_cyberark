#!/bin/bash
main() {
  CONT_SESSION_TOKEN=$(cat /home/darrenli840214/conjur-quickstart/conjur_token| base64 | tr -d '\r\n')
  VAR_VALUE_USER=$(curl -s -k -H "Content-Type: application/json" -H "Authorization: Token token=\"$CONT_SESSION_TOKEN\"" https://<IP>:8443/secrets/myConjurAccount/variable/mysql%2Fusername)

  VAR_VALUE_PASSWD=$(curl -s -k -H "Content-Type: application/json" -H "Authorization: Token token=\"$CONT_SESSION_TOKEN\"" https://<IP>:8443/secrets/myConjurAccount/variable/mysql%2Fpassword)

  VAR_VALUE_IP=$(curl -s -k -H "Content-Type: application/json" -H "Authorization: Token token=\"$CONT_SESSION_TOKEN\"" https://<IP>:8443/secrets/myConjurAccount/variable/mysql%2Fip)
  echo "The ip is: $VAR_VALUE_IP"
  echo "The username is: $VAR_VALUE_USER"
  echo "The password is: $VAR_VALUE_PASSWD"
}
main "$@"
exit
