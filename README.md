
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
docker run --rm -ti -e ITIMES=100 compress-benchmark:ruby3.3.9 'bundle exec ruby --yjit main.rb /silesia/dickens'
Reading file /silesia/dickens
Data len: 9.72mb
LZ4: 32.702ms (6.15mb)
LZ4 inflate: 17.644ms
Snappy: 132.492ms (6.05mb)
Snappy inflate: 41.213ms
Zstd-1: 26.477ms (4.06mb)
Zstd-1 inflate: 9.570ms
Zstd-4: 49.744ms (3.42mb)
Zstd-4 inflate: 11.261ms
Brotli: 82.658ms (3.72mb)
Brotli inflate: 37.165ms
Zlib: 414.434ms (3.69mb)
Zlib inflate: 46.343ms
```

2) xml

```
docker run --rm -ti -e ITIMES=100 compress-benchmark:ruby3.3.9 'bundle exec ruby --yjit main.rb /silesia/xml'
Reading file /silesia/xml
Data len: 5.10mb
LZ4: 7.731ms (1.29mb)
LZ4 inflate: 6.282ms
Snappy: 28.516ms (1.25mb)
Snappy inflate: 7.221ms
Zstd-1: 6.389ms (677.07kb)
Zstd-1 inflate: 2.378ms
Zstd-4: 8.621ms (619.06kb)
Zstd-4 inflate: 2.302ms
Brotli: 18.537ms (736.21kb)
Brotli inflate: 10.255ms
Zlib: 64.514ms (671.87kb)
Zlib inflate: 12.541ms
```

3) x-ray

```
docker run --rm -ti -e ITIMES=100 compress-benchmark:ruby3.3.9 'bundle exec ruby --yjit main.rb /silesia/x-ray'
Reading file /silesia/x-ray
Data len: 8.08mb
LZ4: 15.135ms (7.69mb)
LZ4 inflate: 13.947ms
Snappy: 5.521ms (8.07mb)
Snappy inflate: 3.469ms
Zstd-1: 14.115ms (6.46mb)
Zstd-1 inflate: 9.817ms
Zstd-4: 54.878ms (5.45mb)
Zstd-4 inflate: 11.807ms
Brotli: 74.181ms (5.92mb)
Brotli inflate: 50.842ms
Zlib: 265.727ms (5.77mb)
Zlib inflate: 50.808ms
```

4) mozilla

```
docker run --rm -ti -e ITIMES=100 compress-benchmark:ruby3.3.9 'bundle exec ruby --yjit main.rb /silesia/mozilla'
Reading file /silesia/mozilla
Data len: 48.41mb
LZ4: 100.558ms (25.20mb)
LZ4 inflate: 73.902ms
Snappy: 392.703ms (25.45mb)
Snappy inflate: 125.362ms
Zstd-1: 96.873ms (19.04mb)
Zstd-1 inflate: 46.931ms
Zstd-4: 173.880ms (17.21mb)
Zstd-4 inflate: 49.329ms
Brotli: 287.462ms (17.68mb)
Brotli inflate: 189.017ms
Zlib: 1534.911ms (18.20mb)
Zlib inflate: 196.240ms
```
