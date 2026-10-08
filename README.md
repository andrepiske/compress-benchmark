
To read:

- https://stackoverflow.com/questions/37614410/comparison-between-lz4-vs-lz4-hc-vs-blosc-vs-snappy-vs-fastlz

## Conclusions

- LZ4 is pretty much on par with Zstd level 1, but the latter has lower inflate time overall.
- Zstandard has the best compression vs speed.
- Brotli performance is just short of Zstandard. It's widely deployed in web browsers ([see](https://caniuse.com/brotli)).
- Zlib is too slow, but compresses well and it's widely deployed. Some [improvements exist](https://aws.amazon.com/blogs/opensource/improving-zlib-cloudflare-and-comparing-performance-with-other-zlib-forks/) but they're not benchmarked here.

## Results

These are benchmarks performed with the Silesia corpus.

1) dickens

```
docker run --rm -ti -e ITIMES=100 andrepiske/compress-benchmark:ruby4.0.7 'bundle exec ruby --yjit main.rb /silesia/dickens'
Reading file /silesia/dickens
Data len: 9.72mb
```

| Process | Mac M1 | Ryzen 5 |
|---|---|---|
| LZ4 | 28.319ms (6.15mb) | 28.319ms (6.15mb) |
| LZ4 inflate | 14.029ms | 14.029ms |
| Snappy | 132.535ms (5.96mb) | 132.535ms (5.96mb) |
| Snappy inflate | 51.406ms | 51.406ms |
| Zstd-1 | 30.004ms (4.06mb) | 30.004ms (4.06mb) |
| Zstd-1 inflate | 10.616ms | 10.616ms |
| Zstd-4 | 55.394ms (3.42mb) | 55.394ms (3.42mb) |
| Zstd-4 inflate | 12.662ms | 12.662ms |
| Brotli | 82.937ms (3.72mb) | 82.937ms (3.72mb) |
| Brotli inflate | 29.823ms | 29.823ms |
| Zlib | 441.368ms (3.69mb) | 441.368ms (3.69mb) |
| Zlib inflate | 38.169ms | 38.169ms |

2) xml

```
docker run --rm -ti -e ITIMES=100 andrepiske/compress-benchmark:ruby4.0.7 'bundle exec ruby --yjit main.rb /silesia/xml'
Reading file /silesia/xml
Data len: 5.10mb
```

| Process | Mac M1 | Ryzen 5 |
|---|---|---|
| LZ4 | 8.003ms (1.29mb) | 6.801ms (1.29mb) |
| LZ4 inflate | 7.037ms | 5.116ms |
| Snappy | 29.907ms (1.24mb) | 29.886ms (1.24mb) |
| Snappy inflate | 7.166ms | 9.796ms |
| Zstd-1 | 7.777ms (677.07kb) | 7.883ms (677.07kb) |
| Zstd-1 inflate | 2.406ms | 2.632ms |
| Zstd-4 | 10.171ms (619.06kb) | 10.212ms (619.06kb) |
| Zstd-4 inflate | 2.471ms | 2.674ms |
| Brotli | 19.550ms (736.21kb) | 19.268ms (736.21kb) |
| Brotli inflate | 12.148ms | 7.983ms |
| Zlib | 64.881ms (671.87kb) | 68.604ms (671.87kb) |
| Zlib inflate | 12.408ms | 9.302ms |

3) x-ray

```
docker run --rm -ti -e ITIMES=100 andrepiske/compress-benchmark:ruby4.0.7 'bundle exec ruby --yjit main.rb /silesia/x-ray'
Reading file /silesia/x-ray
Data len: 8.08mb
```

| Process | Mac M1 | Ryzen 5 |
|---|---|---|
| LZ4 | 16.103ms (7.69mb) | 15.577ms (7.69mb) |
| LZ4 inflate | 15.112ms | 10.698ms |
| Snappy | 6.820ms (8.07mb) | 7.861ms (8.07mb) |
| Snappy inflate | 4.402ms | 5.105ms |
| Zstd-1 | 15.352ms (6.46mb) | 12.871ms (6.46mb) |
| Zstd-1 inflate | 10.923ms | 9.953ms |
| Zstd-4 | 56.727ms (5.45mb) | 63.385ms (5.45mb) |
| Zstd-4 inflate | 11.101ms | 12.827ms |
| Brotli | 77.481ms (5.92mb) | 76.119ms (5.92mb) |
| Brotli inflate | 53.707ms | 38.517ms |
| Zlib | 271.053ms (5.77mb) | 233.829ms (5.77mb) |
| Zlib inflate | 48.434ms | 37.324ms |


4) mozilla

```
docker run --rm -ti -e ITIMES=100 andrepiske/compress-benchmark:ruby4.0.7 'bundle exec ruby --yjit main.rb /silesia/mozilla'
Reading file /silesia/mozilla
Data len: 48.41mb
```

| Process | Mac M1 | Ryzen 5 |
|---|---|---|
| LZ4 | 106.966ms (25.20mb) | 88.738ms (25.20mb) |
| LZ4 inflate | 89.256ms | 60.080ms |
| Snappy | 410.886ms (25.34mb) | 422.651ms (25.34mb) |
| Snappy inflate | 128.113ms | 169.918ms |
| Zstd-1 | 108.642ms (19.04mb) | 115.817ms (19.04mb) |
| Zstd-1 inflate | 49.525ms | 58.955ms |
| Zstd-4 | 185.310ms (17.21mb) | 199.291ms (17.21mb) |
| Zstd-4 inflate | 51.077ms | 63.769ms |
| Brotli | 297.567ms (17.68mb) | 304.151ms (17.68mb) |
| Brotli inflate | 213.047ms | 177.187ms |
| Zlib | 1573.943ms (18.20mb) | 1439.158ms (18.20mb) |
| Zlib inflate | 219.990ms | 160.307ms |
