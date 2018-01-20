Usage

```docker build -f docker/ubuntu/Dockerfile --tag ethcore/parity:branch_or_tag_name .```

Also:

- `/musereum --config=/node/node.toml --ui-no-validation --ui-interface="0.0.0.0" ui`
- `/musereum --password="/node/pswd.txt" --config=/node/node.toml --force-sealing`

Also:

- `sudo docker container run --rm -ti -v /home/andyceo/workspace/musereum-parity/docker/musereum-quickfix/node1:/node -p 8180:8180 musereum:0.1.1 sh -il`
