import pandas as pd


def create_index(variable):
    variable = variable.upper()
    sms[variable] = sms["v2"].str.upper().str.count(variable)
    return

def count_digits(x):   
    return sum(c.isdigit() for c in x)

sms = pd.read_csv("C:/Udemy/Pro Data Science in Python/SMS spam/spam.csv",encoding = "ISO-8859-1")
create_index("FREE")
create_index("WINNER")
create_index("REMINDER")
create_index("CONTRACT")
create_index("MOBILE")
create_index("URGENT")
create_index("IMPORTANT")
create_index("PRIVATE")
create_index("CALL")
create_index("SEX")
create_index("GUARANTEED")
create_index("CONGRATS")
create_index("DATING")
create_index("CASH")
create_index("CUSTOMER")
create_index("SMS")
create_index("ACCOUNT")
create_index("HEY")
create_index("AWARDED")
create_index("WON")
create_index("CHOSEN")
create_index("WOULD")
create_index("WIND")
create_index("HORNY")
create_index("INVITING")
create_index("CHOSEN")
create_index("SHOPPING")
create_index("ENTITLED")
create_index("WANT")
create_index("ENTRY")
create_index("SECRET")
create_index("DISCOUNT")
create_index("MESSAGE")
create_index("IMPORTANT")
create_index("XXX")
create_index("GIRLS")
create_index("CONTACT")


sms["spam"]     = sms["v1"]=="spam"
sms["spam"]     = sms["spam"].astype(int)
sms["exc_mark"] = sms["v2"].str.upper().str.count("!")
sms["digits"]   = sms["v2"].apply(lambda x: count_digits(x))


data = sms[["FREE","WINNER","REMINDER","CONTRACT","MOBILE","URGENT","IMPORTANT","PRIVATE","CALL","SEX","GUARANTEED",
            "CONGRATS","DATING","CASH","CUSTOMER","SMS","ACCOUNT","HEY","AWARDED","WON","CHOSEN","WOULD",
            "WIND","HORNY","INVITING","CHOSEN","SHOPPING","ENTITLED","WANT","ENTRY","SECRET","DISCOUNT",
            "MESSAGE","IMPORTANT","exc_mark","XXX","GIRLS","CONTACT","digits"]].values.reshape(5572,39)
import numpy as np
from sklearn.naive_bayes import MultinomialNB
from sklearn.cross_validation import cross_val_score
clf = MultinomialNB()
clf.fit(data,sms["spam"].values)
MultinomialNB(alpha=1.0, class_prior=None, fit_prior=True)
sms["prediction"] = clf.predict(data)
scores = cross_val_score(clf, data, sms["spam"].values, cv=15)
print("Accuracy: %0.2f (+/- %0.2f)" % (scores.mean(), scores.std() * 2))
