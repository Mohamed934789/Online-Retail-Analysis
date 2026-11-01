import pandas as pd
from analytics import prepare, monthly_net, cancellation_counts, customer_rfm

def test_invoice_counts_signed_revenue_and_shared_period_preparation():
    raw=pd.DataFrame({"Invoice":["1","1","C2","C2","3"], "InvoiceDate":["2010-01-01"]*4+["2011-01-01"],
      "Quantity":[2,1,-1,-2,1], "Price":[10,20,10,10,50], "Country":["UK"]*5,
      "Description":["A","B","A","B","A"], "Customer ID":[1]*5})
    frame=prepare(raw)
    assert cancellation_counts(frame).loc[2010] == 1
    assert monthly_net(frame).loc[pd.Period("2010-01")] == 10
    assert monthly_net(frame).loc[pd.Period("2011-01")] == 50
    assert customer_rfm(frame).loc[1,"frequency"] == 2
    assert customer_rfm(frame).loc[1,"monetary"] == 90
