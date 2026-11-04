"""Run the packaged two-frame display contract with local ModelSim binaries."""
from pathlib import Path
import argparse,hashlib,json,re,subprocess,sys

parser=argparse.ArgumentParser()
parser.add_argument('--modelsim-bin',default='C:/modeltech64_2020.4/win64')
args=parser.parse_args()
root=Path(__file__).resolve().parent.parent
out=root/'generated/display_test';out.mkdir(parents=True,exist_ok=False)
hdl=root/'project/user_source/hdl_source'
files=[root/'sim/tb_hidden_display.v',hdl/'motion_trial_osd.v',hdl/'osd_char_lib.v']
binary=Path(args.modelsim_bin)
commands=[('library',[binary/'vlib.exe','work']),('compile',[binary/'vlog.exe','-work','work']+files),
 ('run',[binary/'vsim.exe','-c','-voptargs=+acc','-onfinish','exit','work.tb_hidden_display','-do',
 'onerror {quit -code 1}; onbreak {quit -code 1}; run -all; quit -code 0'])]
codes=[]
for name,command in commands:
 with (out/(name+'.log')).open('w',encoding='utf-8') as log:
  process=subprocess.run(list(map(str,command)),cwd=out,stdout=log,stderr=subprocess.STDOUT,
   creationflags=getattr(subprocess,'CREATE_NO_WINDOW',0),timeout=600)
 codes.append(process.returncode)
 if process.returncode:break
text=(out/'run.log').read_text(encoding='utf-8',errors='replace') if (out/'run.log').exists() else ''
passed=codes==[0,0,0] and 'PASS' in text and not re.search(r'\bFAIL\b|\*\* (Error|Fatal)',text)
record={'passed':passed,'exit_codes':codes,'observations':[line for line in text.splitlines() if 'PASS' in line or 'FAIL' in line]}
(out/'verification.json').write_text(json.dumps(record,indent=2),encoding='utf-8')
print(json.dumps(record,indent=2))
sys.exit(0 if passed else 1)
