#!/bin/bash
# name: domain-avail-check.sh
# auth: hltdev [hltdev8642@gmail.com]
# desc: check if a domain is available on godaddy.com using godaddy API
#

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

if [[ -z "$1" ]]; then
    # read -p "Enter a domain to check (ex:" QUERY
    echo -e "Enter a domain to check (ex: \`xyz.com\`)\n"
    read -p "-> " QUERY 
else
    QUERY="$1"
fi


result="$(curl -s -X GET -H "Authorization: sso-key ${API_KEY}:${API_SECRET}" "https://api.godaddy.com/v1/domains/available?domain=${QUERY}" | jq .available )"
case $result in
    "true" )
        print_available "$QUERY"
        reboot
        ;;
    "false" )
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