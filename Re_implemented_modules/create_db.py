import sqlite3
import argparse
from collections import defaultdict
import time


class UniProtFile:
  def __init__(self, filename):
    self.f = open(filename)
    

  def get_entry(self):
    retVal = defaultdict(str)
    done = False
    while(not done):
      line = self.f.readline()
      if(line.startswith("//") or not line):
        break
      if(not line.startswith("  ")):
        retVal[line[0:2]] = retVal[line[0:2]] + line[3:]
      else:
        retVal["SEQ"] = retVal["SEQ"] + line[3:]
    return retVal

class DB:
  def __init__(self, filename, output):
    self.c = sqlite3.connect(output)
    self.f = UniProtFile(filename)
    self.init_db()

  def init_db(self):
    self.c.execute("PRAGMA synchronous = OFF")
    self.c.execute("PRAGMA journal_mode = MEMORY")
    self.c.execute("CREATE TABLE db (ID text, AC text, DT text, DE text, GN text, OS text, OG text, OC text, OX text, OH text, RN text, RP text, RC text, RX text, RG text, RA text, RT text, RL text, CC text, DR text, PE text, KW text, FT text, SQ text, SEQ text)")
    self.c.commit()
  
  def populate_db(self):

    prev_i = 0
    prev_time = time.time()
    done = False
    i = 0
    conn = self.c.cursor()
    while(not done):
      i += 1
      entry = self.f.get_entry()
      if(len(entry) < 1):
        print("DONE")
        done = True
      entry_tuple = (entry["ID"], entry["AC"], entry["DT"], entry["DE"], entry["GN"], entry["OS"], entry["OG"], entry["OC"], entry["OX"], entry["OH"], entry["RN"], entry["RP"], entry["RC"], entry["RX"], entry["RG"], entry["RA"], entry["RT"], entry["RL"], entry["CC"], entry["DR"], entry["PE"], entry["KW"], entry["FT"], entry["SQ"], entry["SEQ"])
      conn.execute("INSERT INTO db VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", entry_tuple)
      if (i % 10000) == 0:
        cur_time = time.time()
        time_taken = cur_time - prev_time
        IPS = (i - prev_i) / time_taken
        self.c.commit()
        print "Current entry: " + str(i) + " (" + str(int(IPS)) + " inserts per second)"
        prev_i = i
        prev_time = cur_time
    conn.execute("CREATE INDEX pk ON db (ID)")
    self.c.commit()

if __name__ == "__main__":
  parser = argparse.ArgumentParser(description="Create SQLite DBs from UniProt databases")

  parser.add_argument("-f", "--file", dest="filename", help="Input file (database)")
  parser.add_argument("-o", "--output", dest="output", help="Output filename", default="db/db")

  args = parser.parse_args()

  uf = UniProtFile(args.filename)

  db = DB(args.filename, args.output)
  db.populate_db()
