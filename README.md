# MBFC Scraper

A web scraper written in Ruby which scrapes [Media Bias Fact Check](https://mediabiasfactcheck.com)
for news sources' bias and level of factual reporting and outputs
the results in a json file called `mbfc.json`

The biases I focus on are:
- Left
- Left-Center
- Center
- Right-Center
- Right

The factual reporting scale values are:
- VERY HIGH
- HIGH
- MOSTLY FACTUAL
- MIXED
- LOW
- VERY LOW