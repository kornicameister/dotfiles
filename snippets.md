# rename multiple files at once

```sh
find -type f -name 'api-*.conf*' ! -path '*api-wsgi.*'| xargs basename -s .conf | xargs -I {} mv {}.conf {}.conf.j2
```

# replace in multiple files
```sh
sed -e 's/foo/bar/g' -i $(find -type f -name '*.yml' -exec grep -inHl 'foo' '{}' /dev/null \;)
```

