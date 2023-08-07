
To read:

- https://stackoverflow.com/questions/37614410/comparison-between-lz4-vs-lz4-hc-vs-blosc-vs-snappy-vs-fastlz

## Conclusions

- LZ4 is the one adding the smallest delay, but doesn't provide much compression in general.
- Zstandard has the best compression vs speed.
- Brotli performance is just short of Zstandard. It's widely deployed in web browsers ([see](https://caniuse.com/brotli)).
- Zlib is too slow, but compresses well and it's widely deployed. Some [improvements exist](https://aws.amazon.com/blogs/opensource/improving-zlib-cloudflare-and-comparing-performance-with-other-zlib-forks/) but they're not benchmarked here.

## Results

These are benchmarks performed with the Silesia corpus.

1) dickens

```
docker run --rm -ti -e ITIMES=100 -e FILE=silesia/dickens compress
Reading file silesia/dickens
Data len: 9.72mb
LZ4: 56.919ms (6.15mb)
LZ4 inflate: 12.302ms
Snappy: 184.937ms (6.05mb)
Snappy inflate: 53.490ms
Zstandard: 69.670ms (3.51mb)
Zstandard inflate: 14.228ms
Brotli: 112.616ms (3.72mb)
Brotli inflate: 34.677ms
Zlib: 546.711ms (3.69mb)
Zlib inflate: 43.740ms
```

2) xml

```
docker run --rm -ti -e ITIMES=100 -e FILE=silesia/xml compress
Reading file silesia/xml
Data len: 5.10mb
LZ4: 9.063ms (1.29mb)
LZ4 inflate: 4.369ms
Snappy: 36.480ms (1.25mb)
Snappy inflate: 12.469ms
Zstandard: 14.750ms (624.63kb)
Zstandard inflate: 4.473ms
Brotli: 26.410ms (737.48kb)
Brotli inflate: 10.454ms
Zlib: 91.828ms (671.87kb)
Zlib inflate: 11.561ms
```

3) x-ray

```
docker run --rm -ti -e ITIMES=100 -e FILE=silesia/x-ray compress
Reading file silesia/x-ray
Data len: 8.08mb
LZ4: 24.311ms (7.69mb)
LZ4 inflate: 9.071ms
Snappy: 5.774ms (8.07mb)
Snappy inflate: 3.348ms
Zstandard: 81.069ms (5.80mb)
Zstandard inflate: 14.406ms
Brotli: 88.524ms (5.91mb)
Brotli inflate: 48.221ms
Zlib: 346.275ms (5.77mb)
Zlib inflate: 50.946ms
```

4) mozilla

```
docker run --rm -ti -e ITIMES=20 -e FILE=silesia/mozilla compress
Reading file silesia/mozilla
Data len: 48.41mb
LZ4: 120.898ms (25.20mb)
LZ4 inflate: 54.767ms
Snappy: 551.041ms (25.45mb)
Snappy inflate: 167.293ms
Zstandard: 255.143ms (17.65mb)
Zstandard inflate: 99.806ms
Brotli: 455.840ms (17.69mb)
Brotli inflate: 203.454ms
Zlib: 1935.054ms (18.20mb)
Zlib inflate: 212.710ms
```


## Old results

_Note: not up to date with the current Dockerfile_

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
