#!/usr/bin/env python

from __future__ import print_function

import os
import sys
import yaml
import shutil
import argparse
import subprocess

TEST_LIST_FILE = "test.list"


class ArgParser(argparse.ArgumentParser):
    """
    Argument parser that displays help on error
    """

    def error(self, message):
        self.print_help()
        sys.stderr.write("\nError: {}\n".format(message))
        sys.exit(2)


def fail(msg):
    print("Error: {}".format(msg))
    sys.exit(1)


def load_cookbooks_from_file(handle):
    return [line.strip() for line in handle]


def get_cookbook_file(cookbook, *path):
    return os.path.join("cookbooks", cookbook, *path)


def validate_cookbooks(cookbooks):
    for cookbook in cookbooks:
        if not os.path.isfile(get_cookbook_file(cookbook, ".kitchen.yml")):
            fail("Invalid cookbook: '{}'".format(cookbook))


def validate_prerequisites():
    if not os.path.isfile(".kitchen.local.yml"):
        fail("Missing '.kitchen.local.yml' file.")


def prepare_env():
    for item in (".kitchen.yml", ".kitchen", "test"):
        if os.path.isfile(item) or os.path.islink(item):
            os.unlink(item)
        if os.path.isdir(item):
            shutil.rmtree(item)


def load_cookbook_suites(cookbook):
    kitchen_yml = get_cookbook_file(cookbook, ".kitchen.yml")
    with open(kitchen_yml, "r") as k:
        suites = yaml.load(k)["suites"]
        for s in suites:
            s["cookbook"] = cookbook
    return suites


def load_suites(cookbooks):
    all_suites = []
    for cookbook in cookbooks:
        all_suites.extend(load_cookbook_suites(cookbook))
    return all_suites


def transform_name(cookbook, name):
    return "{}_{}".format(cookbook, name)


def copy_tests(suites):
    for s in suites:
        source = get_cookbook_file(s["cookbook"], "test",
                                   "integration", s["name"])
        target = os.path.join("test", "integration",
                              transform_name(s["cookbook"], s["name"]))
        shutil.copytree(source, target)


def write_kitchen_file(suites):
    for s in suites:
        s["name"] = transform_name(s["cookbook"], s["name"])
        del s["cookbook"]
    with open(".kitchen.yml", "w") as k:
        yaml.safe_dump(dict(suites=suites), k, default_flow_style=False)


def execute_kitchen(concurrency, destroy):
    cmd = ["kitchen", "test", "-c", str(concurrency), "-d", destroy]
    print("Executing kitchen command: {}".format(" ".join(cmd)))
    return subprocess.call(cmd)


def create_parser():
    parser = ArgParser(description="Blueprint data extractor")

    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("-l", "--list", help="Cookbook list",
                       type=argparse.FileType("r"))
    group.add_argument("-c", "--cookbook", action="append",
                       help="Cookbook name (can be used multiple times)")

    parser.add_argument("-p", "--concurrency", default=3,
                        help="Concurrency level (default: 3)")
    parser.add_argument("-d", "--destroy", default="always",
                        help="Destroy strategy (default: always)")
    return parser


def main():
    parser = create_parser()
    args = parser.parse_args()
    if args.cookbook is None:
        cookbooks = load_cookbooks_from_file(args.list)
    else:
        cookbooks = args.cookbook

    validate_cookbooks(cookbooks)
    validate_prerequisites()
    prepare_env()
    suites = load_suites(cookbooks)
    copy_tests(suites)
    write_kitchen_file(suites)

    status = execute_kitchen(args.concurrency, args.destroy)

    sys.exit(status)


if __name__ == "__main__":
    main()
