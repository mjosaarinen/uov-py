#   uov-py

2024-06-01  Markku-Juhani O. Saarinen  mjos@iki.fi

A simple Python implementation of the ["UOV: Unbalanced Oil and Vinegar"](https://csrc.nist.gov/csrc/media/Projects/pqc-dig-sig/documents/round-1/spec-files/UOV-spec-web.pdf) scheme which is a candidate in the first round of the [NIST PQC Signature On-Ramp](https://csrc.nist.gov/Projects/pqc-dig-sig/round-1-additional-signatures)

This implementation supports all parameter sets in the specification, and also the public and secret key compression methods. Here are the basic parameters (GF, n, m) and the public key, secret key, and signature sizes in bytes.

| Parameter set   |  GF |   n |  m |      PK |      SK | Sig |
|-----------------|-----|-----|----|---------|---------|-----|
| uov-Ip-classic  | 256 | 112 | 44 |  278432 |  237896 | 128 |
| uov-Ip-pkc      | 256 | 112 | 44 |   43576 |  237896 | 128 |
| uov-Ip-pkc+skc  | 256 | 112 | 44 |   43576 |      48 | 128 |
| uov-Is-classic  |  16 | 160 | 64 |  412160 |  348704 |  96 |
| uov-Is-pkc      |  16 | 160 | 64 |   66576 |  348704 |  96 |
| uov-Is-pkc+skc  |  16 | 160 | 64 |   66576 |      48 |  96 |
| uov-III-classic | 256 | 184 | 72 | 1225440 | 1044320 | 200 |
| uov-III-pkc     | 256 | 184 | 72 |  189232 | 1044320 | 200 |
| uov-III-pkc+skc | 256 | 184 | 72 |  189232 |      48 | 200 |
| uov-V-classic   | 256 | 244 | 96 | 2869440 | 2436704 | 260 |
| uov-V-pkc       | 256 | 244 | 96 |  446992 | 2436704 | 260 |
| uov-V-pkc+skc   | 256 | 244 | 96 |  446992 |      48 | 260 |

##  Implementation Notes

The implementation is self-contained in file ([uov.py](uov.py)). You will need Python3 with AES and SHAKE crypto primitives; try `pip3 install pycryptodome` if those are not installed.

There is hardly any optimization as the main purpose of this implementation was to clarify the understanding of the algorithm. However, the m-length vectors of finite field elements are expressed as a single Python integer in functions such as `gf_mulm`. This makes the code run faster, but I think it also makes the code more readable.

Some [minor](https://github.com/pqov/pqov/issues/25) [modifications](https://github.com/pqov/pqov/issues/26) have been made to match the test vectors of the submission.

##  Running Known Answer Tests

The known answer testbench ([kat_test.py](kat_test.py)) can be executed via `python3 kat_test.py` and checked against the provided KAT checksums.

The [kat](kat) directory contains various test vectors extracted from the NIST submission package. The `*.rsp1` files just contain the first entry of each response file. Due to the large size of keys in the KAT files, sha256 hashes are provided for 1, 10, and 100 entries in files [kat1.txt](kat/kat1.txt), [kat10.txt](kat/kat10.txt), and [kat100.txt](kat/kat100.txt), respectively.

The KAT tester computes sha256 hashes of KAT output in the same format as the NIST .rsp file. It takes about one minute to print just the checksums for the first vector for each variant, but you may modify the `katnum` variable in [kat_test.py](kat_test.py) to produce hashes of more vectors.


**Example:*** Create a run log file `run1.log`:
```
$ python3 kat_test.py | tee run1.log
# 0/1 OV(256,112,44)-classic
d53d0ea65c6aab0d3db7ef97773e812c163df2e7ffd653026771ce4645a2d04e OV(256,112,44)-classic (1)
# 0/1 OV(256,112,44)-cpk
6ba39a15d7f470efb5de43cbee775580a50119c0f20cf386dc825daf04b5eeed OV(256,112,44)-cpk (1)
# 0/1 OV(256,112,44)-cpk-csk
28f2928243e5a482b5a9fd5cb25e5fedf9269a9d28ac9f30ba0b348fe4fe430e OV(256,112,44)-cpk-csk (1)
# 0/1 OV(16,160,64)-classic
951ffbd80f23ea057ab23295ae501ef5de1ca6fce57c0a42ff47b08ae61904ce OV(16,160,64)-classic (1)
# 0/1 OV(16,160,64)-cpk
af59b4f126fbbfa18a870cf744c47fd478b43483ca0f15b1d1b06008adac08db OV(16,160,64)-cpk (1)
# 0/1 OV(16,160,64)-cpk-csk
78820642f96629c33d07147743401b95f3b4bddc34330e09cf6920a2623d9387 OV(16,160,64)-cpk-csk (1)
# 0/1 OV(256,184,72)-classic
0194107c2edde95aa0e4b7a6f007dfcbef9e14541ef0e01e7f4944a46283e953 OV(256,184,72)-classic (1)
# 0/1 OV(256,184,72)-cpk
24f07458259cd7389a6bff05b1e31fa8916410bc4bb7fc3980c3901879335529 OV(256,184,72)-cpk (1)
# 0/1 OV(256,184,72)-cpk-csk
ee82708d1431c556fe4da9c6f3896f7c948d9eb0b9fa4e6149f318bb5f815b28 OV(256,184,72)-cpk-csk (1)
# 0/1 OV(256,244,96)-classic
38353b7db221e43344914c1d563ed776b2a1a3603b139f2493053dac458b13db OV(256,244,96)-classic (1)
# 0/1 OV(256,244,96)-cpk
cad81f7aa697d2ff4b7f35779a522c771af8c6ae4fcab74a8b1ab5b23c91af78 OV(256,244,96)-cpk (1)
# 0/1 OV(256,244,96)-cpk-csk
d02b0e6ddfdba333933b1d156536b98656482c400c7c0690b7d6917fd0f7c8a3 OV(256,244,96)-cpk-csk (1)
```

We can compare the sha256 hashes as follows:
```
$ cat run1.log kat/kat1.txt | grep -v '#' | sort
0194107c2edde95aa0e4b7a6f007dfcbef9e14541ef0e01e7f4944a46283e953 - III/PQCsignKAT_1044320.rsp
0194107c2edde95aa0e4b7a6f007dfcbef9e14541ef0e01e7f4944a46283e953 OV(256,184,72)-classic (1)
24f07458259cd7389a6bff05b1e31fa8916410bc4bb7fc3980c3901879335529 - III_pkc/PQCsignKAT_1044320.rsp
24f07458259cd7389a6bff05b1e31fa8916410bc4bb7fc3980c3901879335529 OV(256,184,72)-cpk (1)
... etc
```
Since the hashes match, the test was a success.

