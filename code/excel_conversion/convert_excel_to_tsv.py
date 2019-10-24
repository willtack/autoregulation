import pandas as pd
import os
import sys

try:
    excelfile = sys.argv[1]
except IOError:
    print("No excel file specified.")
    sys.exit(1)

#Read excel file into a dataframe
data_xlsx = pd.read_excel(excelfile, 'Sheet1', index_col=None)

#Replace all fields having line breaks with space
df = data_xlsx.replace('\n', ' ',regex=True)

#Write dataframe into csv
name = os.path.basename(excelfile).split('.')[0]
df.to_csv(name + '_tsv.tsv', sep='\t', encoding='utf-8',  index=False, line_terminator='\r\n')
