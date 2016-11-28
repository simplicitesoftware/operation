![Simplicit&eacute; Software](https://www.simplicite.io/resources/logos/logo250.png)
***

Operation tools for Simplicit&eacute;&reg;
===============================================

This are examples of operation tools for Simplicit&eacute;&reg; instances.

These shell scripts have been developped on Linux CentOS, there are easily transposable to other platforms.

* `healthcheck.sh <URL>` this script calls the health chack page of the designated instance using the `curl` tool, it parses status and memory information and records it in a log and in a CSV data file
* `healthchecks.sh <URLs file>` this script loops on all URLs stored in designated file and calls `healthcheck.sh` for each of them

NB: to be able to send emails using `mailx` the scripts needs a `operation` account to be configured in the operation user's `$HOME/.mailrc`.
