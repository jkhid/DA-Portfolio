#!/usr/bin/env python
# coding: utf-8

# In[ ]:


#Import necessary libraries

from bs4 import BeautifulSoup
import requests
import smtplib
import time
import datetime


# In[141]:


#Connect to URL

URL = 'https://www.sephora.com/product/the-true-cream-aqua-bomb-P394639?skuId=1686427&icid2=products%20grid:p394639:product'

headers = {"User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36"}

page = requests.get(URL, headers=headers, cookies={'__hs_opt_out': 'no'})

soup1 = BeautifulSoup(page.content, "html.parser")

soup2 = BeautifulSoup(soup1.prettify(), "html.parser")

#Scrape title and price from page

title = soup2.find('span', {'data-at':"product_name"}).get_text()

price = soup2.find('b', {'class':"css-0"}).text.strip()


print(title)
print(price)


# In[142]:


#Clear spacing between text

price = price.strip()[1:]
title = title.strip()

print(price)
print(title)


# In[ ]:


#Import datetime and create 'today' variable

import datetime

today = datetime.date.today()

print(today)


# In[143]:


# Create CSV with necessary headers

import csv


header = ['Title', 'Price', 'Date']
data = [title, price, today]


with open('AmazonWebScraping.csv', 'w', newline='', encoding='UTF8') as f:
    writer = csv.writer(f)
    writer.writerow(header)
    writer.writerow(data)
    


# In[144]:


import pandas as pd

df = pd.read_csv(r'/users/jk/AmazonWebScraping.csv')

print(df)


# In[118]:


# Append data to csv

with open('AmazonWebScraping.csv', 'a+', newline='', encoding='UTF8') as f:
    writer = csv.writer(f)
    writer.writerow(data)

if(float(price) < 30):
    send_mail()


# In[145]:


#Combine code into one function

def check_price():
    URL = 'https://www.sephora.com/product/the-true-cream-aqua-bomb-P394639?skuId=1686427&icid2=products%20grid:p394639:product'

    headers = {"User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36"}

    page = requests.get(URL, headers=headers, cookies={'__hs_opt_out': 'no'})

    soup1 = BeautifulSoup(page.content, "html.parser")

    soup2 = BeautifulSoup(soup1.prettify(), "html.parser")
    
    title = soup2.find('span', {'data-at':"product_name"}).get_text()

    price = soup2.find('b', {'class':"css-0"}).text.strip()
    
    price = price.strip()[1:]
    title = title.strip()
    
    import datetime
    today = datetime.date.today()
    
    import csv
    
    header = ['Title', 'Price', 'Date']
    data = [title, price, today]
    
    with open('AmazonWebScraping.csv', 'a+', newline='', encoding='UTF8') as f:
        writer = csv.writer(f)
        writer.writerow(data)
    
    if(float(price) < 30):
        send_mail()


# In[ ]:


#Automically run check_price after sleep timer runs out 

while(True):
    check_price()
    time.sleep(3600)


# In[ ]:


import pandas as pd

df = pd.read_csv(r'/users/jk/AmazonWebScraping.csv')

#print(df)


# In[147]:


#Automatically send an email if price falls below parameter 

def send_mail():
    server = smtplib.SMTP_SSL('smtp.gmail.com', 465)
    server.ehlo()
    #server.starttls()
    server.ehlo()
    server.login('Jamal.Khidir@gmail.com','bajlpagylzefmmbx')
    
    subject = "Belif Aqua Bomb Mosturizer is on sale on Amazon!"
    body = "Jamal, your web scraper has detected your face mosturizer is on sale on Amazon! Consider buying it while it lasts. Link here: https://www.amazon.com/belif-Moisturizer-Combination-Hydration-Beauty/dp/B085JNJG9V/ref=sr_1_3?keywords=belif&qid=1677539392&sprefix=belif%2Caps%2C171&sr=8-3"
   
    msg = f"Subject: {subject}\n\n{body}"
    
    server.sendmail(
        'Jamal.Khidir@gmail.com',
        'Jamal.Khidir@gmail.com',
        msg
     
    )


# In[ ]:




