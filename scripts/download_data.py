"""Fetch the attributed UCI dataset on explicit user execution; never overwrite input."""
from pathlib import Path
import urllib.request
import zipfile
import tempfile
URL = "https://archive.ics.uci.edu/static/public/502/online+retail+ii.zip"
if __name__ == "__main__":
    target = Path(__file__).resolve().parents[1] / "data/raw/online_retail_II.xlsx"
    target.parent.mkdir(parents=True, exist_ok=True)
    if target.exists(): raise SystemExit("Input exists; no overwrite performed")
    with tempfile.TemporaryDirectory() as work:
        archive = Path(work)/"data.zip"
        urllib.request.urlretrieve(URL, archive)
        with zipfile.ZipFile(archive) as z:
            member = next(n for n in z.namelist() if Path(n).name.lower() == "online_retail_ii.xlsx")
            with target.open("xb") as out: out.write(z.read(member))
    print(target)
