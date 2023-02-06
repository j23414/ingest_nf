#! /usr/bin/env python

"""Expecting a genbank.ndjson with a "length":"1000" attribute or similar
Leave one blank line.  The rest of this docstring should contain an
overall description of the module or program.  Optionally, it may also
contain a brief description of exported classes and functions and/or usage

Input: genbank.ndjson
Output: stdout with only records that are greater than the minimum length

examples.
  Typical usage example:
"""

# ===== Dependencies
import argparse
import os
import sys

import re

# (2) Define command line arguments


def parse_args():
    # Main help command
    parser = argparse.ArgumentParser(
        description="Harmonize and merge pandas DataTables such that conflicting data is not lost."
    )
    parser.add_argument(
        "--genbank_ndjson", help="Path to genbank_ndjson where each record is on an independent line.", required=True)
    parser.add_argument(
        "--min_length", help="Minimum length to filter the data by.", default=5000, required=False)
    return parser.parse_args()

# (3) Define functions


def _check_min_length(line, min_length):
    m_str = re.search(r'"Length": "\d+"', line.strip()).group(0)
    m = re.search(r'\d+', m_str).group(0)
    # print("match: {}".format(m))
    if int(m) > int(min_length):
        return True
    else:
        return False

# (4) Define main function


def main():
    args = parse_args()

    with open(args.genbank_ndjson, 'r') as file:
        for line in file:
            criteria_bool = _check_min_length(
                line, args.min_length)  # && _other_criteria(line)
            if (criteria_bool):
                print(line.strip())


if __name__ == "__main__":
    main()
