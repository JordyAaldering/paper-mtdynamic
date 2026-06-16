Running with Docker:

```sh
docker run -d --rm \
  -v "$(pwd):/home" -v /sys/class/powercap:/sys/class/powercap \
  sacbase/sac-compiler ./scripts/laptop/x.sh
```
