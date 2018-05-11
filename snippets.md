# rename multiple files at once

```sh
find -type f -name 'api-*.conf*' ! -path '*api-wsgi.*'| xargs basename -s .conf | xargs -I {} mv {}.conf {}.conf.j2
```

# replace in multiple files
```sh
sed -e 's/foo/bar/g' -i $(find -type f -name '*.yml' -exec grep -inHl 'foo' '{}' /dev/null \;)
```

# enable corporate proxy

1. Modify /etc/environment
2. Set proxy somewhere for bash session (```/etc/profile``` ?)
3. Set proxy for NPM (```.npmrc```)
4. Set proxy for APT (```/etc/apt/config.d```)
5. Set proxy, if necessary, in Firefox
6. Set proxy, if neccessary, in Docker daemon
