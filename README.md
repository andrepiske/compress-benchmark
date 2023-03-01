
Algorithms:

- zstd: https://github.com/msievers/zstandard-ruby

To read:

- https://stackoverflow.com/questions/37614410/comparison-between-lz4-vs-lz4-hc-vs-blosc-vs-snappy-vs-fastlz

## Early results

1) Using "bigpayload", which is a 250MB tar of a `node_modules` folder:


```
$ docker build -t compress . && docker run -e ITIMES=20 --rm -ti compress
Data len: 250.00mb
LZ4: 465.5010593000043ms (78.81mb)
LZ4 inflate: 274.1119294496457ms
Snappy: 2280.943863149514ms (76.06mb)
Snappy inflate: 817.7205197509466ms
Zstandard: 921.75020925024ms (39.03mb)
Zstandard inflate: 418.9969367504091ms
Zlib: 5948.85474014809ms (45.65mb)
Zlib inflate: 791.3127455005451ms
```
