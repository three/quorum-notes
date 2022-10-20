# Double Entry Accounting for Developers
Double entry accounting was developed as a way to keep track of money and debt with written record. Today, where most cash is not physical, double entry accounting roughly defines what cash is. My goal here is to walk through double entry accounting from a developer's point of view, which is different than how the information would be presented in an accountanting textbook, but with enough context to understand accounting.

## The Paper Database
When considering how to keep track of our money, our tools are pen and paper.

## The Skeleton
I'm going to split up this discussion into two categories: the skeleton and the meat. The skeleton is going to be more idealized, and is going to let me make generalizations that are more broad than what comes later. The meat is where skeleton hits the real world.

## Single Entry Accounting
Single entry accounting let's you keep track of the contents of one "account". For our purposes, the word account just means a pile of money. In this example you can imagine an account as a checking account, but in the future an account will also represent liabilities, expenses and more.

In single entry accounting, the account can have any number of transactions. Transactions add or remove money from an account. We can represent the transactions in a table like so,

|Date|Description|Credit (Withdrawal)|Debit (Deposit)|
|-|-|-|-|
|1/1|Initial Deposit||100.00|
|2/1|Deposit Cash||100.00|
|2/5|Buy Groceries|50.00||

Most people have seen single entry accounting in some form or another, but it's important to note a few rules and possible differences that are going to matter before we get to double entry.

First, **accounts can be credited by a positive amount or debited by a positive amount**. In other words, no negatives. Even though this is equivilent in having a single column that can be positive or negative, defining transactions in double entry is easier coming from ths definition.

Second, **we call withdrawals credits and deposits debits**. The terms credit and debit are more general than withdrawals and deposits, and the latter terms will not make sense for other types of accounts.

Third, **the balance is derived from the transactions not part of them**. I didn't include the balance to illustrate this point, but you were to actually hand-write a ledger you'd almost always want to include a running balance. Here's what the ledger looks like if we include the balance.

|Date|Description|Credit (Withdrawal)|Debit (Deposit)|Balance|
|-|-|-|-|-|
|1/1|Initial Deposit||100.00|100.00|
|2/1|Deposit Cash||100.00|200.00|
|2/5|Buy Groceries|50.00||150.00|

Specifically, **the balanace at specific point in time is the sum of debits minus the sum of credits at or prior to that point in time**. If we have multiple transactions on a particular date and want the balance for that date we need to find the last transaction listed for that date, and grab that running balance. Note, **the balance of an account prior to any transactions is always 0**. If we want an initial balance, we need to create an Initial Balance transaction.

## Single Entry on Paper
Accounting developed before computers, so it gives some context to understand how they worked on pen and paper. We can think of pen and paper as the original database. All the data we add to it must be tabular. Adding an entry to the end of the database is cheap, and all other operations are expensive in the worst case.

Since people make mistakes, people have developed less-than-linear time ways to fix mistakes that would otherwise require rewriting the entire record. We're going to ignore the finer points of keeping paper records and assume the only cheap operation is adding a row.

Another important point to our physical record, is we want the ability to archive old records. If it's Q1 of 2022 than we probably don't care about transactions from Q3 of 2004. We want our records for this quarter to be self contained so we can focus on them during the quarter and put those records safely in storage afterward.

Given this constraints we're going to create a ledger to keep track of our checking accont for this quarter.