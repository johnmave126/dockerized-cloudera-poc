# dockerized-cloudera-poc
Generate docker-compose.yml to locally deploy a Cloudera Management & CDH cluster in docker for proof-of-concept development.

# Usage
```
$ ./generate.sh
Usage: ./generate.sh [OPTION]...
Generate files for cloudera containers

  -a, --all          generate everything
  -d, --db           generate MySQL password environment file
  -s, --ssh          generate SSH key pair
  -w, --worker [N]   generate docker-compose with N workers (default: 1)
  -h, --help         display this help and exit
```
