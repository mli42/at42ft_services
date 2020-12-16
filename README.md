# at42ft_services

Don't know how to start minikube? Read [`ashishae`'s tips](https://www.notion.so/Ft_services-VM-852d4f9b0d9a42c1a2de921e4a2ac417)

## There is a `funct.sh`, what is this? - My Bestpractices

It's a file that have to be `source`-ed in every new terminal (if needed)

It contains shell functions :

- `kdeploy`

This function builds a docker image and applies the associated `.yaml`
```zsh
kdeploy nginx wordpress mysql phpmyadmin
```

- `clean`

This function deletes the ressources deployed by a `.yaml`
```zsh
clean nginx wordpress mysql phpmyadmin
```

- `kre`

Runs `clean` then `kdeploy` for each given parameters
```zsh
kre nginx wordpress mysql phpmyadmin
```

- `watch_services`

Keep an eye on everything running in your cluster
```zsh
watch_services
```

- `dockexec`

Executes a docker image, just to see what's in it
```zsh
dockexec [service-name] [path/to/dockerfile] [cmd (sh by default)]
```

- `kexec`

Executes an existing pod (with `sh` by default), just to see what's in it (is your config set as you wanted?)
```zsh
kexec [pod-ID] [cmd (sh by default)]
```

- `klogs`

Get logs of one pod from kubernetes 
```zsh
klogs [pod-ID]
```

## Few other debugging tips

- Verify nginx is running:
```bash
ps aux | grep "[n|N]ginx"
```

- Verifying that Nginx port is open:
```bash
netstat -tulpn
```

- [Is MySQL port open ?](https://webdock.io/en/docs/how-guides/how-enable-remote-access-your-mariadbmysql-database)
```bash
netstat -ant | grep 3306
# tcp        0      0 0.0.0.0:3306            0.0.0.0:*               LISTEN
```

- But alpine doesn't have `netstat`!

[Search for it then!](https://pkgs.alpinelinux.org/contents)
