# Online Retail II Analysis

Python transaction analysis and SQL Server customer/product queries with existing dashboard screenshots.

## Reproduce
Python 3.12: install `requirements.txt`, then run `python scripts/download_data.py` and open
`Analysis.ipynb` from this repository directory. The explicit download fetches UCI's original
two-sheet workbook and refuses to overwrite an existing input. Alternatively set `RETAIL_INPUT`
to your authorized workbook/CSV. Raw input and local customer-level outputs are ignored.

Source: Chen, D. (2012), Online Retail II, UCI, https://doi.org/10.24432/C5CG6D,
[CC BY 4.0 dataset](https://archive.ics.uci.edu/dataset/502/online+retail+ii).
Attribution applies to the upstream dataset, not an invented project code license.

Both workbook periods pass through one preparation function. Revenue is GBP and signed net revenue
includes returns. Cancellation counts are distinct C-prefixed invoices, not all boolean rows.
RFM is explicitly positive, non-cancelled purchases by known customers. The SQL script separates
view creation into SQL Server batches. Import the generated cleaned CSV as `sales_table` first.
Four dashboard screenshots remain available; no editable PBIX source is committed.

Run `python -m pip install -r requirements-dev.txt` then `python -m pytest -q` for synthetic
transaction regressions. No SQL Server connection or Power BI refresh is performed by these tests.
