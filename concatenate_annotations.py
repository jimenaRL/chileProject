import os
import tempfile
from glob import glob
from argparse import ArgumentParser

DEFAULTBASEPATH = "/sps/humanum/user/jroyolet/dev/chileProject/annotations/Mistral-Small-24B-Instruct-2501-seed1/guided/voteintention/multiple"
DEFAULTLANG = "english"

ap = ArgumentParser()
ap.add_argument('--basepath', type=str, default=DEFAULTBASEPATH)
ap.add_argument('--language', type=str, default=DEFAULTLANG)
ap.add_argument('--week', type=int, required=True)

args = ap.parse_args()
basepath = args.basepath
language = args.language
week = args.week

path_pattern = os.path.join(
    basepath,
    f"week_{week}_twitter_candidates_mentions_4annotation",
    language,
    "llm_answer_*.csv")

finalcsv = os.path.join(
    basepath,
    f"annotations_week_{week}_{language}.csv")

text2annotatepath = os.path.join(
     "/sps/humanum/user/jroyolet/dev/chileProject/",
     f"text4annotate/week_{week}_twitter_candidates_mentions_4annotation.csv")

maxfilenb = max([int(p.split("_")[-1].split('.')[0]) for p in glob(path_pattern)])

csvfiles = [os.path.join(
    basepath,
    f"week_{week}_twitter_candidates_mentions_4annotation",
    language,
    f"llm_answer_{n}.csv")
    for n in range(maxfilenb+1)
    ]

with tempfile.NamedTemporaryFile() as tmp:
    with open(tmp.name, "w") as f:
        f.write('\n'.join(csvfiles))
    os.system(f'xan cat rows --paths {tmp.name} > {finalcsv}')

os.system(f"xan head {finalcsv} | xan v")

print("# annotations:")
os.system(f"xan count {finalcsv}")
print("# original tweets:")
os.system(f"xan count {text2annotatepath}")
print(f"Concatenated translations save at {finalcsv}")
