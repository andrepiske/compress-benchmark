
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

2) Using "payload.tar", a 2.4mb tar file of a small git repository (with .git folder):

```
$ docker run -e ITIMES=100 --rm -ti compress
Data len: 2.42mb
LZ4: 6.2180296505539445ms (1.71mb)
LZ4 inflate: 1.535536010414944ms
Snappy: 9.344340480020037ms (1.74mb)
Snappy inflate: 2.7944766601285664ms
Zstandard: 5.81604157028778ms (748.60kb)
Zstandard inflate: 1.427485349777271ms
Zlib: 71.92575378983747ms (1.60mb)
Zlib inflate: 7.377285900947754ms
```
