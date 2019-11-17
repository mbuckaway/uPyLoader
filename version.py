#!/usr/bin/env python3
from src.utility.versioning import Versioning

AppVerName="uPyLoader " + Versioning.get_version_string()

if __name__ == '__main__':
    print(AppVerName)

