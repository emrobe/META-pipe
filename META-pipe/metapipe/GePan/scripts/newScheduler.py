#!/usr/bin/env python2.7
import sys
import argparse
import math
from collections import deque
#from collections import deque
import os
import cProfile

class sequence:
  def __init__(self, seq_id):
    self.seq_id = seq_id
    self.sequence = ""
    self.length = len(self.seq_id)

  def add_line(self, line):
    self.sequence += line
    self.length += len(line)

  def print_all(self):
    return self.seq_id + self.sequence

  def get_length(self):
    return self.length

def main(args):
  parser = argparse.ArgumentParser(description='Split a fasta file into several smaller ones')
  # Input file
  parser.add_argument('-i', '--input', required=True, help='Fasta file to be split')
  parser.add_argument('-o', '--output', required=True, help='Output directory')
  parser.add_argument('-n', '--number', required=True, help='Number of files to generate')
  options = parser.parse_args(args)

  inputFile = open(options.input)
  sequenceList = deque()
  current_entry = ""
  for line in inputFile:
    if(line.startswith(">")):
      if(current_entry != ""):
        sequenceList.append([current_entry.get_length(), current_entry.print_all()])
      current_entry = sequence(line)
    else:
      current_entry.add_line(line)

  #sequenceList = deque(sorted(sequenceList))

  print "Number of sequences: " + str(len(sequenceList))

  fileList = list()
  for i in range(0, int(options.number)):
    fileList.append([])

  while(sequenceList):
    for i in range(0,int(options.number)):
      if(len(sequenceList) > 1):
        fileList[i].append(sequenceList.pop()[1])
        fileList[i].append(sequenceList.popleft()[1])
      elif len(sequenceList) == 1:
        fileList[i].append(sequenceList.pop()[1])
        break
      else:
        break

  if not os.path.isdir(options.output):
    os.makedirs(options.output)

  for i in range(0,int(options.number)):
    outFile = open(options.output + "/" + os.path.basename(options.input) + "." + str(i+1), "w")
    print "Number of sequences for file " + str(i) + " = " + str(len(fileList[i]))
    for item in fileList[i]:
      outFile.write(item)

if __name__ == "__main__":
  main(sys.argv[1:])
