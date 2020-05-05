#!/bin/bash
set -e

show_help()
{
    cat <<EOF
Usage: $0 [OPTION]...
Generate files for cloudera containers

  -a, --all          generate everything
  -d, --db           generate MySQL password environment file
  -s, --ssh          generate SSH key pair
  -w, --worker [N]   generate docker-compose with N workers (default: 1)
  -h, --help         display this help and exit
EOF
}

gen_mysql()
{
    echo 'Generate MYSQL Password'
    echo MYSQL_ROOT_PASSWORD=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32}`>mysql.env
}

gen_ssh()
{
    echo 'Generate SSH key pair'
    ssh-keygen -t rsa -b 2048 -f id_rsa -q -N ""
}

gen_docker_compose()
{
   echo 'Generate docker-compose.yml' 
   mkdir shared

   HEADER=$(sed -e '/>>>>/Q' docker-compose.yml.template)
   WORKER_TEMPLATE=$(sed -n -e '/>>>>/,/<<<</{//!p;}' docker-compose.yml.template)
   FOOTER=$(sed -e '1,/<<<</d' docker-compose.yml.template)

   echo "$HEADER" >docker-compose.yml
   for ((i=1;i<=WORKER;i++)); do
        echo "$WORKER_TEMPLATE" | sed -e "s/@i/${i}/g;s/@WORKER/${WORKER}/g" >>docker-compose.yml
   done
   echo "$FOOTER" >>docker-compose.yml
}

if [[ $# -eq 0 ]]; then
    show_help
    exit 0
fi

while [[ $# -gt 0 ]]; do
   case $1 in
        -a|--all)
            DB=YES
            SSH=YES
            if [[ -z "$WORKER" ]]; then
                WORKER=1
            fi
            shift
            ;;
        -d|--db)
            DB=YES
            shift
            ;;
        -s|--ssh)
            SSH=YES
            shift
            ;;
        -w|--worker)
            WORKER=$2
            if [[ ! $WORKER =~ ^[0-9]+$ ]]; then
                WORKER=1
            else
                shift
            fi
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option $1"
            show_help
            exit 1
            ;;
    esac
done

if [[ -n "$DB" ]]; then
    gen_mysql
fi

if [[ -n "$SSH" ]]; then
    gen_ssh
fi

if [[ -n "$WORKER" ]]; then
    gen_docker_compose
fi

