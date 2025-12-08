import os
import tempfile
from glob import glob
from argparse import ArgumentParser

DEFAULTBASEPATH = os.path.dirname(os.path.realpath(__file__))
DEFAULTLANG = "english"
CANDIDATES = ["all", "kast", "jara", "kaiser", "matthei", "parisi", "artes", "enriquez-ominami", "mayne-nichols"]
TASKS = ["voteintention", "support", "criticims"]
KINDS = ["multiple", "binary"]

ap = ArgumentParser()
ap.add_argument('--basepath', type=str, default=DEFAULTBASEPATH)
ap.add_argument('--language', type=str, default=DEFAULTLANG)
ap.add_argument('--task', type=str, default=TASKS[0], choices=TASKS)
ap.add_argument('--kind', type=str, default=KINDS[0], choices=KINDS)
ap.add_argument('--candidate', type=str, default=CANDIDATES[0], choices=CANDIDATES)
ap.add_argument('--week', type=int, required=True)

args = ap.parse_args()
basepath = args.basepath
language = args.language
task = args.task
candidate = args.candidate
kind = args.kind
week = args.week

if kind == "binary" and candidate == "all":
    raise ValueError(f"Invalid candidate 'all' for kind 'binary'.")

path_pattern = os.path.join(
    basepath,
    "annotations/Mistral-Small-24B-Instruct-2501-seed33/guided",
    task,
    kind,
    candidate,
    f"week_{week}_twitter_candidates_mentions_4annotation",
    language,
    "llm_answer_*.csv")

finalcsv = os.path.join(
    basepath,
    "annotations/Mistral-Small-24B-Instruct-2501-seed33/guided",
    task,
    kind,
    candidate,
    f"annotations_week_{week}_{task}_{kind}_{candidate}_{language}.csv")

text2annotatepath = os.path.join(
     basepath,
     "text4annotate",
     f"week_{week}_twitter_candidates_mentions_4annotation.csv")

files = glob(path_pattern)
if len(files) == 0:
    raise ValueError(f"Din't find and file with pattern {path_pattern}")
maxfilenb = max([int(f.split("_")[-1].split('.')[0]) for f in files])

csvfiles = [os.path.join(
    basepath,
    "annotations/Mistral-Small-24B-Instruct-2501-seed33/guided/",
    task,
    kind,
    candidate,
    f"week_{week}_twitter_candidates_mentions_4annotation",
    language,
    f"llm_answer_{n}.csv")
    for n in range(maxfilenb+1)
    ]

missing = [p for p in csvfiles if not os.path.exists(p)]
if len(missing) > 0:
    m = "\n".join(missing)
    raise ValueError(f"Mising csv files:\n{m}")


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