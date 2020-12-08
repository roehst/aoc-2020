#!python3

# from collections import namedtuple

# import pprint

RAW = open("../inputs/Day7.txt", "r").read()

rules = RAW.split("\n")


def rule_outer(rule):
    return rule.split(" ")[0] + " " + rule.split(" ")[1]


def rule_inner(rule):
    if "no other bags" in rule:
        return {}

    rule = rule.split("contain")[1]
    rule = rule.split(",")
    rule = [make_rule(r.strip()) for r in rule]

    return {
        k: v for k, v in rule
    }


def make_rule(rule):

    r = rule.split(" ")
    count = int(r[0])
    name = rule.split(" ")[1:3]
    name = " ".join(name)

    return (name, count)


def parse_rule(line):
    return {
        "outer_bag": rule_outer(line),
        "contents": rule_inner(line)
    }


def parse_rules(rules):

    for rule in rules:
        outer_color = rule_outer(rule)
        inner = rule_inner(rule)
        for (inner_color, count) in inner.items():
            yield (outer_color, inner_color, count)


def step1(rules):

    rules = list(parse_rules(rules))

    queue = ['shiny gold']
    visited = set()

    while len(queue) > 0:
        cur = queue.pop()
        visited.add(cur)
        for (outer, inner, _) in rules:
            if inner == cur:
                queue.append(outer)

    return len(visited) - 1


def step2(rules):

    def recur(parent):
        total = 1
        for (outer, inner, count) in rules:
            if outer == parent:
                total += count * recur(inner)

        return total

    rules = list(parse_rules(rules))

    return recur('shiny gold') - 1


print(step1(rules))
print(step2(rules))
