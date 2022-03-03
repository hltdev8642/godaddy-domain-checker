#!/bin/bash
# name: domain-avail-check.sh
# auth: hltdev [hltdev8642@gmail.com]
# desc: check if a domain is available on godaddy.com using godaddy API
#

# prevent ctrl+C / ctrl+D
# trap '' 2


RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[1;34m'
GRAY='\033[1;90m'

print_available()
{
    echo -e "\n${BLUE}[$1] => ${GREEN}[AVAILABLE]"
}

print_unavailable ()
{
    echo -e "\n${BLUE}[$1] => ${RED}[UNAVAILABLE]"

}

print_error()
{
    echo -e "\n${RED}[ERROR/INVALID QUERY]"
}

reboot ()
{
  echo -e "\n${GRAY}\nRestarting...\n"
  main
}

main ()
{
echo -e "${BLUE}-----------------------------------"
echo -e "${BLUE}GODADDY DOMAIN AVAILABILITY CHECKER"
echo -e "${BLUE}-----------------------------------\n"

# if [[ -z "$1" ]]; then
    # read -p "Enter a domain to check (ex:" QUERY
    echo -e "Enter a domain to check (ex: \`xyz.com\`)\n"
    read -p "-> " QUERY 
    # read -p " -> https://" QUERY 
# else
    # QUERY=""$1"
# fi


result=""$(curl -X "GET" "https://api.ote-godaddy.com/v1/domains/available?domain=$QUERY&checkType=FULL&forTransfer=false" -H "accept: application/json" -H "Authorization: sso-key $sso_key" | jq .available )""
# printf "%s" $result
# result=$(curl "https://api.godaddy.com/v1/domains/available?main=${QUERY}&key=${API_KEY}&secret=$API_SECRET" | jq .available )
# result=$(echo \"$result\")
# echo $result

# if [[ $result = true ]]; then
#   print_available "$QUERY"
#   reboot
# else
#   print_unavailable "$QUERY"
#   reboot
# fi
case $result in
    "true" )
        # echo true
        print_available "$QUERY"
        reboot
        ;;
    "false" )
        # echo false
        print_unavailable "$QUERY"
        reboot
        ;;
    *)
        print_error
        reboot
      ;;
esac

}

main "$@"
# echo "$result"
# availability="$(cat $result | jq .available)"
# echo $availability