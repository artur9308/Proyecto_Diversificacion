import pandas as pd
from db import get_engine

engine = get_engine()

df = pd.read_sql("SELECT * FROM cultivos", engine)

print(df.head())