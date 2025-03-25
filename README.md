#   uov-py

2024-06-01  Markku-Juhani O. Saarinen  mjos@iki.fi

2025-03-25  Updated to Round 2 -- mjos@iki.fi

A simple Python implementation of the ["UOV: Unbalanced Oil and Vinegar"](https://csrc.nist.gov/csrc/media/Projects/pqc-dig-sig/documents/round-2/spec-files/uov-spec-round2-web.pdf) scheme which is a candidate in the second round of the [NIST PQC Signature On-Ramp](https://csrc.nist.gov/Projects/pqc-dig-sig/round-2-additional-signatures)

This implementation supports all parameter sets in the specification, and also the public and secret key compression methods. Here are the basic parameters (GF, n, m) and the public key, secret key, and signature sizes in bytes.

| Parameter set   |  GF |   n |  m |      PK |      SK | Sig |
|-----------------|-----|-----|----|---------|---------|-----|
| uov-Ip          | 256 | 112 | 44 |  278432 |  237896 | 128 |
| uov-Ip-pkc      | 256 | 112 | 44 |   43576 |  237896 | 128 |
| uov-Ip-pkc+skc  | 256 | 112 | 44 |   43576 |      32 | 128 |
| uov-Is          |  16 | 160 | 64 |  412160 |  348704 |  96 |
| uov-Is-pkc      |  16 | 160 | 64 |   66576 |  348704 |  96 |
| uov-Is-pkc+skc  |  16 | 160 | 64 |   66576 |      32 |  96 |
| uov-III         | 256 | 184 | 72 | 1225440 | 1044320 | 200 |
| uov-III-pkc     | 256 | 184 | 72 |  189232 | 1044320 | 200 |
| uov-III-pkc+skc | 256 | 184 | 72 |  189232 |      32 | 200 |
| uov-V           | 256 | 244 | 96 | 2869440 | 2436704 | 260 |
| uov-V-pkc       | 256 | 244 | 96 |  446992 | 2436704 | 260 |
| uov-V-pkc+skc   | 256 | 244 | 96 |  446992 |      32 | 260 |

##  Implementation Notes

The implementation is self-contained in file ([uov.py](uov.py)). You will need Python3 with AES and SHAKE crypto primitives; try `pip3 install pycryptodome` if those are not installed.

There is hardly any optimization as the main purpose of this implementation was to clarify the understanding of the algorithm. However, the m-length vectors of finite field elements are expressed as a single Python integer in functions such as `gf_mulm`. This makes the code run faster, but I think it also makes the code more readable.

Some [minor](https://github.com/pqov/pqov/issues/25) [modifications](https://github.com/pqov/pqov/issues/26) have been made to match the test vectors of the submission.

##  Running Known Answer Tests

The known answer testbench ([kat_test.py](kat_test.py)) can be executed via `python3 kat_test.py` and checked against the provided KAT checksums.

The [kat](kat) directory contains various test vectors extracted from the NIST submission package. The `*.rsp.1` files just contain the first entry of each response file. Due to the large size of keys in the KAT files, sha256 hashes are provided for 1, 10, and 100 entries in files [kat1.txt](kat/kat1.txt), [kat10.txt](kat/kat10.txt), and [kat100.txt](kat/kat100.txt), respectively.

The KAT tester computes sha256 hashes of KAT output in the same format as the NIST .rsp file. It takes about one minute to print just the checksums for the first vector for each variant, but you may modify the `katnum` variable in [kat_test.py](kat_test.py) to produce hashes of more vectors.


**Example:*** Create a run log file `run1.log`:
```
$ python3 kat_test.py | tee run1.log
# 0/1 OV(256,112,44)-classic
5e055716f1c5627a463821032754588788ea0936af6999e981fdd4c9687ecf3e OV(256,112,44)-classic (1)
# 0/1 OV(256,112,44)-pkc
4faaa60017839dbefd70b772019200e064aafe67abf65f821926afa66f5013d7 OV(256,112,44)-pkc (1)
# 0/1 OV(256,112,44)-pkc-skc
287235330008a590278a106423e3596bbf1035eb1d0276c4b44c370e6eb0044a OV(256,112,44)-pkc-skc (1)
# 0/1 OV(16,160,64)-classic
8a75ba48fd6f250e0e6e2eb68e77a54620f11b2c3fce9aae4601c491157e6862 OV(16,160,64)-classic (1)
# 0/1 OV(16,160,64)-pkc
10d81a0d23a102aa98b4ade3ec895d2d0efb11bf6a5e19bc1637496bff6aa7e6 OV(16,160,64)-pkc (1)
# 0/1 OV(16,160,64)-pkc-skc
aacf0751c2d25c3404595d56a5ce60281f1e1002d42770c37008cb517dbd4976 OV(16,160,64)-pkc-skc (1)
# 0/1 OV(256,184,72)-classic
794427d6cc5b49779f9d4428bdb68702d61a77d76bc5c040082c3f53838661e4 OV(256,184,72)-classic (1)
# 0/1 OV(256,184,72)-pkc
c292f77f564551ac93959d77c644f7c4d989c2e38e5a0d5d3034b13f2eb791b5 OV(256,184,72)-pkc (1)
# 0/1 OV(256,184,72)-pkc-skc
6f94dd3e385ce97cb06b1eb6994bfe925538df3eb954ee0576cabd7babddeba5 OV(256,184,72)-pkc-skc (1)
# 0/1 OV(256,244,96)-classic
1655a654ff4b751a527403d3ea05abbfc3740913a3adf87075782f8076646146 OV(256,244,96)-classic (1)
# 0/1 OV(256,244,96)-pkc
253d2bd64189440ed8f8f71ab3ac637b20d9409be897fd816ac52f376d1e2ab3 OV(256,244,96)-pkc (1)
# 0/1 OV(256,244,96)-pkc-skc
759ea9c46d0b89c7d707ab9b58394541bc0df65d6b3291722a1a6a7171a9dd89 OV(256,244,96)-pkc-skc (1)
```

We can compare the sha256 hashes as follows:
```
$ cat run1.log kat/kat1.txt | grep -v '#' | sort
10d81a0d23a102aa98b4ade3ec895d2d0efb11bf6a5e19bc1637496bff6aa7e6  Is-pkc/PQCsignKAT_348704.rsp.1
10d81a0d23a102aa98b4ade3ec895d2d0efb11bf6a5e19bc1637496bff6aa7e6 OV(16,160,64)-pkc (1)
1655a654ff4b751a527403d3ea05abbfc3740913a3adf87075782f8076646146  V/PQCsignKAT_2436704.rsp.1
1655a654ff4b751a527403d3ea05abbfc3740913a3adf87075782f8076646146 OV(256,244,96)-classic (1)
253d2bd64189440ed8f8f71ab3ac637b20d9409be897fd816ac52f376d1e2ab3  V-pkc/PQCsignKAT_2436704.rsp.1
253d2bd64189440ed8f8f71ab3ac637b20d9409be897fd816ac52f376d1e2ab3 OV(256,244,96)-pkc (1)
... etc
```
Since the hashes match, the test was a success.

