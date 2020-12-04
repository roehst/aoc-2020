#!/usr/bin/python3

REQUIRED_KEYS = ["iyr", "byr", "ecl", "pid", "hcl", "eyr", "hgt"]
ALLOWED_EYE_COLORS = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]

def has_required_keys(record):
	return all(
		k in record for k in REQUIRED_KEYS
	)

def all_values_are_valid(record):
	
	byr = int(record["byr"])
	iyr = int(record["iyr"])	
	eyr = int(record["eyr"])	

	ecl = record["ecl"]
	hcl = record["hcl"]
	pid = record["pid"]
	hgt = record["hgt"]

	if not 1920 <= byr <= 2002: return False
	if not 2010 <= iyr <= 2020: return False
	if not 2020 <= eyr <= 2030: return False

	if hcl[0] != '#': return False
	if any([c not in "0123456789abcdef" for c in hcl[1:]]): return False

	if ecl not in ALLOWED_EYE_COLORS: return False

	if any([c not in "0123456789" for c in pid]): return False
	if len(pid) != 9: return False

	if hgt[-2:] == "cm":
		if not 150 <= int(hgt[:-2]) <= 193:
			return False
	elif hgt[-2:] == "in":
		if not 59 <= int(hgt[:-2]) <= 76:
			return False
	else:
		return False

	return True


def main():

	lines = open("../inputs/Day4.txt", "r").readlines()

	records = []
	record = {}

	for line in lines:
		if line == "\n":
			records.append(record)
			record = {}
		else:
			pairs = line.split(" ")
			for pair in pairs:
				pair = pair.split(":")
				(key, value) = pair
				record[key] = value.strip()

	records.append(record)

	

	valid1 = 0
	valid2 = 0

	for record in records:
		if has_required_keys(record):
			valid1 += 1
			if all_values_are_valid(record):
				valid2 += 1

	print(valid1)
	print(valid2)

if __name__ == '__main__':
	main()