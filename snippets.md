# rename multiple files at once

```sh
find -type f -name 'api-*.conf*' ! -path '*api-wsgi.*'| xargs basename -s .conf | xargs -I {} mv {}.conf {}.conf.j2
```

