from pathlib import Path
import hashlib,json,re,sys
root=Path(__file__).resolve().parent.parent
manifest=json.loads((root/'FILE_MANIFEST.json').read_text(encoding='utf-8'))
bad=[]
for name,digest in manifest['sha256'].items():
 p=root/name
 if not p.is_file() or hashlib.sha256(p.read_bytes()).hexdigest()!=digest:bad.append(name)
if bad:print('FAIL',bad);sys.exit(1)
print('PASS',len(manifest['sha256']),'packaged file hashes')
generated=root/'generated/motion_can_hidden_regenerated.bit'
if generated.exists():
 original=root/'program/motion_can_hidden_20261104_5a5d32b2.bit'
 clean=lambda data:re.sub(rb'^# Date:.*\n',b'',data,flags=re.M)
 if clean(original.read_bytes())!=clean(generated.read_bytes()):raise SystemExit('FAIL regenerated configuration differs')
 print('PASS regenerated bit is identical except Date header')
