import pandas as pd 
import numpy as np 
import datetime
from datetime import datetime


d_transaction = pd.read_csv('dummy_transaction_data.csv', dtype={'ym6':object, 'company_number':object, 'q':np.double})
resp_master = pd.read_csv('dummy_resp_master.csv', dtype={'company_number':object, 'person_name':object, 'division':object})


t0 = datetime.now()
d = d_transaction.merge(resp_master, on='company_number')
print(d.shape)
print(datetime.now() - t0)

t0 = datetime.now()
d2 = d.\
    groupby(['company_number']).\
        agg(n=('q', 'count'), x1=('q', 'sum'), x2=('q', 'min'), x3=('q', 'max'), x4=('q', 'mean'))
print(d2.shape)
print(datetime.now() - t0)

t0 = datetime.now()
d['tmp_ym6'] = pd.to_datetime(d['ym6']+'01')
d['tmp_ym6_prev'] = d['tmp_ym6'] + pd.tseries.offsets.DateOffset(months=1)
d3 = d.merge(d, left_on=['tmp_ym6_prev', 'company_number'], right_on=['tmp_ym6', 'company_number'])
print(d3.shape)
print(datetime.now() - t0)
